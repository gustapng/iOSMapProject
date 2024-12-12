//
//  RaceHistoricTableViewCell.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import UIKit

class RaceHistoricTableViewCell: UITableViewCell {
    static let identifier = "RaceTableViewCell"

    private let dateTimeLabel = UILabel()
    private let driverNameLabel = UILabel()
    private let valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with ride: Ride) {
        dateTimeLabel.text = "Data/Hora: \(ride.date.formatDate() ?? "\(ride.date)")"
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12)
        dateTimeLabel.textColor = .gray

        driverNameLabel.text = "Motorista: \(ride.driver.name)"
        driverNameLabel.font = UIFont.systemFont(ofSize: 12)
        driverNameLabel.textColor = .gray

        valueLabel.text = String(format: "Valor: R$ %.2f", ride.value)
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.textColor = .gray
    }

    func setup() {
        setupAddSubview()
        setupConstraint()
    }

    func setupAddSubview() {
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(driverNameLabel)
        contentView.addSubview(valueLabel)
    }

    func setupConstraint() {
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        driverNameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dateTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),

            valueLabel.centerYAnchor.constraint(equalTo: dateTimeLabel.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            driverNameLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 10),
            driverNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            driverNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            driverNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
