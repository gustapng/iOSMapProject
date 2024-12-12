//
//  DriverPickerView.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import UIKit

class DriverPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    private var options: [String]
    private var didSelectOption: ((String) -> Void)?

    init(options: [String], didSelectOption: @escaping (String) -> Void) {
        self.options = options
        self.didSelectOption = didSelectOption
        super.init(frame: .zero)
        self.delegate = self
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = options[row]
        didSelectOption?(selectedOption)
    }
}
