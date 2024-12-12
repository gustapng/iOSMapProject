//
//  UIViewController+Alert.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor(named: "GreenLight"), forKey: "titleTextColor")

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showAlertWithCompletion(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        okAction.setValue(UIColor(named: "GreenLight"), forKey: "titleTextColor")

        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
