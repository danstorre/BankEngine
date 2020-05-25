//
//  AccountController.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/23/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit
import VeritranBankEngine

enum OperationError: Error{
    case AccountHasNoSufficientFunds
    case AnyOtherError
}

enum HelperMethods{
    static func returnValueFromTextField(alert: UIAlertController) -> Double {
        guard !(alert.textFields?.isEmpty ?? true) else {
            return 0
        }
        guard let textField = alert.textFields?[0],
            let text = textField.text,
            let value = Double(text) else{
                return 0
        }
        return value
    }
}

class AccountController: NSObject, AccountInteractions,
UITextFieldDelegate {
    let vc: UIViewController
    let account: Account
    
    init(vc: UIViewController, account: Account) {
        self.vc = vc
        self.account = account
    }
    
    func userPressedWithDrawButton(completion: @escaping (Error?) -> Void) {
        presentAlertFor(option: Options.widthdraw, completion: completion)
    }
    
    func userPressedDepositButton(completion: @escaping (Error?) -> Void) {
        presentAlertFor(option: Options.deposit, completion: completion)
    }
    
    enum Options{
        case deposit
        case widthdraw
    }
    
    func presentAlertFor(option: Options, completion: @escaping (Error?) -> Void) {
        var title: String
        var closure: (Double, UIAlertController) -> Void
        switch option {
        case .deposit:
            title = "Deposit"
            closure = {[weak self] (value: Double, alert: UIAlertController) in
                self?.depositAction(value: value, alert: alert)
                self?.finishOperation(completion)
            }
            
        case .widthdraw:
            title = "Withdraw"
            closure = {[weak self] (value: Double, alert: UIAlertController) in
                self?.widthDrawAction(value: value, alert: alert, completion: completion)
            }
            
        }
        let alert = FactoryAlert.getAlert(with: AlertOptions.withTextField(withDelegate: self,
                        title: title,
                        message: "Specify amount"))
        let depositAction = action(with: title)
        { [unowned alert] action in
            let value = HelperMethods.returnValueFromTextField(alert: alert)
            closure(value, alert)
        }
        alert.addAction(depositAction)
        vc.present(alert,
                   animated: false,
                   completion: nil)
    }
    
    func finishOperation(_ completion: @escaping(Error?)-> Void,
                         _ withError: Error? = nil) {
        completion(withError)
    }
    
    
    
    //MARK:- factory methods.
    private func action(with title: String,
                        completion: @escaping(UIAlertAction)->()) -> UIAlertAction {
        let action = UIAlertAction(title: title,
                                   style: .default)
        { (alertAction) in
            completion(alertAction)
        }
        return action
    }
    
    
    //MARK:- Actions
    func widthDrawAction(value: Double,
                         alert: UIAlertController,
                         completion: @escaping (Error?) -> Void) {
        let moneyToWidthDraw = try! Money(value: value,
                                          currency: account.balance.currency)
        do {
            try account.withdraw(money: moneyToWidthDraw)
            self.finishOperation(completion)
        } catch AccountError.AccountHasNoSufficientFunds {
            alert.message = "Insufficient Funds please try a lower amount."
            self.finishOperation(completion, OperationError.AccountHasNoSufficientFunds)
        } catch _ {
            fatalError()
        }
    }
    
    func depositAction(value: Double,
                       alert: UIAlertController) {
        let moneyToBeDeposit = try! Money(value: value,
                                          currency: account.balance.currency)
        do {
            try account.deposit(money: moneyToBeDeposit)
        } catch _ {
            fatalError()
        }
    }
    
}
