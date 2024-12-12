//
//  RideDetailsViewController.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 11/12/24.
//

import UIKit

class RideHistoricDetailsViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: RideHistoricDetailsViewModel

    // MARK: - UI Components
    private let containerView = UIView()
    private let closeButton = CancelButton()
    private let originTextField = UILabel()
    private let destinationTextField = UILabel()
    private let distanceTextField = UILabel()
    private let durationTextField = UILabel()

    init(viewModel: RideHistoricDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        setupContainerView()
        setupCloseButton()
        setupFields()
    }

    // MARK: - UIView
    private func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Close UIButton
    private func setupCloseButton() {
        closeButton.configure() { [weak self] in
            self?.didTapClose()
        }
    }

    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Setup all Fields
    private func setupFields() {
        originTextField.text = viewModel.origin
        originTextField.numberOfLines = 0
        originTextField.font = UIFont.systemFont(ofSize: 12)
        originTextField.textColor = .gray

        destinationTextField.text = viewModel.destination
        destinationTextField.numberOfLines = 0
        destinationTextField.font = UIFont.systemFont(ofSize: 12)
        destinationTextField.textColor = .gray

        distanceTextField.text = viewModel.distance
        distanceTextField.numberOfLines = 0
        distanceTextField.font = UIFont.systemFont(ofSize: 12)
        distanceTextField.textColor = .gray

        durationTextField.text = viewModel.duration
        durationTextField.numberOfLines = 0
        durationTextField.font = UIFont.systemFont(ofSize: 12)
        durationTextField.textColor = .gray
    }
}

extension RideHistoricDetailsViewController: ViewCodeProtocol {
    func setupViewCode() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupAddSubview()
        setupConstraint()
    }

    func setupAddSubview() {
        view.addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(originTextField)
        containerView.addSubview(destinationTextField)
        containerView.addSubview(distanceTextField)
        containerView.addSubview(durationTextField)
    }

    func setupConstraint() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        originTextField.translatesAutoresizingMaskIntoConstraints = false
        destinationTextField.translatesAutoresizingMaskIntoConstraints = false
        distanceTextField.translatesAutoresizingMaskIntoConstraints = false
        durationTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 160),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),

            originTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            originTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            originTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -65),

            destinationTextField.topAnchor.constraint(equalTo: originTextField.bottomAnchor, constant: 14),
            destinationTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            destinationTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -65),

            distanceTextField.topAnchor.constraint(equalTo: destinationTextField.bottomAnchor, constant: 14),
            distanceTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            distanceTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -65),

            durationTextField.topAnchor.constraint(equalTo: distanceTextField.bottomAnchor, constant: 14),
            durationTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            durationTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -65)
        ])
    }
}
