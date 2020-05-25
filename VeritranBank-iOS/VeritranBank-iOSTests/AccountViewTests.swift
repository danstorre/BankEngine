//
//  AccountViewTests.swift
//  VeritranBank-iOSTests
//
//  Created by Daniel Torres on 5/23/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
import VeritranBankEngine
@testable import VeritranBank_iOS

class AccountViewTests: XCTestCase {
    
    var sut: AccountViewController!
    var window: UIWindow!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHasTitle(){
        _ = sut.view
        XCTAssertNotNil(sut.title)
        XCTAssertEqual(sut.title,
                       "Account",
                       "AccountViewController Should have Account Details.")
    }
    
    func testViewDidLoad_WithdrawButtonIsNotNil(){
        _ = sut.view
        XCTAssertNotNil(sut.withdrawButton)
    }
    
    func testViewDidLoad_DepositButtonIsNotNil(){
        _ = sut.view
        XCTAssertNotNil(sut.depositButton)
    }
    
    func testViewDidLoad_TransferButtonIsNotNil(){
        _ = sut.view
        XCTAssertNotNil(sut.transferButton)
    }
    
    func testDepositButton_WhenAskingForIsTitleLabelText_ShouldReturnDeposit(){
        _ = sut.view
        XCTAssertEqual(sut.depositButton.titleLabel?.text, "Deposit", "Deposit button title Label should return Deposit.")
    }
    
    func testWithdrawButton_WhenAskingForIsTitleLabelText_ShouldReturnWithdraw(){
        _ = sut.view
        XCTAssertEqual(sut.withdrawButton.titleLabel?.text, "Withdraw", "Withdraw button title Label should return Withdraw.")
    }
    
    func testTransferButton_WhenAskingForItsTitleLabelText_ShouldReturnTransfer(){
        _ = sut.view
        XCTAssertEqual(sut.transferButton.titleLabel?.text, "Transfer", "Transfer button title Label should return Transfer.")
    }
    
    func testViewDidLoad_AccountTitleLabelIsNotNil(){
        _ = sut.view
        XCTAssertNotNil(sut.accountTitleLabel)
    }
    
    func testViewDidLoad_BalanceLabelIsNotNil(){
        _ = sut.view
        XCTAssertNotNil(sut.balanceLabel)
    }
    
    func tesHasPresenter_WhenPassingAPresenter(){
        let dummy = DummyPrensenter()
        sut.presenter = dummy
        _ = sut.view
        XCTAssertNotNil(sut.presenter)
    }
    
    func testViewDidLoad_ShouldSetTextToAccountTitleLabel(){
        let presenter = DummyPrensenter()
        sut.presenter = presenter
        _ = sut.view
        XCTAssertEqual(sut.accountTitleLabel.text,
                       presenter.accountTitle,
                       "account title should be \(presenter.accountTitle)")
    }
    
    func testViewDidLoad_ShouldSetTextToBalanceLabel(){
        let presenter = DummyPrensenter()
        sut.presenter = presenter
        _ = sut.view
        XCTAssertEqual(sut.balanceLabel.text,
                       presenter.balance,
                       "balance should be \(presenter.balance)")
    }
    
    func testClickingOnWidthdraw_CallsController(){
        let controller = MockController()
        sut.controller = controller
        _ = sut.view
        sut.buttonWidthdrawPressed(sender: UIButton())
        XCTAssertEqual(controller.buttonWithDrawIsCalled,
                       true, "controller should be called when withdrawing money")
    }
    
    func testClickingOnDeposit_CallsController(){
        let controller = MockController()
        sut.controller = controller
        _ = sut.view
        sut.buttonDepositPressed(sender: UIButton())
        XCTAssertEqual(controller.buttonDepositIsCalled,
                       true,
                       "controller should be called when withdrawing money")
    }
    
    
    func testClickingOnWidthdraw_whenNoSufficientFunds_ViewPresentsAnAlert(){
        presentAlertFromWithdrawlOperationWithError(error: OperationError.AccountHasNoSufficientFunds)
        
        sut.buttonWidthdrawPressed(sender: UIButton())
        
        performEqualTestToCheckAlert(with: "Withdrawl Operation",
                                     and: "You don't have enough funds",
                                     line: #line)
    }
    
    func testClickingOnWidthdraw_whenOccuringAProblem_ViewPresentsAnAlert(){
        presentAlertFromWithdrawlOperationWithError(error: OperationError.AnyOtherError)
        
        sut.buttonWidthdrawPressed(sender: UIButton())
        
        performEqualTestToCheckAlert(with: "Withdrawl Operation Error",
                                     and: "Something went wrong, please try again.",
                                     line: #line)
    }
    
    func testClickingOnTransfer_ShouldCallAControllerTransfer(){
        let transferController = MockTransferController()
        sut.transferController = transferController
        _ = sut.view
        sut.buttonTransferPressed(sender: UIButton())
        XCTAssertEqual(transferController.userPressedTransferButtonIsCalled,
                       true, "controller's userPressedTransferButtonIsCalled should be called when transfering money")
    }
    
    func presentAlertFromWithdrawlOperationWithError(error: OperationError) {
        let controller = MockController()
        controller.errorToThrow = error
        sut.controller = controller
        _ = sut.view
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        sut.buttonWidthdrawPressed(sender: UIButton())
    }
    
    func performEqualTestToCheckAlert(with title: String,
                                      and message: String,
                                      line: UInt = #line) {
        XCTAssertNotNil(sut!.presentedViewController)
        XCTAssertTrue(sut!.presentedViewController is UIAlertController,
                      "view should Present Alert")
        let alert = sut!.presentedViewController as! UIAlertController
        XCTAssertEqual(alert.message, message, "message not set properly.")
        XCTAssertEqual(alert.title, title, "title not set properly.")
    }
    
    class MockTransferController: TransferControllerProtocol{
        var userPressedTransferButtonIsCalled: Bool = false
        
        func userPressedTransferButton() {
            userPressedTransferButtonIsCalled = true
        }
    }

    class MockController: AccountInteractions {
        var buttonWithDrawIsCalled: Bool = false
        var buttonDepositIsCalled: Bool = false
        var errorToThrow: Error? = nil
        
        func userPressedWithDrawButton(completion: @escaping (Error?) -> Void) {
            buttonWithDrawIsCalled = true
            if let errorToThrow = errorToThrow{
                completion(errorToThrow)
            } else {
                completion(nil)
            }
        }
        
        func userPressedDepositButton(completion: @escaping (Error?) -> Void) {
            buttonDepositIsCalled = true
            completion(nil)
        }
    }
    
    class DummyPrensenter: AccountPresenterProtocol{
        var accountTitle: String {
            return "Account"
        }
        var balance: String {
            return "Balance"
        }
    }
}
