//
//  VeritranBankEngineTests.swift
//  VeritranBankEngineTests
//
//  Created by Daniel Torres on 5/18/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import VeritranBankEngine

class AccountTests: XCTestCase {
    var sut: Account!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = Account(id: "francisco", balance: try Money(value: 100.0, currency: "usd"))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit_ShouldSetIdAndBalance() throws {
        let accountId = "daniel"
        let zeroBalance = try Money(value: 0, currency: "usd")
        
        let sut = Account(id: accountId, balance: zeroBalance)
        
        XCTAssertEqual(sut.id, "daniel", "initializer should set id \(accountId)")
        XCTAssertEqual(sut.balance, zeroBalance, "initializer should set the balance.")
    }
    
    func testDepositMoney_ReturnsAnIncreasedBalance() throws{
        let moneyTobeDeposit = try Money(value: 10.0, currency: "usd")
        let expectedMoneyToBeDeposit = try Money(value: 110.0, currency: "usd")
        try performEqualTestWith(moneyTobeDeposit, toAccount: sut, expectedBalance: expectedMoneyToBeDeposit)
    }
    
    func testDepositMoney_ReturnsAnIncreasedBalance2() throws{
        let moneyTobeDeposit = try Money(value: 20.0, currency: "usd")
        let expectedMoneyToBeDeposit = try Money(value: 120, currency: "usd")
        try performEqualTestWith(moneyTobeDeposit, toAccount: sut, expectedBalance: expectedMoneyToBeDeposit)
    }
    
    func testDepositMoney_ToExistingAccountOnAGivenBank_ReturnsAccountsBalanceIncreased() throws{
        let bank = Bank(accounts: [sut.id: sut])
        let accountExist = bank.has(sut)
        
        XCTAssertEqual(accountExist,
                       true,
                       "Account should Exist.")
        
        let moneyToBeDeposit = try Money(value: 10.0, currency: "usd")
        let expectedMoneyToBeDeposit = try Money(value: 110.0, currency: "usd")
        
        try sut.deposit(money: moneyToBeDeposit)
        
        XCTAssertEqual(sut.balance, expectedMoneyToBeDeposit, "Balance should be 110 usd")
    }
    
    func testWithdrawMoney_whenWithdrawingMoreMoneyThatTheAccountHas_ShouldThrowAccountHasNoSuffcientFunds() throws{
        let moneyToBeWithdraw = try Money(value: 200.0, currency: "usd")
        
        XCTAssertThrowsError(try sut.withdraw(money: moneyToBeWithdraw)) { error in
            XCTAssertEqual(error as! AccountError, AccountError.AccountHasNoSufficientFunds)
        }
    }
    
    func testWithdrawMoney_whenWithMoneyThatDoesntMatchCurrency_ShouldThrowWithdrawingMoneyWithDifferentCurrency() throws{
        let moneyWithDifferentCurrency = try Money(value: 10.0, currency: "yen")
        
        XCTAssertThrowsError(try sut.withdraw(money: moneyWithDifferentCurrency)) { error in
            XCTAssertEqual(error as! AccountError, AccountError.WithdrawingMoneyWithDifferentCurrency)
        }
    }
    
    func testWithdrawMoney_ToExistingAccountOnAGivenBank_ReturnsAccountsBalanceDecreased() throws{
        let bank = Bank(accounts: [sut.id: sut])
        let accountExist = bank.has(sut)
        
        XCTAssertEqual(accountExist,
                       true,
                       "Account should Exist.")
        let moneyToBeWithdraw = try Money(value: 10.0, currency: "usd")
        let expectedMoneyInTheAccount = try Money(value: 90.0, currency: "usd")
        
        try sut.withdraw(money: moneyToBeWithdraw)
        
        XCTAssertEqual(sut.balance,
                       expectedMoneyInTheAccount, "Balance should be 90 usd")
    }
    
    
    func performEqualTestWith(_ moneyToBeDeposit: Money,
                               toAccount account: Account,
                               expectedBalance balance: Money,
                               line: UInt = #line) throws{

        try account.deposit(money: moneyToBeDeposit)
        
        XCTAssertEqual(account.balance, balance, "Balance should be \(balance)", line: line)
    }
    
}
