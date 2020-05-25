//
//  AccountListViewController.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/24/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol AccountListControllerProtocol{
    func getCount() -> Int
    func getTitleAtIndex(_:Int) -> String
    func selectedAccountAtIndex(_: Int)
}

class AccountListViewController: UITableViewController {
    
    var accountsController: AccountListControllerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account list"
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return accountsController.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell",
                                                 for: indexPath) as! AccountCell
        
        cell.configCellWitTitle(accountsController!
            .getTitleAtIndex(indexPath.row))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        accountsController!.selectedAccountAtIndex(indexPath.row)
    }
    
}
