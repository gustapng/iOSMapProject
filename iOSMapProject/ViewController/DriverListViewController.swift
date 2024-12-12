//
//  DriversListViewController.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 08/12/24.
//

import UIKit
import Combine

class DriverListViewController: UIViewController {

    // MARK: - Properties
    var viewModel: DriversListViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private let sheetLabel = StandardSheetLabel()
    private let confirmButton = StandardButton()
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    init(viewModel: DriversListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        setupSheetLabel()
        setupTableView()
        setupConfirmButton()
        setupLoadingIndicator()
        observablesViewModel()
    }

    // MARK: - Combine Observables
    private func observablesViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
                self?.confirmButton.isEnabled = !isLoading
                self?.confirmButton.alpha = isLoading ? 0.5 : 1.0
            }
            .store(in: &cancellables)

        viewModel.$successMessage
             .sink { [weak self] successMessage in
                 if let successMessage = successMessage {
                       self?.showAlertWithCompletion(title: "Sucesso", message: successMessage) {
                           self?.dismiss(animated: true) {
                               self?.viewModel.clearMapView()
                               self?.viewModel.navigateToHistoric()
                           }
                       }
                 }
             }
             .store(in: &cancellables)

        viewModel.$errorMessage
             .sink { [weak self] errorMessage in
                 if let errorMessage = errorMessage {
                     self?.showAlert(title: "Erro", message: errorMessage)
                 }
             }
             .store(in: &cancellables)
    }

    // MARK: - Loading Indicator
    private func setupLoadingIndicator() {
        loadingIndicator.hidesWhenStopped = true
    }

    // MARK: - SheetLabel
    private func setupSheetLabel() {
        sheetLabel.configure(title: viewModel.sheetLabelText)
    }

    // MARK: - TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(DriverTableViewCell.self, forCellReuseIdentifier: DriverTableViewCell.identifier)
        tableView.reloadData()
    }

    // MARK: - ConfirmButton
    private func setupConfirmButton() {
        confirmButton.configure(title: viewModel.confirmButtonTitle) { [weak self] in
            self?.viewModel.confirmButtonAction()
        }
    }
}

extension DriverListViewController: ViewCodeProtocol {
    func setupViewCode() {
        view.backgroundColor = .white
        setupAddSubview()
        setupConstraint()
    }

    func setupAddSubview() {
        view.addSubview(sheetLabel)
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        view.addSubview(loadingIndicator)
    }

    func setupConstraint() {
        sheetLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            sheetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sheetLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            sheetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            sheetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: sheetLabel.bottomAnchor, constant: 15),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension DriverListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drivers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DriverTableViewCell.identifier, for: indexPath) as? DriverTableViewCell else {
            return UITableViewCell()
        }

        let raceOption = viewModel.drivers[indexPath.row]
        cell.configure(with: raceOption)

        if raceOption.name == viewModel.selectedDriver?.name {
            cell.contentView.backgroundColor = UIColor(named: "GrayLight")
        } else {
            cell.contentView.backgroundColor = .white
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDriver = viewModel.drivers[indexPath.row]
        viewModel.selectedDriver = selectedDriver
        tableView.reloadData()
    }
}
