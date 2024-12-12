//
//  ItemListViewController.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import UIKit
import Combine

class HistoricViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: HistoricViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private let userTextField = UITextField()
    private let driverTextField = UITextField()
    private let driverPickerView = UIPickerView()
    private let infoLabel = UILabel()
    private let tableView = UITableView()
    private let filterButton = StandardButton()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Initializer and Setup
    init(viewModel: HistoricViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        setupPickerView()
        setupInfoLabel()
        setupTableView()
        setupTapGesture()
        setupButton()
        setupLoadingIndicator()
        observablesViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Combine Observables
    private func observablesViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
                self?.filterButton.isEnabled = !isLoading
                self?.filterButton.alpha = isLoading ? 0.5 : 1.0
            }
            .store(in: &cancellables)

        viewModel.$races
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
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
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }

    // MARK: - UserTextField
    @objc func userTextFieldDidChange() {
        if let text = userTextField.text {
            viewModel.updateInputUserText(text)
        }
    }

    // MARK: - DriverPickerView
    private func setupPickerView() {
        let pickerView = DriverPickerView(options: viewModel.options) { selectedOption in
            self.viewModel.updateSelectedOption(selectedOption)
            self.driverTextField.text = selectedOption
        }
        driverTextField.inputView = pickerView
        driverTextField.inputAccessoryView = createPickerToolbar()
    }

    private func createPickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let width = view.frame.width
        toolbar.frame.size.width = width

        let doneButton = UIBarButtonItem(title: "Selecionar", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = UIColor(named: "GreenLight")
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([spacer, doneButton], animated: true)
        return toolbar
    }

    @objc private func doneButtonTapped() {
        if driverTextField.text == nil || driverTextField.text!.isEmpty {
            let selectedOption = viewModel.options.first
            viewModel.updateSelectedOption(selectedOption ?? "")
            driverTextField.text = selectedOption
        }

        driverTextField.resignFirstResponder()
    }

    // MARK: - Screen Tap
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapOutside() {
        view.endEditing(true)
    }

    // MARK: - Info UILabel
    private func setupInfoLabel() {
        infoLabel.text = viewModel.infoLabelText
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textColor = UIColor(named: "GreenLight")
        infoLabel.textAlignment = .center
    }

    // MARK: - TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(RaceHistoricTableViewCell.self, forCellReuseIdentifier: RaceHistoricTableViewCell.identifier)
        tableView.reloadData()
    }

    // MARK: - FilterButton
    private func setupButton() {
        filterButton.configure(title: viewModel.filterButtonTitle) { [weak self] in
            self?.handleFilterButtonTapped()
        }
    }

    @objc private func handleFilterButtonTapped() {
        if let errorMessage = viewModel.filterButtonAction() {
            showAlert(title: "Erro", message: errorMessage)
        }
    }
}

extension HistoricViewController: ViewCodeProtocol {
    func setupViewCode() {
        view.backgroundColor = .white
        navigationController?.navigationBar.adjustTitlePosition(verticalOffset: -10, color: UIColor(named: "GreenLight"))
        setupAddSubview()
        setupConstraint()
    }

    func setupAddSubview() {
        view.addSubview(userTextField)
        view.addSubview(driverTextField)
        view.addSubview(infoLabel)
        view.addSubview(tableView)
        view.addSubview(filterButton)

        TextFieldHelper.setupStandardTextField(userTextField, placeholder: "ID do Usuário", icon: viewModel.getUserIDIcon())
        userTextField.addTarget(self, action: #selector(userTextFieldDidChange), for: .editingChanged)

        TextFieldHelper.setupStandardTextField(driverTextField, placeholder: "Selecione o motorista", icon: viewModel.getCarIcon())
        driverTextField.delegate = self
    }

    func setupConstraint() {
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        driverTextField.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        driverPickerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            userTextField.heightAnchor.constraint(equalToConstant: 50),

            driverTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            driverTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            driverTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            driverTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            driverTextField.heightAnchor.constraint(equalToConstant: 50),

            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: driverTextField.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension HistoricViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == driverTextField {
            return false
        }
        return true
    }
}

extension HistoricViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = viewModel.options[row]
        viewModel.updateSelectedOption(selectedOption)
        driverTextField.text = selectedOption
    }
}

extension HistoricViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.races.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RaceHistoricTableViewCell.identifier, for: indexPath) as? RaceHistoricTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        let ride = viewModel.races[indexPath.row]
        cell.configure(with: ride)

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detailsAction = UIContextualAction(style: .normal, title: "Ver detalhes") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let selectedRide = self.viewModel.races[indexPath.row]
            self.viewModel.didTapDetails(ride: selectedRide)
            completionHandler(true)
        }

        detailsAction.backgroundColor = UIColor(named: "GreenLight")
        let configuration = UISwipeActionsConfiguration(actions: [detailsAction])
        return configuration
    }
}
