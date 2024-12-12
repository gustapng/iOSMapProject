//
//  DriverTableViewCell.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import UIKit

class DriverTableViewCell: UITableViewCell {
    static let identifier = "DriverTableViewCell"

    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let vehicleLabel = UILabel()
    private let assessmentLabel = UILabel()
    private let valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with raceOption: RaceOption) {
        nameLabel.text = "Nome: \(raceOption.name)"
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .gray

        descriptionLabel.text = "Descrição: \(raceOption.description)"
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0

        vehicleLabel.text = "Veículo: \(raceOption.vehicle)"
        vehicleLabel.numberOfLines = 0
        vehicleLabel.font = UIFont.systemFont(ofSize: 12)
        vehicleLabel.textColor = .gray

        assessmentLabel.text = "Avaliação: \(raceOption.review.rating)/5.0"
        assessmentLabel.font = UIFont.systemFont(ofSize: 12)
        assessmentLabel.textColor = .gray

        valueLabel.text = String(format: "Valor da corrida: R$ %.2f", raceOption.value)
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.textColor = .gray
    }

    func setup() {
        setupAddSubview()
        setupConstraint()
    }

    func setupAddSubview() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(vehicleLabel)
        contentView.addSubview(assessmentLabel)
        contentView.addSubview(valueLabel)
    }

    func setupConstraint() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        vehicleLabel.translatesAutoresizingMaskIntoConstraints = false
        assessmentLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            vehicleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            vehicleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            vehicleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            assessmentLabel.topAnchor.constraint(equalTo: vehicleLabel.bottomAnchor, constant: 10),
            assessmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),

            valueLabel.centerYAnchor.constraint(equalTo: assessmentLabel.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            descriptionLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}
