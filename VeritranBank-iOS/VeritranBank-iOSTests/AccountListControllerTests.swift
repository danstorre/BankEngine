//
//  AccountListControllerTests.swift
//  VeritranBank-iOSTests
//
//  Created by Daniel Torres on 5/24/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
import VeritranBankEngine
@testable import VeritranBank_iOS

class AccountListControllerTests: XCTestCase {
    var sut: AccountListController!
    var vc: MockViewController!
    var fakeBank: FakeBank!
    var delegate: MockDelegate!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = MockViewController()
        _ = vc.view
        fakeBank = FakeBank()
        delegate = MockDelegate()
        let senderAccount = fakeBank.getAccount(withId: "francisco")!
        sut = AccountListController(bank: FakeBank(),
                                    senderAccount: senderAccount,
                                    vc: vc,
                                    delegate: delegate)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitController_ShouldSetABank(){
        XCTAssertNotNil(sut.bank)
    }
    
    func testInitController_ShouldSetAvcToPresenTheTransferAlert(){
        XCTAssertNotNil(sut.vc)
    }
    
    func testInitController_ShouldSetASenderAccount(){
        XCTAssertNotNil(sut.senderAccount)
    }
    
    func testInitController_ShouldSetADelegate(){
        XCTAssertNotNil(sut.delegate)
    }
    
    func testGetCount_shouldReturnBankAccountsNumber(){
        XCTAssertEqual(sut.getCount(), 2, "should return bank 2 accounts count.")
    }
    
    func testGetTitleAtIndex_shouldReturnBankAccountId(){
        XCTAssertEqual(sut.getTitleAtIndex(0), "Account with id: chineseman with balance 10.0 ¥",
                       "should return bank account ID.")
        XCTAssertEqual(sut.getTitleAtIndex(1), "Account with id: daniel with balance 100.0 USD",
                       "should return bank account ID.")
    }
    
