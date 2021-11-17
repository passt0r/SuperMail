//
//  MailProvider.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 07.11.2021.
//

import UIKit
import CoreData

/////Classes that implementing this protocol should provide services for direct working with mails at persistance storage: read all emails info and provide actions to the delegate when any changes occur.
//protocol MailProvider {
//    var delegate: MailProviderDelegate? { get }
//    func loadData() throws
//    var mailsCount: Int { get }
//    subscript(item: Int) -> MailInfoModel { get }
//}
//
/////Classes that implementing this protocol should react on any changes that MailProvider provides.
//protocol MailProviderDelegate: AnyObject {
//    func mailDeleted(at index: Int)
//    func add(mail: MailInfoModel, at index: Int)
//    func update(mail: MailInfoModel, at index: Int)
//    func mailSortOrderChanged()
//}

class MailFetchController: NSObject, MailProvider {
    let mailStorage: MailCoreDataController
    weak var delegate: MailProviderDelegate?
    
    lazy var fetchResultController: NSFetchedResultsController<SavedMail> = {
        let request = NSFetchRequest<SavedMail>(entityName: "SavedMail")
        let predicate = NSPredicate(format: "isDeletedMail == %@", NSNumber(booleanLiteral: true))
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        let fetchController = NSFetchedResultsController<SavedMail>(fetchRequest: request,
                                                                    managedObjectContext: mailStorage.persistentContainer.viewContext,
                                                                    sectionNameKeyPath: nil,
                                                                    cacheName: nil)
        fetchController.delegate = self
        
        return fetchController
    }()
    
    init(mailStorage: MailCoreDataController) {
        self.mailStorage = mailStorage
        super.init()
    }
    
    func loadData() throws {
        try fetchResultController.performFetch()
    }
    
    var mailsCount: Int {
        return fetchResultController.sections?[0].numberOfObjects ?? 0
    }
    
    subscript(item: Int) -> MailInfoModel {
        let indexPath = IndexPath(row: item, section: 0)
        let fetchedObject = fetchResultController.object(at: indexPath)
        return MailInfoModel(from: fetchedObject)
    }
}

extension MailFetchController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        
        switch type {
            // TODO: Add reactions on different objects changes
        case .delete:
            delegate?.mailDeleted(at: indexPath.row)
        default:
            break
        }
    }
}

private extension MailInfoModel {
    init(from mail: SavedMail) {
        let mailID = mail.uuid?.uuidString ?? ""
        self.mailId = mailID
        self.date = mail.date ?? .init()
        self.fromAdress = mail.from ?? ""
        self.subject = mail.subject ?? ""
        self.snippet = mail.content_preview ?? ""
        self.isRead = mail.isRead
        
        if let mailContent = mail.content {
            self.mailContent = .init(mailId: mailID, content: mailContent)
        }
    }
}
