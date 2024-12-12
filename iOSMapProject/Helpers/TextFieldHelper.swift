//
//  TextFieldHelper.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import UIKit

class TextFieldHelper {
    static func setupStandardTextField(_ textField: UITextField, placeholder: String, icon: UIImage?) {
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 16)

        if let iconImage = icon {
            let iconView = UIImageView(image: iconImage)
            iconView.tintColor = .gray
            iconView.contentMode = .scaleAspectFit
            iconView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)

            let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
            iconView.center.y = iconContainer.center.y
            iconContainer.addSubview(iconView)

            textField.leftView = iconContainer
            textField.leftViewMode = .always
        }

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
    }
}
