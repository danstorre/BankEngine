//
//  AccountControllerTests.swift
//  VeritranBank-iOSTests
//
//  Created by Daniel Torres on 5/23/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
import VeritranBankEngine
@testable import VeritranBank_iOS

class AccountControllerTests: XCTestCase {
    
    var sut: AccountController!
    var vc: MockViewController!
    
    
    override func setUpWithError() throws {
        vc = MockViewController()
        _ = vc.view
        sut = AccountController(vc: vc, account:
            Account(id: "1",
                    balance: try! Money(value: 10, currency: "usd") ))
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitController_ShouldSetAViewController(){
        XCTAssertNotNil(sut.vc)
    }
    
    func testInitController_ShouldSetAnAccountModel(){
        XCTAssertNotNil(sut.account)
    }
    
    func testUserPressedWithDrawButton_ShouldPresentAnAlertWithATextField(){
        sut.userPressedWithDrawButton(completion: { _ in  })
        performEqualTestVcHasAlertViewControllerWithOneTextField(vc: vc,
                                                                 line: #line)
    }

    func testUserPressedDepositButton_ShouldPresentAnAlertWithATextField(){
        sut.userPressedDepositButton(completion: { _ in  })
        performEqualTestVcHasAlertViewControllerWithOneTextField(vc: vc,
                                                                 line: #line)
    }
    
    func testUserPressedDepositButton_ShouldPresentAnAlertWithDepositTitle(){
        sut.userPressedDepositButton(completion: { _ in  })
        performEquealTest(vc: vc, expectedTitle: "Deposit", line: #line)
    }
    
    func testUserPressedWithdrawButton_ShouldPresentAnAlertWithWithdrawTitle(){
        sut.userPressedWithDrawButton(completion: { _ in  })
        performEquealTest(vc: vc, expectedTitle: "Withdraw", line: #line)
    }
    
    func testUserPressedWithdrawButton_ShouldPresentACancelActionButton(){
        sut.userPressedWithDrawButton(completion: { _ in  })
        performEqualTestCheckIfAlertHasActionTitle(with: vc, at: 0, expected: "cancel")
    }
    
    func testUserPressedDepositButton_ShouldPresentACancelActionButton(){
        sut.userPressedDepositButton(completion: { _ in  })
        performEqualTestCheckIfAlertHasActionTitle(with: vc, at: 0, expected: "cancel")
    }
    
    func testUserPressedWithdrawButton_ShouldPresentAWithdrawActionButton(){
        sut.userPressedWithDrawButton(completion: { _ in  })
        performEqualTestCheckIfAlertHasActionTitle(with: vc, at: 1, expected: "Withdraw")
    }
    
    func testUserPressedDepositButton_ShouldPresentADepositActionButton(){
        sut.userPressedDepositButton(completion: { _ in  })
        performEqualTestCheckIfAlertHasActionTitle(with: vc, at: 1, expected: "Deposit")
    }
    
    func testWithdrawAction_ShouldWidthdrawTheAmountSpecified(){
        let balanceFromAccount = try! Money(value: 9, currency: sut.account.balance.currency)
        sut.widthDrawAction(value: 1, alert: UIAlertController(), completion: {_ in})
        XCTAssertEqual(sut.account.balance, balanceFromAccount, "unexpected balance from account after withdrawing.")
    }
    
    func testWithdrawAction_ShouldNotFail(){
        sut.widthDrawAction(value: 11, alert: UIAlertController(), completion: {_ in})
    }
    
    func testWithdrawAction_WhenAccountHasNoSufficientFunds_ShouldChangeAlertMessage(){
        let expectedMessage = "Insufficient Funds please try a lower amount."
        let alert = UIAlertController(title: "a", message: "s", preferredStyle: .actionSheet)
        sut.widthDrawAction(value: 11, alert: alert, completion: {_ in})
        XCTAssertEqual(alert.message,
                       expectedMessage,
                       "message is not \(expectedMessage)")
    }
    
    func testDepositAction_ShouldDepositTheAmountSpecified(){
        let balanceFromAccountExpected = try! Money(value: 11, currency: sut.account.balance.currency)
        sut.depositAction(value: 1.0, alert: UIAlertController())
        XCTAssertEqual(sut.account.balance, balanceFromAccountExpected, "unexpected balance from account after withdrawing.")
    }
    
    func testWhenPresentingAnAlert_ShouldBeDelegateOfTextfield(){
        sut.userPressedDepositButton(completion: { _ in  })
        let alert = vc.presentViewControllerTarget as? UIAlertController
        let textField = alert!.textFields![0]
        XCTAssertTrue(textField.delegate is AccountController,
                      "the controller should be the delegate of the textfield.")
        
    }
    
    func testWhenPresentingAnAlert_ShouldPresentNumberPadKeyboard(){
        sut.userPressedDepositButton(completion: { _ in  })
        let alert = vc.presentViewControllerTarget as? UIAlertController
        let textField = alert!.textFields![0]
        XCTAssertEqual(textField.keyboardType, .numberPad, "textfield keyboard type should be numberPad.")
    }
    
    func testFinish_ShouldExecuteCompletion(){
        var completionIsCalled = false
        sut.finishOperation { error in
            completionIsCalled = true
        }
        XCTAssert(completionIsCalled, "completion handler must be called.")
    }
    
    func testRetunValueFromTextField_WhenPassingAnAlertWithNotextfields_ShouldReturnZero(){
        let newAlertController =  UIAlertController()
        let valueReturned = HelperMethods.returnValueFromTextField(alert: newAlertController)
        XCTAssertEqual(valueReturned, 0, "Value must be zero")
    }
    
    func testRetunValueFromTextField_WhenPassingATextFieldWithEmptyString_ShouldReturnZero(){
        let newAlertController =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        newAlertController.addTextField(configurationHandler: nil)
        let valueReturned = HelperMethods.returnValueFromTextField(alert: newAlertController)
        XCTAssertEqual(valueReturned, 0, "Value must be zero")
    }
    
    func testWidthDrawAction_WhenOcurringAnError_ShouldReturnAOperationErrorInAClosure(){
        let expectedCompletion : (Error?) -> Void = { (error) in
            XCTAssertEqual(error as! OperationError, OperationError.AccountHasNoSufficientFunds)
        }
        sut.widthDrawAction(value: 20,
                            alert: UIAlertController(),
                            completion: expectedCompletion)
    }
    
    func testFinishOperation_ShouldHandleAnyErrorsWhenDoingAWithdrawOperation(){
        let mockController = MockController(vc: vc,
                                            account: Account(id: "1",
                                                             balance:
                                                try! Money(value: 10, currency: "usd")))
        let expectedCompletion : (Error?) -> Void = { (error) in
        }
        mockController.widthDrawAction(value: 20, alert: UIAlertController(), completion: expectedCompletion)
        
        XCTAssertTrue(mockController.finishOperationDidCalled, "finish should get called.")
    }
    
    func testFinishOperation_WhenFinishingWithdrawOperation_ShouldBeCalled(){
        let mockController = MockController(vc: vc,
                                            account: Account(id: "1",
                                                             balance:
                                                try! Money(value: 10, currency: "usd")))
        let expectedCompletion : (Error?) -> Void = { (error) in
        }
        mockController.widthDrawAction(value: 1, alert: UIAlertController(), completion: expectedCompletion)
        
        XCTAssertTrue(mockController.finishOperationDidCalled, "finish should get called.")
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
    
    func performEquealTest(vc: MockViewController,
                           expectedTitle: String,
                           line: UInt = #line) {
        let alert = vc.presentViewControllerTarget as? UIAlertController
        XCTAssertEqual(alert?.title, expectedTitle, "Alert Title should be \(expectedTitle)", line: line)
        let messageExpected = "Specify amount"
        XCTAssertEqual(alert?.message,
                       messageExpected,
                       "Alert message should be \(messageExpected)",
            line: line)
    }
    
    func performEqualTestVcHasAlertViewControllerWithOneTextField(vc: MockViewController,
                                                                  line: UInt = #line) {
        XCTAssertNotNil(vc.presentViewControllerTarget)
        XCTAssertTrue(vc.presentViewControllerTarget is UIAlertController,
                      "controller should present an alert controller", line: line)
        let alert = vc.presentViewControllerTarget as? UIAlertController
        XCTAssertEqual(alert?.textFields?.count, 1, "there should be one textfield.", line: line)
    }
    
    class MockController: AccountController {
        var finishOperationDidCalled = false
        override func finishOperation(_ completion: @escaping (Error?) -> Void,
                                      _ error: Error? = nil) {
            super.finishOperation(completion, error)
            finishOperationDidCalled = true
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
