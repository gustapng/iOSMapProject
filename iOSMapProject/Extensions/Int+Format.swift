//
//  Int+Format.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 08/12/24.
//

extension Int {
    public func formatDistanceToKM() -> String {
        let kilometers = Double(self) / 1000.0
        return String(format: "%.2f km", kilometers)
    }
}
