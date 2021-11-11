//
//  SceneDelegate.swift
//  SuperMail
//
//  Created by Dmytro Pasinchuk on 17.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mailPersistenceStorage: MailPersistenceStorage?
    var userManager: UserManager?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let userManager = provideUserInfoManager()
        // Only for test purposes
        configureMock(with: userManager)
        let persistance = providePersistance()
        let networkController = provideNetwork()
        let mailModel = MailModel(mailStorage: persistance.storage,
                                  mailProvider: persistance.provider,
                                  networkService: networkController,
                                  userManager: userManager)
        self.mailPersistenceStorage = persistance.storage
        window.rootViewController = provideMainViewController(with: mailModel)
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        mailPersistenceStorage?.save()
    }


}

private extension SceneDelegate {
    func providePersistance() -> (storage: MailPersistenceStorage,
                                  provider: MailProvider) {
        let storage = MailCoreDataController()
        let provider = MailFetchController(mailStorage: storage)
        return (storage: storage, provider: provider)
    }
    
    func provideNetwork() -> MailNetwork {
        let mockConfiguration = URLSessionConfiguration.ephemeral
        mockConfiguration.protocolClasses = [MailURLProtocol.self]
        let session = URLSession(configuration: mockConfiguration)
        let networkSession = NetworkURLSession(with: session)
        return MailNetworkService(session: networkSession)
    }
    
    func configureMock(with userManager: UserManager) {
        MailURLProtocol.mocks = {
            guard let mailListFilePath = Bundle.main.path(forResource: "mailList", ofType: "json"),
                  let mailContentFilePath = Bundle.main.path(forResource: "mailContent", ofType: "json") else {
                      assertionFailure("Mock files could not found")
                      return [:]
                  }
            let mailListPath = MailListRequest(service: .test,
                                               userInfo: userManager.getUserInfo()).apiAbsoluteURL
            let mailDetailPath = MailDetailRequest(service: .test,
                                                   userInfo: userManager.getUserInfo(),
                                                   mailID: "").apiAbsoluteURL
            guard let mailListURL = URL(string: mailListPath),
                  let mailDetailURL = URL(string: mailDetailPath) else {
                      assertionFailure("Mock files url invalid")
                      return [:]
                  }
            do {
                var mocks: [URL : Result<Data, Error>] = [:]
                let mailListData = try Data(contentsOf: URL(fileURLWithPath: mailListFilePath))
                let mailDetailData = try Data(contentsOf: URL(fileURLWithPath: mailContentFilePath))
                mocks[mailListURL] = .success(mailListData)
                mocks[mailDetailURL] = .success(mailDetailData)
                
                return mocks
            } catch {
                assertionFailure("Mock files parsing error")
                return [:]
            }
        }
    }
    
    func provideUserInfoManager() -> UserManager {
        return UserManager()
    }
    
    func provideMainViewController(with mailModel: MailModel) -> UIViewController {
        let mailListViewController = MailListViewController()
        let mailListNavigationController = UINavigationController(rootViewController: mailListViewController)
        
        let mailDetailViewController = MailDetailViewController()
        let mailDetailNavigationController = UINavigationController(rootViewController: mailDetailViewController)
        
        let splitViewController = SplitViewController()
        splitViewController.viewControllers = [mailListNavigationController, mailDetailNavigationController]
        return splitViewController
    }
}
