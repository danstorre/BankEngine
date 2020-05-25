//
//  FactoryAlertController.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/24/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol AlertConstructor{
    func getAlert() -> UIAlertController
}
extension AlertConstructor {
    func alertWithTitle(title: String,
                                message: String,
            delegate: UITextFieldDelegate?) -> UIAlertController{
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.delegate = delegate
            textfield.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) {[unowned alert] (alertAction) in
            alert.dismiss(animated: true,
                          completion: nil)
        }
        alert.addAction(cancelAction)
        return alert
    }
}

struct TransferConstructor: AlertConstructor {
    var title: String
    var delegate: UITextFieldDelegate?
    var message: String
    func getAlert() -> UIAlertController {
        alertWithTitle(title: title, message: message, delegate: delegate)
    }
}



enum AlertOptions {
    case withTextField(withDelegate: UITextFieldDelegate?, title: String, message: String)
}

enum FactoryAlert {
    
    static func getAlert(with option: AlertOptions) -> UIAlertController {
        switch option {
        case .withTextField(let delegate, let title, let message):
            return TransferConstructor(title: title,
                                       delegate: delegate,
                message: message).getAlert()
        }
    }
 }
