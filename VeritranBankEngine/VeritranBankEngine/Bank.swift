//
//  BankAccount.swift
//  VeritranBankEngine
//
//  Created by Daniel Torres on 5/18/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

open class Bank {
    open private (set) var accounts: [String:Account]?
    
    public init(accounts: [String:Account]? = nil) {
        self.accounts = accounts
    }
    
    public func has(_ account: Account) -> Bool {
        guard let accounts = accounts else {
            return false
        }
        return accounts.keys.contains(account.id)
    }
    
    public func addAccount(_ account: Account) {
        guard var accounts = accounts else {
            self.accounts = [account.id: account]
            return
        }
        if !has(account) {
            accounts[account.id] = account
            self.accounts = accounts
        }
    }
    
    public func getAccount(withId accountID: String) -> Account? {
        guard let accounts = accounts else {
            return nil
        }
        return accounts[accountID]
    }
 }
