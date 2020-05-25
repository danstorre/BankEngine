//
//  AccountViewController.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/23/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol AccountPresenterProtocol: class {
    var accountTitle: String {get}
    var balance: String {get}
}

protocol AccountInteractions: class {
    func userPressedWithDrawButton(completion: @escaping(Error?) -> Void)
    func userPressedDepositButton(completion: @escaping(Error?) -> Void)
}

protocol TransferControllerProtocol: class {
    func userPressedTransferButton()
}

class AccountViewController: UIViewController {
    
    @IBOutlet var withdrawButton: UIButton!
    @IBOutlet var depositButton: UIButton!
    @IBOutlet var transferButton: UIButton!
    @IBOutlet var accountTitleLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    
    var presenter: AccountPresenterProtocol?
    var controller: AccountInteractions?
    weak var transferController: TransferControllerProtocol?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Account"
        accountTitleLabel.text = presenter?.accountTitle
        refreshBalance()
    }
    
    @IBAction func buttonWidthdrawPressed(sender: UIButton) {
        controller?.userPressedWithDrawButton(completion: { [weak self] (error) in
            
            if let error = error as? OperationError {
                switch error {
                case .AccountHasNoSufficientFunds:
                    self?.presentAlert(title: "Withdrawl Operation", and: "You don't have enough funds")
                case .AnyOtherError:
                    self?.presentAlert(title: "Withdrawl Operation Error", and: "Something went wrong, please try again.")
                }
            }
            self?.refreshBalance()
        })
    }
    
    private func presentAlert(title: String,
                              and message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonDepositPressed(sender: UIButton) {
        controller?.userPressedDepositButton(completion: { [weak self] (error) in
            self?.refreshBalance()
        })
    }
    
    @IBAction func buttonTransferPressed(sender: UIButton) {
        transferController?.userPressedTransferButton()
    }
    
    func refreshBalance(){
        balanceLabel.text = presenter?.balance
    }

}
