//
//  RouterTransferTests.swift
//  VeritranBank-iOSTests
//
//  Created by Daniel Torres on 5/25/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
import VeritranBankEngine
@testable import VeritranBank_iOS

class RouterTransferTests: XCTestCase {
    
    var sut: RouterTransfer!
    var vc: MockViewController!
    var mockaccountListController: AccountListController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = MockViewController()
        _ = vc.view
        let senderAccount = Account(id: "dan",
                                    balance:
            try! Money(value: 10, currency: "USD"))
        mockaccountListController = FakeAccountListController()
        sut = RouterTransfer(vc: vc,
                             senderAccount: senderAccount,
                             accountListController: mockaccountListController)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRouterInit_ShouldSetAvc(){
        XCTAssertNotNil(sut.vc)
    }
    
    func testRouterInit_ShouldSetASenderAccount(){
        XCTAssertNotNil(sut.senderAccount)
    }
    
    func testRouterInit_ShouldSetAnAccountListController(){
        XCTAssertNotNil(sut.accountListController)
    }
    
    func testUserPressedTransferButton_PresentsATableViewWithBankAccountsToTransfer(){
        let mockVc = sut.vc as! MockViewController
        sut.userPressedTransferButton()
        
        XCTAssertNotNil(mockVc.presentViewControllerTarget)
        XCTAssertTrue(mockVc.presentViewControllerTarget is AccountListViewController,
                      "view should Present a list of accounts")
        XCTAssertTrue(mockVc.presentViewControllerTarget is UITableViewController,
                      "view should present a tableviewcontroller.")
    }
    
    func testUserPressedTransferButton_ShouldSetAControllerToAccountListViewController(){
        let mockVc = sut.vc as! MockViewController
        sut.userPressedTransferButton()
        
        let accountlistVC = mockVc.presentViewControllerTarget as! AccountListViewController
        
        XCTAssertNotNil(accountlistVC.accountsController)
    }
    
    func testUserPressedTransferButton_WhenVCConformsToAccountListControllerDelegate_ShouldSetADelegateToAccountListController(){
        sut = RouterTransfer(vc: FakeListControllerDelegateVC(),
                             senderAccount: FakeAccount(id: "dan"),
                             accountListController: FakeAccountListController())
        sut.userPressedTransferButton()
        XCTAssertNotNil(sut.accountListController.delegate)
    }
    
    class FakeListControllerDelegateVC: MockViewController, AccountListControllerDelegate{
        func didFinishWithErrors(error: Error) {
        }
        
        func didFinish() {
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
    
    class FakeAccountListController: AccountListController {
        init(){
            super.init(bank: FakeBank(), senderAccount: FakeAccount(id: "daniel"))
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
}
