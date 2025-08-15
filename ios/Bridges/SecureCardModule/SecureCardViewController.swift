//
//  SecureCardViewController.swift
//  iOChallenge
//
//  Created by Carlos Llerena on 8/15/25.
//

import UIKit

protocol SecureCardViewDelegate: AnyObject {
    func secureViewOpened(cardId: String)
    func secureViewDataShown(cardId: String)
    func secureViewValidationError(tokenError: TokenError)
    func secureViewClosed(cardId: String, reason: SecureCardCloseReason)
}

final class SecureCardViewController: UIViewController {
    
    // MARK: - Views

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Datos de Tarjeta"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(red: 0.09, green: 0.25, blue: 0.60, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.09, green: 0.25, blue: 0.60, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stripeView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let panLabel: SecureLabel = {
        let secureLabel = SecureLabel()
        secureLabel.component.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .heavy)
        secureLabel.component.textColor = .white
        secureLabel.component.textAlignment = .center
        secureLabel.component.adjustsFontSizeToFitWidth = true
        secureLabel.component.minimumScaleFactor = 0.7
        secureLabel.translatesAutoresizingMaskIntoConstraints = false
        return secureLabel
    }()
    
    private let expiryTitle: UILabel = {
        let label = UILabel()
        label.text = "VENCE"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expiryValue: SecureLabel = {
        let secureLabel = SecureLabel()
        secureLabel.component.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        secureLabel.component.textColor = .white
        secureLabel.component.translatesAutoresizingMaskIntoConstraints = false
        secureLabel.translatesAutoresizingMaskIntoConstraints = false
        return secureLabel
    }()
    
    private let cvvTitle: UILabel = {
        let label = UILabel()
        label.text = "CVV"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cvvValue: SecureLabel = {
        let secureLabel = SecureLabel()
        secureLabel.component.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        secureLabel.component.textColor = .white
        secureLabel.translatesAutoresizingMaskIntoConstraints = false
        return secureLabel
    }()
    
    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copiar número de tarjeta", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties

    var cardId: String = ""
    var token: String = ""
    var timeout: TimeInterval = 60
    weak var delegate: SecureCardViewDelegate?
    
    private var timer: Timer?
    private var blurView: UIVisualEffectView?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        delegate?.secureViewOpened(cardId: cardId)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        switch TokenValidator.validate(token: token, expectedCardId: cardId) {
        case .failure(let error):
            delegate?.secureViewValidationError(tokenError: error)
            showAlert(title: "Error de Token", message: error.message)
            dismiss(animated: true)
            return
        case .success:
            break
        }
        
        guard let data = SecureCardDataStore.shared.fetch(cardId: cardId) else {
            return
        }
        

        setupHeaderUI(alias: data.alias)
        setupCardUI()
        delegate?.secureViewDataShown(cardId: cardId)

        setData(data)
        startSessionTimer()
    }
    
    // MARK: - Functions
    
    private func setupHeaderUI(alias: String) {
        subtitleLabel.text = alias
     
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        copyButton.addTarget(self, action: #selector(copyPanTapped), for: .touchUpInside)
    }
    
    private func setupCardUI() {
        stripeView.backgroundColor = .black
        stripeView.translatesAutoresizingMaskIntoConstraints = false
        
        panLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cardContainer)
        cardContainer.addSubview(stripeView)
        cardContainer.addSubview(panLabel)
        cardContainer.addSubview(expiryTitle)
        cardContainer.addSubview(expiryValue)
        cardContainer.addSubview(cvvTitle)
        cardContainer.addSubview(cvvValue)
        view.addSubview(copyButton)
        
        cardContainer.setHorizontalEdges(with: .init(constant: 16))
        stripeView.setHorizontalEdges()
        panLabel.setHorizontalEdges()
        copyButton.setHorizontalEdges(with: .init(constant: 42))
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            
            stripeView.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 24),
            stripeView.heightAnchor.constraint(equalToConstant: 52),
            
            panLabel.topAnchor.constraint(equalTo: stripeView.bottomAnchor, constant: 24),
            
            expiryTitle.topAnchor.constraint(equalTo: panLabel.bottomAnchor, constant: 20),
            expiryTitle.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            
            expiryValue.leadingAnchor.constraint(equalTo: expiryTitle.leadingAnchor),
            expiryValue.topAnchor.constraint(equalTo: expiryTitle.bottomAnchor, constant: 4),
            expiryValue.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -20),
            
            cvvTitle.topAnchor.constraint(equalTo: panLabel.bottomAnchor, constant: 20),
            cvvTitle.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            
            cvvValue.trailingAnchor.constraint(equalTo: cvvTitle.trailingAnchor),
            cvvValue.topAnchor.constraint(equalTo: cvvTitle.bottomAnchor, constant: 4),
            cvvValue.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -20),
            copyButton.topAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: 24),
            copyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func setData(_ data: CardSensitiveData) {
        let pretty = SecureCardDataStore.shared.prettyPAN(data.pan)
        panLabel.component.text = pretty
        expiryValue.component.text = data.expiry
        cvvValue.component.text = data.cvv
    }
    
    @objc private func closeTapped() {
        cancelSessionTimer()
        delegate?.secureViewClosed(cardId: cardId, reason: .userDismiss)
        dismiss(animated: true)
    }
    
    @objc private func copyPanTapped() {
        UIPasteboard.general.string = panLabel.component.text
    }
    
    private func startSessionTimer() {
        cancelSessionTimer()
        let remaining = TokenValidator.remainingSeconds(token: token) // ← aquí
        let interval = max(0, min(timeout, remaining))
        
        guard interval > 0 else {
            sessionDidTimeout()
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(sessionDidTimeout),
                                     userInfo: nil,
                                     repeats: false)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc private func sessionDidTimeout() {
        dismiss(animated: true)
        delegate?.secureViewClosed(cardId: cardId, reason: .timeout)
        showAlert(title: "Sesión expirada", message:  "Por seguridad dejamos de mostrar los datos de tu tarjeta.")
    }
    
    private func cancelSessionTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func showAlert(title: String, message: String, completion: (() -> ())? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            completion?()
        }))
        guard let topViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?
            .rootViewController else { return }
        topViewController.present(alert, animated: true)
    }
    
    deinit {
        cancelSessionTimer()
    }
}
