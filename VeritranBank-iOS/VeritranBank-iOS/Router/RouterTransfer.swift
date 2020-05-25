//
//  Router.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/25/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import VeritranBankEngine

class RouterTransfer: TransferControllerProtocol{
    
    let vc: UIViewController
    let senderAccount: Account
    let accountListController: AccountListController
    
    init(vc: UIViewController,
         senderAccount: Account,
         accountListController: AccountListController) {
        self.vc = vc
        self.senderAccount = senderAccount
        self.accountListController = accountListController
    }
    
    func userPressedTransferButton() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let accountlistVc = storyBoard.instantiateViewController(identifier: "AccountListViewController") as! AccountListViewController

        if let vc = vc as? AccountListControllerDelegate {
            accountListController.delegate = vc
        }
        
        accountlistVc.accountsController = accountListController
        accountListController.vc = accountlistVc
        vc.present(accountlistVc, animated: true, completion: nil)
    }
}
    
