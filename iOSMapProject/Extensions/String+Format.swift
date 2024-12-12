//
//  String+DateFormat.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 07/12/24.
//

import Foundation

extension String {
    public func formatDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        guard let date = dateFormatter.date(from: self) else { return nil }

        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: date)
    }

    public func formatTimeToMin() -> String {
        let components = self.split(separator: ":")

        guard components.count == 2,
              let hours = components.first,
              let minutes = components.last,
              let _ = Int(minutes) else {
            return self
        }

        let formattedHours = String(format: "%02d", Int(hours) ?? 0)
        let formattedMinutes = String(format: "%02d", Int(minutes) ?? 0)

        return "\(formattedHours):\(formattedMinutes)"
    }
}
