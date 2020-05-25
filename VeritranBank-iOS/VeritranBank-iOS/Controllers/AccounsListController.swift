//
//  AccounsListController.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/24/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import VeritranBankEngine

enum AccountListControllerError: Error {
    case SenderAndRecipientShouldMatchCurrencies
    case SendSenderHaveNoSufficientFunds
}

protocol AccountListControllerDelegate: class {
    func didFinishWithErrors(error: Error)
    func didFinish()
}

extension AccountViewController: AccountListControllerDelegate {
    func didFinishWithErrors(error: Error) {
        dismiss(animated: true)
        let error = error as! AccountListControllerError
        let message: String
        switch error {
        case .SenderAndRecipientShouldMatchCurrencies:
            message = "Account currencies must match"
        case .SendSenderHaveNoSufficientFunds:
            message = "Your account have no sufficient funds"
        }
        let alert = UIAlertController(title: "Transfer Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default, handler: nil))
        present(alert,
                animated: true,
                completion: nil)
    }
    
    func didFinish() {
        dismiss(animated: true)
        
        let alert = UIAlertController(title: "Transfer Finished",
                                      message: "Transfer Successful",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default, handler: nil))
        present(alert,
                animated: true,
                completion: nil)
        
        refreshBalance()
    }
}

class AccountListController: AccountListControllerProtocol{
    
    let bank: Bank
    let senderAccount: Account
    var vc: UIViewController?
    weak var delegate: AccountListControllerDelegate?
    
    init(bank: Bank,
         senderAccount: Account,
         vc: UIViewController? = nil,
         delegate: AccountListControllerDelegate? = nil) {
        self.bank = bank
        self.vc = vc
        self.senderAccount = senderAccount
        self.delegate = delegate
    }
    func getCount() -> Int {
        return bank.accounts?.filter({ (dict) -> Bool in
            return dict.key != senderAccount.id
        }).count ?? 0
    }
    func getTitleAtIndex(_ index: Int) -> String {
        guard let account = getAccount(at: index) else {
            return ""
        }
        return "Account with id: \(account.id) with balance \(account.balance.value) \(account.balance.currency)"
    }
    func selectedAccountAtIndex(_ index: Int) {
        guard let account = getAccount(at: index) else {
            return
        }
        let alert = FactoryAlert.getAlert(with: AlertOptions.withTextField(withDelegate: nil, title: "Transfer to \(account.id)", message: "Specify amount to be transfered"))
        
        let action = UIAlertAction(title: "Transfer",
                                   style: .default)
        { [unowned alert, weak self] (alertAction) in
            let value = HelperMethods
                .returnValueFromTextField(alert: alert)
            guard let self = self else {return}
            guard let recipientAccount = self.getAccount(at: index) else {fatalError()}
            self.transferAction(value: value, to: recipientAccount)
        }
        alert.addAction(action)
        vc?.present(alert,
                   animated: true,
                   completion: nil)
    }
    
    //MARK:- Actions
    func transferAction(value: Double,
                        to recipientAccount: Account) {
        let moneyToTransfer = try! Money(value: value,
                                currency: senderAccount.balance.currency)
        
        let transferOperation = Transfer(with: senderAccount,
                                         to: recipientAccount)
        
        do {
            try transferOperation.makeTransfer(of: moneyToTransfer)
            delegate?.didFinish()
        } catch TransferError.MoneyTransferredMustHaveSameCurrencyFromRecipient {
            delegate?
                .didFinishWithErrors(error: AccountListControllerError.SenderAndRecipientShouldMatchCurrencies )
        } catch TransferError.MoneyTransferredMustHaveSameCurrencyFromSender {
            delegate?
            .didFinishWithErrors(error:
                AccountListControllerError
                .SenderAndRecipientShouldMatchCurrencies)
        } catch TransferError.SenderHaveNoSufficientFunds {
            delegate?
            .didFinishWithErrors(error:
                AccountListControllerError
                .SendSenderHaveNoSufficientFunds)
        } catch _ {
            fatalError()
        }
        
    }

    private func getAccount(at index: Int) -> Account? {
        guard let accountsUnfiltered = bank.accounts else {
           return nil
       }
        let accounts = accountsUnfiltered.filter({ (dict) -> Bool in
            return dict.key != senderAccount.id
        })
       let id = accounts.keys.sorted()[index]
       guard let account = accounts[id] else {
           return nil
       }
        return account
    }
}
