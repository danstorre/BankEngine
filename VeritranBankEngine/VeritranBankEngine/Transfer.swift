//
//  Transfer.swift
//  VeritranBankEngine
//
//  Created by Daniel Torres on 5/24/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

public enum TransferError: Error{
    case SenderHaveNoSufficientFunds
    case MoneyTransferredMustHaveSameCurrencyFromSender
    case MoneyTransferredMustHaveSameCurrencyFromRecipient
}

protocol Operation {
    func canDoOperation() throws
}

final class TransferOperation: Operation {
    var closure: () throws -> Bool
    var next: Operation?
    
    init(closure: @escaping () throws -> Bool,
         next: Operation? = nil) {
        self.closure = closure
        self.next = next
    }
    
    func canDoOperation() throws {
        let finished: Bool
        do {
            finished = try closure()
        } catch let e {
            throw e
        }
        if finished {
            try next?.canDoOperation()
        }
    }
}

open class Transfer {
    let sender: Account
    let recipient: Account
    
    public init(with sender: Account, to recipient: Account){
        self.sender = sender
        self.recipient = recipient
    }
    
    public func makeTransfer(of money: Money) throws {
        
        let ableToDepositOperation = TransferOperation(closure: { [unowned self] () -> Bool in
            do {
                return try self.canSend(balance: self.sender.balance, money: money)
            } catch AccountError.AccountHasNoSufficientFunds{
                throw TransferError.SenderHaveNoSufficientFunds
            } catch AccountError.WithdrawingMoneyWithDifferentCurrency{
                throw TransferError.MoneyTransferredMustHaveSameCurrencyFromSender
            }
        })
        
        let ableToSendOperation = TransferOperation(closure: { [unowned self] () -> Bool in
            do {
                return try self.canDeposit(balance: self.recipient.balance, money: money)
            }
            catch AccountError.DepositingMoneyWithDifferentCurrency{
                throw TransferError.MoneyTransferredMustHaveSameCurrencyFromRecipient
            }
        })
        
        let withdrawOperation = TransferOperation(closure: { [unowned self] () -> Bool in
            do {
                try self.sender.withdraw(money: money)
                return true
            }
            catch let e{
                throw e
            }
        })
        
        let depositOperation = TransferOperation(closure: { [unowned self] () -> Bool in
            do {
                try self.recipient.deposit(money: money)
                return true
            }
            catch let e{
                throw e
            }
        })
        withdrawOperation.next = depositOperation
        ableToSendOperation.next = withdrawOperation
        ableToDepositOperation.next = ableToSendOperation
        
        do {
            try ableToDepositOperation.canDoOperation()
        }catch let e {
            throw e
        }
    }
    
    private func canSend(balance: Money, money: Money) throws -> Bool {
        let accountToWidthDraw = Account(id: "1", balance: balance)
        do {
            try accountToWidthDraw.withdraw(money: money)
            return true
        }catch let e {
            throw e
        }
    }
    
    private func canDeposit(balance: Money, money: Money) throws -> Bool {
        let accountToDeposit = Account(id: "1", balance: balance)
        do {
            try accountToDeposit.deposit(money: money)
            return true
        }catch let e {
            throw e
        }
    }
    
}