    func testSelectedAccountAtIndex_ShouldPresentAlertForTransfer(){
        sut.selectedAccountAtIndex(0)
        performEqualTestVcHasAlertViewControllerWithOneTextField(vc: vc,
                                                                 line: #line)
    }
    
    func testSelectAccountAtIndex_ShouldPresentAlertForTransferWithProperties(){
        sut.selectedAccountAtIndex(0)
        let alert = vc.presentViewControllerTarget as! UIAlertController
        alert.message = "Specify amount to be transfered"
        alert.title = "Transfer to daniel"
    }
    
    func testSelectAccountAtIndex_ShouldPresentACancelActionButton(){
        sut.selectedAccountAtIndex(0)
        performEqualTestCheckIfAlertHasActionTitle(with: vc,
                                                   at: 0,
                                                   expected: "cancel",
                                                   line: #line)
    }
    
    func testSelectAccountAtIndex_ShouldPresentATransferActionButton(){
        sut.selectedAccountAtIndex(0)
        performEqualTestCheckIfAlertHasActionTitle(with: vc,
                                                   at: 1,
                                                   expected: "Transfer",
                                                   line: #line)
    }
    
    func testTransferAction_ShouldTransferTheAmountSpecifiedToAnotherAccount(){
        let expectedBalanceFromFirstAccount = try! Money(value: 90, currency: "USD")
        let expectedBalanceFromSecondAccount = try! Money(value: 110, currency: "USD")
        let recipientAccount = fakeBank.getAccount(withId: "daniel")!
        sut.transferAction(value: 10,
                           to: recipientAccount)
        XCTAssertEqual(sut.senderAccount.balance,
                       expectedBalanceFromFirstAccount,
                       "unexpected balance from account after transfer.")
        XCTAssertEqual(recipientAccount.balance,
                       expectedBalanceFromSecondAccount,
                       "unexpected balance from account after transfer.")
    }
    
    func testTransferAction_ShouldSendDidFinishedMessageToDelegate(){
        let recipientAccount = fakeBank.getAccount(withId: "daniel")!
        sut.transferAction(value: 10,
                           to: recipientAccount)
        XCTAssertTrue(delegate.didfinishedCalled, "delegate's didFinish should be called.")
    }
    
    func testTransferAction_WhenOccurringRecipientHasDifferentCurrency_ShouldSendCurrencyOfRecipientHasDifferentCurrency(){
        let recipientAccount = fakeBank.getAccount(withId: "chineseman")!
        sut.transferAction(value: 10,
                           to: recipientAccount)
        XCTAssertEqual(delegate!.errorThrown,
                       AccountListControllerError.SenderAndRecipientShouldMatchCurrencies,
                       "Error thrown should be SenderAndRecipientShouldMatchCurrencies")
       
    }
    
    func testTransferAction_WhenOccurringRecipientHasDifferentCurrency_EitherBalanceShouldChange(){
        let recipientAccount = fakeBank.getAccount(withId: "chineseman")!
        sut.transferAction(value: 10,
                           to: recipientAccount)
        XCTAssertEqual(sut.senderAccount.balance,
                              try! Money(value: 100, currency: "USD"), "senders balance should not change")
        XCTAssertEqual(recipientAccount.balance,
                              try! Money(value: 10, currency: "¥"), "recipient balance should not change")
    }
    
    func testTransferAction_WhenOccurringSenderHaveNoSufficientFunds_ShouldSendSenderHaveNoSufficientFunds(){
        let recipientAccount = fakeBank.getAccount(withId: "chineseman")!
        sut.transferAction(value: 10000,
                           to: recipientAccount)
        XCTAssertEqual(delegate!.errorThrown,
                       AccountListControllerError.SendSenderHaveNoSufficientFunds,
                       "Error thrown should be SendSenderHaveNoSufficientFunds")
    }
    
    func performEqualTestCheckIfAlertHasActionTitle(with vc: MockViewController,
                                                    at index: Int,
                                                    expected title: String,
                                                    line: UInt = #line) {
        let alert = vc.presentViewControllerTarget as? UIAlertController
        XCTAssertEqual(alert?.actions[index].title,
                       title,
                       "Alert should have a \(title) action",
            line: #line)
    }
    
    func performEqualTestVcHasAlertViewControllerWithOneTextField(vc: MockViewController,
                                                                  line: UInt = #line) {
        XCTAssertNotNil(vc.presentViewControllerTarget)
        XCTAssertTrue(vc.presentViewControllerTarget is UIAlertController,
                      "controller should present an alert controller", line: line)
        let alert = vc.presentViewControllerTarget as? UIAlertController
        XCTAssertEqual(alert?.textFields?.count, 1, "there should be one textfield.", line: line)
    }
    
    class MockDelegate: AccountListControllerDelegate {
        var didfinishedCalled: Bool = false
        var errorThrown: AccountListControllerError?
        func didFinish() {
            didfinishedCalled = true
        }
        func didFinishWithErrors(error: Error) {
            errorThrown = error as? AccountListControllerError
        }
    }
    
    class FakeBank: Bank {
        override init(accounts: [String : Account]? = nil) {
            let anotherFakeAccount = FakeAccount(id: "chineseman",
                                                 balance: try! Money(value: 10, currency: "¥"))
            super.init(accounts: ["francisco": FakeAccount(id: "francisco"),
                                  "daniel": FakeAccount(id: "daniel"),
                                  "chineseman":  anotherFakeAccount])
        }
    }
    
    class FakeAccount: Account {
        convenience init(id: String) {
            self.init(id: id, balance: try! Money(value: 100, currency: "USD"))
        }
    }
    
    class MockViewController: UIViewController {
        var presentViewControllerTarget: UIViewController?
        override func present(_ viewControllerToPresent: UIViewController,
                              animated flag: Bool,
                              completion: (() -> Void)?) {
            presentViewControllerTarget = viewControllerToPresent
        }
    }
    
}
