//
//  UINavigationBar+adjustTitlePosition.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import UIKit

extension UINavigationBar {
    func adjustTitlePosition(verticalOffset: CGFloat = -10, color: UIColor? = nil) {
        setTitleVerticalPositionAdjustment(verticalOffset, for: .default)

        if let color = color {
            titleTextAttributes = [.foregroundColor: color]
        }
    }
}
