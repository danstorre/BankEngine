//
//  SceneDelegate.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/23/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import VeritranBankEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var routerTransfer: RouterTransfer?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //set up bank
        let bank = Bank()
        
        //set up account
        let account = Account(id: "Daniel", balance: try! Money(value: 100, currency: "USD"))
        bank.addAccount(account)
        
        //setup otherAccounts
        let account1 = Account(id: "francisco", balance: try! Money(value: 100, currency: "USD"))
        let account2 = Account(id: "Lien", balance: try! Money(value: 100, currency: "USD"))
        let account3 = Account(id: "Someone From China", balance: try! Money(value: 100, currency: "¥"))
        
        bank.addAccount(account1)
        bank.addAccount(account2)
        bank.addAccount(account3)
        
        //presesnter
        let presenter = AccountPresenter(account: AccountPresentable(account: account))
        // Override point for customization after application launch.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountVc = storyboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        //controller
        let controller = AccountController(vc: accountVc, account: account)
        
        accountVc.presenter = presenter
        accountVc.controller = controller
        
        
        //set up AccountListControlelr
        let accountListController = AccountListController(bank: bank,
                                                          senderAccount: account)
        
        //set up routerTransfer
        routerTransfer = RouterTransfer(vc: accountVc,
                                            senderAccount: account,
                                            accountListController: accountListController)
        
        //setup transfer controller events
        accountVc.transferController = routerTransfer
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = accountVc
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }


}

