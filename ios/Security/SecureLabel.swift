//
//  SecureLabel.swift
//  iOChallenge
//
//  Created by Carlos Llerena on 8/15/25.
//

import UIKit

open class SecureLabel: UIView {

    // MARK: - Views

    private var secureContainer: UIView = {
        let secureField = SecureField()
        return secureField.secureContainer ?? UIView()
    }()

    public let component: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Functions

    private func setup() {
        addSubview(secureContainer)
        secureContainer.pinToSuperview()
        secureContainer.addSubview(component)
        component.pinToSuperview()
    }

}

final class SecureField: UITextField {

    // MARK: - Views

    weak var secureContainer: UIView? {
        let secureView = self.subviews.filter({ subview in
            type(of: subview).description().contains("CanvasView")
        }).first
        secureView?.translatesAutoresizingMaskIntoConstraints = false
        secureView?.isUserInteractionEnabled = true
        return secureView
    }

    // MARK: - Computed properties

    public override var canBecomeFirstResponder: Bool { false }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.isSecureTextEntry = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    public override func becomeFirstResponder() -> Bool { false }

}
