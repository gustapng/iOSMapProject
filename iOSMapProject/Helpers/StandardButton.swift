//
//  StandardButton.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import UIKit

class StandardButton: UIButton {
    private var actionClosure: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        self.backgroundColor = UIColor(named: "GreenLight")
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.setTitleColor(.white, for: .normal)
    }

    func configure(title: String, action: @escaping () -> Void) {
        self.setTitle(title, for: .normal)
        self.actionClosure = action
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        actionClosure?()
    }
}
