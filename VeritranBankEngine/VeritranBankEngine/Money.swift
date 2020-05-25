//
//  Money.swift
//  VeritranBankEngine
//
//  Created by Daniel Torres on 5/20/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

enum MoneyError: Error {
    case SumOfMoneyMustHaveSameCurrency
    case NegativeValuesNotAllowed
    case RestOfMoneyMustHaveSameCurrency
    case RightHandSideMoneyMustBeLowerThatTheLeftHandSideMoney
}

public struct Money{
    public let value: Double
    public let currency: String
    public init(value: Double, currency: String) throws{
        guard value >= 0 else {
            throw MoneyError.NegativeValuesNotAllowed
        }
        self.value = value
        self.currency = currency
    }
    static func currenciesAreDifferent(_ money1: Money,
                                       from money2: Money) -> Bool {
        return money1.currency != money2.currency
    }
    
    func sum(_ money2: Money) throws -> Money{
        guard !Money.currenciesAreDifferent(self, from: money2) else {
            throw MoneyError.SumOfMoneyMustHaveSameCurrency
        }
        return try Money(value: value + money2.value, currency: currency)
    }
    
    func minus(_ money2: Money) throws -> Money{
        guard !Money.currenciesAreDifferent(self, from: money2) else {
            throw MoneyError.RestOfMoneyMustHaveSameCurrency
        }
        do{
            return try Money(value: value - money2.value,
                                currency: currency)
        }catch MoneyError.NegativeValuesNotAllowed {
            throw MoneyError.RightHandSideMoneyMustBeLowerThatTheLeftHandSideMoney
        } catch {
            fatalError()
        }
    }
}


extension Money: Equatable{
    
}
