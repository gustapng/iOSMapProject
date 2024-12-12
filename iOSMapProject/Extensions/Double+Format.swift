//
//  Double+Format.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import Foundation

extension Double {
    public func formatDistance() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal

        let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(formattedNumber)"
    }
}
