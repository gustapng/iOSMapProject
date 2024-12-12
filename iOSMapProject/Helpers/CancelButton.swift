//
//  CancelButton.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import UIKit

class CancelButton: UIButton {
    private var actionClosure: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        self.backgroundColor = UIColor(named: "RedLight")
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true

        let iconImage = UIImage(systemName: "xmark.circle")
        self.setImage(iconImage, for: .normal)
        self.tintColor = .white
        self.imageView?.contentMode = .scaleAspectFit
    }

    func configure(action: @escaping () -> Void) {
        self.actionClosure = action
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        actionClosure?()
    }
}
