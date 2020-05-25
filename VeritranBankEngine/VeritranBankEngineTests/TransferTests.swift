//
//  TransferTests.swift
//  VeritranBankEngine
//
//  Created by Daniel Torres on 5/24/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import VeritranBankEngine

class TransferTests: XCTestCase {
    
    var sut: Transfer!
    
    override func setUpWithError() throws {
        let sender = Account(id: "francisco",
                             balance:
            try! Money(value: 100, currency: "USD"))
        let recipient = Account(id: "daniel",
                                balance:
            try! Money(value: 10, currency: "USD"))
        sut = Transfer(with: sender, to: recipient)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit_ShouldSet_SenderAccountAndRecipientAccount(){
        XCTAssertNotNil(sut.sender)
        XCTAssertNotNil(sut.recipient)
    }
    
    func testMakeTransfer_ShouldDecreaseSenderAccountBalance(){
        let sender = sut.sender
        let expectedBalance = try! Money(value: 90, currency: "USD")
        try! sut.makeTransfer(of: Money(value: 10, currency: "USD"))
        XCTAssertEqual(sender.balance, expectedBalance, "senders balance should have decreased")
    }
    
    func testMakeTransfer_ShouldIncreaseRecipientAccountBalance(){
        let recipient = sut.recipient
        let expectedBalance = try! Money(value: 20, currency: "USD")
        try! sut.makeTransfer(of: Money(value: 10, currency: "USD"))
        XCTAssertEqual(recipient.balance,
                       expectedBalance,
                       "recipient balance should have increased")
    }
    
    func testMakeTransfer_WhenSenderHaveNoSufficientFunds_ShouldThrowSenderHaveNoSufficientFunds(){
        let moneyToBeTransferred = try! Money(value: 1000, currency: "USD")
        
        XCTAssertThrowsError(try sut.makeTransfer(of: moneyToBeTransferred)) { error in
            XCTAssertEqual(error as! TransferError, TransferError.SenderHaveNoSufficientFunds)
        }
    }
    
    func testMakeTransfer_WhenSenderHaveDifferentAccountCurrency_ShouldThrowMoneyTransferredMustHaveSameCurrencyFromSender(){
        let moneyToBeTransferred = try! Money(value: 10, currency: "¥")
        
        XCTAssertThrowsError(try sut.makeTransfer(of: moneyToBeTransferred)) { error in
            XCTAssertEqual(error as! TransferError, TransferError.MoneyTransferredMustHaveSameCurrencyFromSender)
        }
    }
    
    func testMakeTransfer_WhenRecipientHaveDifferentAccountCurrency_ShouldThrowMoneyTransferredMustHaveSameCurrencyFromRecipient(){
        let moneyToBeTransferred = try! Money(value: 10, currency: "¥")
        setupTransferWithDifferentCurrencies()
        XCTAssertThrowsError(try sut.makeTransfer(of: moneyToBeTransferred)) { error in
            XCTAssertEqual(error as! TransferError, TransferError.MoneyTransferredMustHaveSameCurrencyFromRecipient)
        }
    }
    
    func testMakeTransfer_WhenRecipientHaveDifferentAccountCurrency_EitherBalanceShouldChange(){
        let moneyToBeTransferred = try! Money(value: 10, currency: "¥")
        setupTransferWithDifferentCurrencies()
        let recipientBalance = sut.recipient.balance
        let senderBalance = sut.sender.balance
        XCTAssertThrowsError(try sut.makeTransfer(of: moneyToBeTransferred))
        
        XCTAssertEqual(sut.recipient.balance,
                       recipientBalance,
                       "recipient balance shouldn't change")
        XCTAssertEqual(sut.sender.balance,
                       senderBalance,
                       "sender balance shouldn't change")
    }
    
    func setupTransferWithDifferentCurrencies(){
        let sender = Account(id: "chiniseMan",
                             balance:
            try! Money(value: 100, currency: "¥"))
        let recipient = Account(id: "daniel",
                                balance:
            try! Money(value: 10, currency: "USD"))
        sut = Transfer(with: sender, to: recipient)
    }
}
