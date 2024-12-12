//
//  StandardSheetLabel.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import UIKit

class StandardSheetLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.textAlignment = .center
        self.textColor = UIColor(named: "GreenLight")
        self.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }

    func configure(title: String) {
        self.text = title
    }
}
