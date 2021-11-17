//
//  MailCoreDataController.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 20.10.2021.
//

import Foundation
import CoreData

typealias MailPersistanceService = MailPersistenceStorage & MailProvider

///Classes that implementing this protocol should provide services for working with persistance storage for saving emails alongside with their content.
protocol MailPersistenceStorage {
    func add(newMails: [MailInfoModel])
    func add(content: MailContentModel, to mail: MailInfoModel)
    func delete(mail: MailInfoModel)
    func read(mail: MailInfoModel)
    func save()
}

///Classes that implementing this protocol should provide services for direct working with mails at persistance storage: read all emails info and provide actions to the delegate when any changes occur.
protocol MailProvider {
    var delegate: MailProviderDelegate? { get }
    func loadData() throws
    var mailsCount: Int { get }
    subscript(item: Int) -> MailInfoModel { get }
}

///Classes that implementing this protocol should react on any changes that MailProvider provides.
protocol MailProviderDelegate: AnyObject {
    func mailDeleted(at index: Int)
    func add(mail: MailInfoModel, at index: Int)
    func update(mail: MailInfoModel, at index: Int)
    func mailSortOrderChanged()
}

final class MailCoreDataController: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SuperMail")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension MailCoreDataController: MailPersistenceStorage {
    func add(newMails: [MailInfoModel]) {
        //TODO: Add imp
    }
    
    func add(content: MailContentModel, to mail: MailInfoModel) {
        //TODO: Add imp
    }
    
    func delete(mail: MailInfoModel) {
        //TODO: Add imp
    }
    
    func read(mail: MailInfoModel) {
        //TODO: Add imp
    }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

private extension SavedMail {
    func create(with context: NSManagedObjectContext,
                from mail: MailInfoModel) -> SavedMail {
        let savedMail = SavedMail(context: context)
        savedMail.uuid = .init(uuidString: mail.mailId) ?? .init()
        savedMail.date = mail.date
        savedMail.from = mail.fromAdress
        savedMail.subject = mail.subject
        savedMail.content_preview = mail.snippet
        
        return savedMail
    }
}
