//
//  AppDelegate.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/23/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import VeritranBankEngine

class AccountPresentable: AccountCurrencyPresentable {
    let account: Account
    init(account: Account) {
        self.account = account
    }
    var currency: String {
        return account.balance.currency
    }
    
    var accountTitle: String {
        return account.id
    }
    
    var balance: String {
        return String(account.balance.value)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

