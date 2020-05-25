//
//  AccountPresenterTests.swift
//  VeritranBank-iOSTests
//
//  Created by Daniel Torres on 5/23/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
import VeritranBank_iOS
@testable import VeritranBank_iOS

class AccountPresenterTests: XCTestCase {
    
    var sut: AccountPresenter!
    var fakeAccount: FakeAccountPresentable!
    lazy var formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .default
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.currencySymbol = self.fakeAccount.currency
        numberFormatter.positiveFormat = "0.00¤"
        return numberFormatter
    }()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit_ShouldReceiveAnAbstractAccountPresenterProtocolObject(){
        fakeAccount = FakeAccountPresentable(tuple: ("", ""))
        sut = AccountPresenter(account: fakeAccount)
        XCTAssertNotNil(sut.account)
    }
    
    func testAccounTitle_ShouldReturnValueFromATitleFormattedFromAccountProperty(){
        fakeAccount = FakeAccountPresentable(tuple: ("francisco", ""))
        performEqualTest(mock: fakeAccount, line: #line)
    }
    
    func testAccounTitle_ShouldReturnValueFromATitleFormattedFromAccountProperty2(){
        fakeAccount = FakeAccountPresentable(tuple: ("daniel", ""))
        performEqualTest(mock: fakeAccount, line: #line)
    }
    
    func performEqualTest(mock: AccountCurrencyPresentable,
                          line: UInt = #line) {
        sut = AccountPresenter(account: mock)
        XCTAssertEqual(sut.accountTitle,
                       "Account Id: \(mock.accountTitle)", "Account Title not formatted",
                       line: line)
    }
    
    func testBalance_ShouldReturnFormattedBalanceFromAccountProperty(){
        fakeAccount = FakeAccountPresentable(tuple: ("daniel", "100"),
                                                            currency: "USD")
        performTestEqual(mock: fakeAccount,
                         expectedBalance: "100",
                         line: #line)
    }
    
    func testBalance_ShouldReturnFormattedBalanceFromAccountProperty2(){
        fakeAccount = FakeAccountPresentable(tuple: ("francisco", "200"),
                                                            currency: "USD")
        performTestEqual(mock: fakeAccount,
                         expectedBalance: "200",
                         line: #line)
    }
    
    func testBalance_ShouldReturnFormattedBalanceWithOnly2Decimals(){
        fakeAccount = FakeAccountPresentable(tuple: ("francisco", "200.000002"),
                                                            currency: "USD")
        
        
        performTestEqual(mock: fakeAccount,
                         expectedBalance: "200",
                         line: #line)
    }
    
    func testBalance_whenModifiyingAnAccount_ShouldReturnTheNewestValue(){
        fakeAccount = FakeAccountPresentable(tuple: ("francisco", "200"),
                                                            currency: "USD")
        let presenter = AccountPresenter(account: fakeAccount)
        performTestEqual(mock: fakeAccount,
                         in: presenter,
                         expectedBalance: "200",
                         line: #line)
        fakeAccount.tupleDomain = ("francisco", "300")
        performTestEqual(mock: fakeAccount,
                         in: presenter,
                         expectedBalance: "300",
                         line: #line)
    }
    
    func performTestEqual(mock fakeAccount: AccountCurrencyPresentable,
                          in presenter: AccountPresenter? = nil,
                          expectedBalance: String,
                          line: UInt = #line){
        let newPresenter: AccountPresenter
        if presenter == nil {
            newPresenter = AccountPresenter(account: fakeAccount)
        } else {
            newPresenter = presenter!
        }
        let formattedExpectedBalance = getFormattedBalance(withBalance: expectedBalance)
        XCTAssertEqual(newPresenter.balance,
                       formattedExpectedBalance,
                       "Balance should have the format \(expectedBalance)",
            line: line)
    }
    
    func getFormattedBalance(withBalance: String) -> String {
        guard let doubleNumber = Double(withBalance) else {
                return ""
        }
        let number = NSNumber(value: doubleNumber)
        return formatter.string(from: number) ?? ""
    }
    
    class FakeAccountPresentable: AccountCurrencyPresentable {
        var currency: String
        var accountTitle: String { return tupleDomain.0}
        var balance: String {return tupleDomain.1}
        var tupleDomain: (String, String)
        init(tuple: (String, String), currency: String = "") {
            self.tupleDomain = tuple
            self.currency = currency
        }
    }
}
