//
//  MoneyTest.swift
//  VeritranBankEngineTests
//
//  Created by Daniel Torres on 5/20/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import VeritranBankEngine

class MoneyTest: XCTestCase {
    
    var sut: Money!
    
    override func setUpWithError() throws {
        sut = try Money(value: 1, currency: "usd")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit_ShouldSetValueAndCurrency() throws{
        let moneyValue: Double = 1.0
        let currencyDollar = "usd"
        
        let sut = try Money(value: moneyValue, currency: currencyDollar)
        
        performEqualTestOf(money: sut,
                           withExpectedValue: moneyValue,
                           withExpectedCurrency: currencyDollar,
                           line: #line)
    }
    
    func testInit_GivenANegativeValue_ShouldThrowAnError() throws{
        let moneyValue: Double = -1.0
        let currencyDollar = "usd"
        
        XCTAssertThrowsError(try Money(value: moneyValue, currency: currencyDollar)) { error in
            XCTAssertEqual(error as! MoneyError, MoneyError.NegativeValuesNotAllowed)
        }
    }
    
    func testSumMoney_given2MoneyWithSameCurrency_returnsANewMoneyWithSameCurrencyAndTheSumOfTheirValues() throws{
        let currencyOfBothMoney = "usd"
        let money1Value: Double = 1.0
        let money2Value: Double = 2.0
        let resultvalue: Double = 3.0
        
        let money1 = try Money(value: money1Value, currency: currencyOfBothMoney)
        let money2 = try Money(value: money2Value, currency: currencyOfBothMoney)
        
        let sut = try money1.sum(money2)
        
        performEqualTestOf(money: sut,
                           withExpectedValue: resultvalue,
                           withExpectedCurrency: currencyOfBothMoney,
                           line: #line)
    }
    
    func testCurrenciesAreDifferent_given2DifferentMoneyWithDifferentCurrencies_returnsCurrenciesAreDifferent() throws{
        let money1Currency = "usd"
        let money2Currency = "yen"
        
        try performsEqualTestBetween(money1Currency,
                                 and: money2Currency,
                                 currenciesAreDifferent: true,
                                 line: #line)
    }
    
    func testCurrenciesAreDifferent_given2SameCurrencies_returnsAreNotDifferent() throws{
        let money1Currency = "usd"
        let money2Currency = "usd"
        
        try performsEqualTestBetween(money1Currency,
                                 and: money2Currency,
                                 currenciesAreDifferent: false,
                                 line: #line)
    }
    
    func testSumMoney_given2MoneyWithDifferentCurrencies_throwsSumOfMoneyMustHaveSameCurrency() throws{
        let money1Currency = "usd"
        let money2Currency = "yen"
        let money1Value: Double = 1.0
        let money2Value: Double = 2.0
        
        let money1 = try Money(value: money1Value, currency: money1Currency)
        let money2 = try Money(value: money2Value, currency: money2Currency)
        
        let sut = { try money1.sum(money2) }
        
        XCTAssertThrowsError(try sut()) { error in
            XCTAssertEqual(error as! MoneyError, MoneyError.SumOfMoneyMustHaveSameCurrency)
        }
    }
    
    func testMinusMoney_given2MoneyWithSameCurrency_shoulReturnNewMoneyWithValueDecreased() throws{
        let currencyOfBothMoney = "usd"
        let money1Value: Double = 2.0
        let money2Value: Double = 1.0
        let resultvalue: Double = 1.0
        
        let money1 = try Money(value: money1Value, currency: currencyOfBothMoney)
        let money2 = try Money(value: money2Value, currency: currencyOfBothMoney)
        let resultMoney = try Money(value: resultvalue, currency: currencyOfBothMoney)
        
        XCTAssertEqual(try money1.minus(money2),
                       resultMoney,
                       "minus message to Money should return a decresed value.")
    }
    
    func testMinusMoney_given2MoneyWithDifferentCurrencies_shouldThrowAnRestOfMoneyMustHaveSameCurrency() throws{
        let currencyOfMoney1 = "usd"
        let currencyOfMoney2 = "yen"
        let money1Value: Double = 2.0
        let money2Value: Double = 1.0
        
        let money1 = try Money(value: money1Value, currency: currencyOfMoney1)
        let money2 = try Money(value: money2Value, currency: currencyOfMoney2)
        
            
        XCTAssertThrowsError(try money1.minus(money2)) { error in
            XCTAssertEqual(error as! MoneyError, MoneyError.RestOfMoneyMustHaveSameCurrency)
        }
    }
    
    func testMinusMoney_whenSecondMoneyIsBiggerThanTheFirstOne_ShouldThrowRightHandSideMoneyMustBeLowerThatTheLeftSideMoney() throws{
        
        let currencyOfBothMoney = "usd"
        let lhsValue: Double = 1.0
        let rhsValue: Double = 2.0
        
        let lhsMoney = try Money(value: lhsValue, currency: currencyOfBothMoney)
        let rhsMoney = try Money(value: rhsValue, currency: currencyOfBothMoney)
        
            
        XCTAssertThrowsError(try lhsMoney.minus(rhsMoney)) { error in
            XCTAssertEqual(error as! MoneyError, MoneyError.RightHandSideMoneyMustBeLowerThatTheLeftHandSideMoney)
        }
    }
    
    func performsEqualTestBetween(_ money1Currency: String,
                                  and money2Currency: String,
                                  currenciesAreDifferent: Bool,
                                  line: UInt = #line) throws{
        let money1 = try Money(value: 0, currency: money1Currency)
        let money2 = try Money(value: 0, currency: money2Currency)
        
        let sut = Money.currenciesAreDifferent(money1, from: money2)
        
        XCTAssertEqual(sut, currenciesAreDifferent, "currencies should be Different")
    }
    
    func performEqualTestOf(money: Money,
                            withExpectedValue valueExpected: Double,
                            withExpectedCurrency currencyExpected: String,
                            line: UInt = #line) {
        XCTAssertEqual(money.value,
                       valueExpected,
                       "value of money should be \(valueExpected)",
            line: line)
        XCTAssertEqual(money.currency,
                       currencyExpected,
                       "currency of money should be \(currencyExpected)",
            line: line)
    }
}
