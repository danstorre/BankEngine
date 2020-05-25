//
//  Account.swift
//  VeritranBankEngine
//
//  Created by Daniel Torres on 5/22/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

public enum AccountError: Error {
    case AccountHasNoSufficientFunds
    case WithdrawingMoneyWithDifferentCurrency
    case DepositingMoneyWithDifferentCurrency
}

open class Account {
    public let id: String
    open private (set) var balance: Money
    public init(id: String, balance: Money) {
        self.id = id
        self.balance = balance
    }
    public func deposit(money: Money) throws{
        do {
            balance = try balance.sum(money)
        } catch MoneyError.SumOfMoneyMustHaveSameCurrency {
            throw AccountError.DepositingMoneyWithDifferentCurrency
        }
    }
    public func withdraw(money: Money) throws {
        do {
            balance = try balance.minus(money)
        } catch
            MoneyError.RightHandSideMoneyMustBeLowerThatTheLeftHandSideMoney{
                throw AccountError.AccountHasNoSufficientFunds
        } catch
            MoneyError.RestOfMoneyMustHaveSameCurrency {
                throw AccountError.WithdrawingMoneyWithDifferentCurrency
        }
    }
}

extension Account: Equatable{
    public static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.id == rhs.id
    }
}

