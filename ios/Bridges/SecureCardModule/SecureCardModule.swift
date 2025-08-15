//
//  SecureCardModule.swift
//  iOChallenge
//
//  Created by Carlos Llerena on 8/15/25.
//

import Foundation
import UIKit
import React

@objc(SecureCardModule)
final class SecureCardModule: RCTEventEmitter {
    
    // MARK: - Override Functions
    
    override func supportedEvents() -> [String] {
        return ["onCardDataShown", "onValidationError", "onSecureViewClosed", "onSecureViewOpened"]
    }
        
    // MARK: - Functions
    
    @objc(openSecureView:token:resolver:rejecter:)
    func openSecureView(_ cardId: String,
                        token: String,
                        resolver: @escaping RCTPromiseResolveBlock,
                        rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let topViewController = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first?
                .rootViewController else { return }
            
            let secureCardViewController = SecureCardViewController()
            
            secureCardViewController.cardId = cardId
            secureCardViewController.token = token
            secureCardViewController.delegate = self
            secureCardViewController.modalPresentationStyle = .fullScreen
            
            topViewController.present(secureCardViewController, animated: true)
        }
    }
}


// MARK: - SecureCardViewDelegate

extension SecureCardModule: SecureCardViewDelegate {
    
    func secureViewOpened(cardId: String) {
        sendEvent(withName: "onSecureViewOpened", body: ["cardId": cardId])
    }
    
    func secureViewDataShown(cardId: String) {
        sendEvent(withName: "onCardDataShown", body: ["cardId": cardId])
    }
    
    func secureViewValidationError(tokenError: TokenError) {
        sendEvent(withName: "onValidationError", body: ["code": tokenError.rawValue, "message": tokenError.message])
    }
    
    func secureViewClosed(cardId: String, reason: SecureCardCloseReason) {
        sendEvent(withName: "onSecureViewClosed", body: ["cardId": cardId, "reason": reason.rawValue])
    }
    
}
