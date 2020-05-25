//
//  AccountPresenter.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/23/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol AccountCurrencyPresentable: AccountPresenterProtocol {
    var currency: String { get }
}

class AccountPresenter: NSObject, AccountPresenterProtocol{
    let account: AccountCurrencyPresentable
    lazy var formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .default
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.currencySymbol = self.account.currency
        numberFormatter.positiveFormat = "0.00¤"
        return numberFormatter
    }()
    
    init(account: AccountCurrencyPresentable){
        self.account = account
        super.init()
    }
    var accountTitle: String {
        return "Account Id: \(account.accountTitle)"
    }
    var balance: String {
        guard let doubleNumber = Double(self.account.balance) else {
                return ""
        }
        let number = NSNumber(value: doubleNumber)
        return formatter.string(from: number) ?? ""
    }
}
