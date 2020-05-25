//
//  AccountListViewControllerTests.swift
//  VeritranBank-iOSTests
//
//  Created by Daniel Torres on 5/24/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
import VeritranBankEngine
@testable import VeritranBank_iOS

class AccountListViewControllerTests: XCTestCase {
    
    var sut: AccountListViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "AccountListViewController") as! AccountListViewController)
        sut.accountsController = StubAccountListController()
        _ = sut.view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHasTitle(){
        XCTAssertNotNil(sut.title)
        XCTAssertEqual(sut.title,
                       "Account list",
                       "AccountListViewController Should have Account list as Title.")
    }
    
    func testHasAccountsController(){
        XCTAssertNotNil(sut.accountsController)
    }
    
    func testNumberOfSections_IsOne() {
        let numberOfSections = sut.tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 1)
    }
    
    func testNumberRowsInSection_IsCountFromController() {
        XCTAssertEqual(sut.accountsController.getCount(), 2,
                       "should return the count of controller")
    }
    
    func testNumberOfRows_ReturnsGetCountFromController(){
        let count = sut.tableView(sut.tableView,
                                  numberOfRowsInSection: 0)
        XCTAssertEqual(count, 2,
                       "should return the count of controller")
    }
    
    func testCellForRow_ReturnsCell() {
        sut.tableView.reloadData()
        let cell = sut.tableView
            .cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is AccountCell)
    }
    
    func testCellForRow_DequeuesCell() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)
        
        mockTableView.reloadData()
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func testGetTitleAtIndex_GetsCalledInCellForRow() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)
        let accountId = "dan"
        mockTableView.reloadData()
        let cell = mockTableView.cellForRow(at:
            IndexPath(row: 0, section: 0)) as! MockItemCell
        XCTAssertEqual(cell.stringID, accountId, "should set getTitleAtIndex from controller")
    }
    
    func testSelectionOfCell_CallsControllersSelectedAccountAtIndex() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)
        sut.tableView
            .delegate?
            .tableView?(mockTableView,
                        didSelectRowAt: IndexPath(row: 0, section: 0))
        
        let stubAccountsController = sut.accountsController as! StubAccountListController
        XCTAssertEqual(stubAccountsController.selectedAccountAtIndexCalled,
                       true, "controller's selectedAccountAtIndexCalled should be called.")
    }
    
    class StubAccountListController: AccountListControllerProtocol{
        var selectedAccountAtIndexCalled = false
        
        func getTitleAtIndex(_: Int) -> String {
            return "dan"
        }
        
        func getCount() -> Int {
            return 2
        }
        
        func selectedAccountAtIndex(_: Int){
            selectedAccountAtIndexCalled = true
        }
    }
    
    class MockTableView : UITableView {
        var cellGotDequeued = false
        
        override func dequeueReusableCell(withIdentifier identifier: String,
                                          for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier,
                                             for: indexPath)
        }
        static func mockTableViewWithDataSource(_
            dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(
                frame: CGRect(x: 0, y: 0,
                              width: 320, height: 480),
                style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self,
                                   forCellReuseIdentifier: "AccountCell")
            return mockTableView
        }
    }
    class MockItemCell : AccountCell {
        var stringID: String?
        override func configCellWitTitle(_ stringID: String) {
            self.stringID = stringID
        }
    }
}
