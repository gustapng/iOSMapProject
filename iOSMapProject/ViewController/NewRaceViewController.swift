//
//  ItemListViewController.swift
//  iOSMapProject
//
//  Created by Gustavo Ferreira dos Santos on 06/12/24.
//

import MapKit
import Combine

class NewRaceController: UIViewController {

    // MARK: - Properties
    private let viewModel: NewRaceViewModel
    private let coordinator: AppCoordinator
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private let userTextField = UITextField()
    private let originTextField = UITextField()
    private let destinationTextField = UITextField()
    private let searchRaceButton = StandardButton()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    init(viewModel: NewRaceViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        setupButton()
        setupTapGesture()
        setupLoadingIndicator()
        observablesViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Combine Observables
    private func observablesViewModel() {
        viewModel.$inputUserText
            .sink { [weak self] updatedText in
                self?.userTextField.text = updatedText
            }
            .store(in: &cancellables)

        viewModel.$inputOriginText
            .sink { [weak self] updatedText in
                self?.originTextField.text = updatedText
            }
            .store(in: &cancellables)

        viewModel.$inputDestinationText
            .sink { [weak self] updatedText in
                self?.destinationTextField.text = updatedText
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
                self?.searchRaceButton.isEnabled = !isLoading
                self?.searchRaceButton.alpha = isLoading ? 0.5 : 1.0
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
             .sink { [weak self] errorMessage in
                 if let errorMessage = errorMessage {
                     self?.showAlert(title: "Erro", message: errorMessage)
                 }
             }
             .store(in: &cancellables)

        Publishers.CombineLatest3(viewModel.$raceOptions, viewModel.$raceOptionsRoute, viewModel.$customerId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] raceOptions, raceOptionsRoute, customerId in
                if !raceOptions.isEmpty && !raceOptionsRoute.isEmpty, let customerId = customerId {
                    self?.coordinator.navigateToMapView(
                        raceOptions: raceOptions,
                        raceOptionsRoute: raceOptionsRoute,
                        customerId: customerId
                    )
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

    // MARK: - OriginTextField
    @objc func originTextFieldDidChange() {
        if let text = originTextField.text {
            viewModel.updateInputOriginText(text)
        }
    }

    // MARK: - UserTextField
    @objc func destinationTextFieldDidChange() {
        if let text = destinationTextField.text {
            viewModel.updateInputDestinationText(text)
        }
    }

    // MARK: - SearchRaceButton
    private func setupButton() {
        searchRaceButton.configure(title: "Buscar Corrida") { [weak self] in
            self?.buttonTapped()
        }
    }

    @objc private func buttonTapped() {
        if !viewModel.validateFields() {
            showAlert(title: "Erro", message: viewModel.errorMessage ?? "")
            return
        }

        viewModel.fetchRacesOptions(customerId: viewModel.inputUserText,
                                    origin: viewModel.inputOriginText,
                                    destination: viewModel.inputDestinationText)
    }

    // MARK: - Screen Tap
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapOutside() {
        view.endEditing(true)
    }
}

extension NewRaceController: ViewCodeProtocol {
    func setupViewCode() {
        view.backgroundColor = .white
        navigationController?.navigationBar.adjustTitlePosition(verticalOffset: -10, color: UIColor(named: "GreenLight"))
        setupAddSubview()
        setupConstraint()
    }

    func setupAddSubview() {
        view.addSubview(userTextField)
        view.addSubview(originTextField)
        view.addSubview(destinationTextField)
        view.addSubview(searchRaceButton)

        TextFieldHelper.setupStandardTextField(userTextField, placeholder: "ID do Usuário", icon: viewModel.getUserIDIcon())
        userTextField.addTarget(self, action: #selector(userTextFieldDidChange), for: .editingChanged)

        TextFieldHelper.setupStandardTextField(originTextField, placeholder: "Endereço de Origem", icon: viewModel.getOriginIcon())
        originTextField.addTarget(self, action: #selector(originTextFieldDidChange), for: .editingChanged)

        TextFieldHelper.setupStandardTextField(destinationTextField, placeholder: "Endereço de Destino", icon: viewModel.getDestionationIcon())
        destinationTextField.addTarget(self, action: #selector(destinationTextFieldDidChange), for: .editingChanged)
    }

    func setupConstraint() {
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        originTextField.translatesAutoresizingMaskIntoConstraints = false
        destinationTextField.translatesAutoresizingMaskIntoConstraints = false
        searchRaceButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            userTextField.heightAnchor.constraint(equalToConstant: 50),

            originTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            originTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            originTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            originTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            originTextField.heightAnchor.constraint(equalToConstant: 50),

            destinationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            destinationTextField.topAnchor.constraint(equalTo: originTextField.bottomAnchor, constant: 20),
            destinationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            destinationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            destinationTextField.heightAnchor.constraint(equalToConstant: 50),

            searchRaceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchRaceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            searchRaceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchRaceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            searchRaceButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
