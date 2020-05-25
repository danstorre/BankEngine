//
//  BankTests.swift
//  VeritranBankEngineTests
//
//  Created by Daniel Torres on 5/20/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import VeritranBankEngine

class BankTests: XCTestCase {
    var account: Account!
    var sut: Bank!

    override func setUpWithError() throws {
        account = Account(id: "francisco", balance: try Money(value: 100, currency: "usd"))
        sut = Bank()
    }

    override func tearDownWithError() throws {
    }

    func testHasAccount_WhenAddingTheAccount_ShouldReturnTrue() throws{
        sut.addAccount(account)
        try performEqualTestWith(account, inBank: sut, returnsExist: true, line: #line)
    }
    
    func testHasAccount_WithoutAccounts_ShouldReturnFalse() throws{
        try performEqualTestWith(account, inBank: sut, returnsExist: false, line: #line)
    }

    func testHasAccount_GivenBankWithoutAGivenAccount_ShouldReturnFalse() throws{
        sut = Bank(accounts: [account.id: account])
        let balanceOfNonExistingAccount = try Money(value: 200.2, currency: "usd")
        let nonExistingAccount = Account(id: "Daniel", balance: balanceOfNonExistingAccount)
        
        try performEqualTestWith(nonExistingAccount, inBank: sut, returnsExist: false, line: #line)
    }
    
    func testGetAccountWithID_GivenABankWithAAccountThatHasSameID_shouldReturnAccount(){
        let idOfExpectedAccount = "francisco"
        sut.addAccount(account)
        XCTAssertEqual(sut.getAccount(withId: idOfExpectedAccount),
                       account,
                       "Account with id \(idOfExpectedAccount) should be returned")
    }
    
    func testGetAccountWithID_GivenABankWithoutAAccount_shouldReturnNil(){
        let idOfUnexistingAccount = "francisco"
        let bank = Bank()
        XCTAssertEqual(bank.getAccount(withId: idOfUnexistingAccount),
                       nil,
                       "getAccount method should return nil")
    }
    
    func testGetAccountWithID_GivenABankWithoutGivenAccount_shouldReturnNil(){
        let idOfUnexistingAccount = "francisco"
        sut.addAccount(Account(id: "dummy", balance: try! Money(value: 0, currency: "usd")))
        XCTAssertEqual(sut.getAccount(withId: idOfUnexistingAccount),
                       nil,
                       "getAccount method should return nil")
    }
    
    func testAddAccount_shouldAddThatAccount(){
        let account1 = Account(id: "dummy", balance: try! Money(value: 0, currency: "usd"))
        
        sut.addAccount(account1)
        XCTAssertNotNil(sut.getAccount(withId: account1.id),
                       "getAccount method should return nil")
        
        let account2 = Account(id: "fran", balance: try! Money(value: 0, currency: "usd"))
        sut.addAccount(account2)
        XCTAssertNotNil(sut.getAccount(withId: account2.id),
        "getAccount method should return nil")
    }
    
    func performEqualTestWith(_ account: Account,
                               inBank bank: Bank,
                               returnsExist: Bool,
                               line: UInt = #line) throws{
        let accountExist = bank.has(account)
        
        XCTAssertEqual(accountExist,
                       returnsExist,
                       "Account should \( String(describing: {return returnsExist ? "Exist" : "Not Exist" }()))",
            line: line)
    }
}
