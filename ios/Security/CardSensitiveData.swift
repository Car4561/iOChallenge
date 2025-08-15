//
//  SecureCardDataStore.swift
//  iOChallenge
//
//  Created by Carlos Llerena on 8/15/25.
//

import Foundation

struct CardSensitiveData {
    let alias: String
    let pan: String
    let cvv: String
    let expiry: String
    let holder: String
}

final class SecureCardDataStore {
    
    // MARK: - Properties

    static let shared = SecureCardDataStore()
    
    // MARK: - Lifecycle

    private init() {}
    
    // MARK: - Data

    private let db: [String: CardSensitiveData] = [
        "card_001": .init(alias: "Crédito Visa", pan: "4557168192411234", cvv: "123",  expiry: "12/28", holder: "JUAN PEREZ"),
        "card_003": .init(alias: "Crédito Amex", pan: "371449635399012",  cvv: "1234", expiry: "05/29", holder: "CARLOS RAMIREZ"),
        "card_004": .init(alias: "Débito Visa", pan: "4557128415153456", cvv: "321",  expiry: "11/26", holder: "LUISA FERNANDEZ"),
        "card_006": .init(alias: "Crédito Visa Oro",pan: "4045124115171122", cvv: "999",  expiry: "09/28", holder: "SOFIA MARTINEZ"),
        "card_007": .init(alias: "Débito Amex Blue",pan: "371449635393344",  cvv: "5678", expiry: "07/26", holder: "RAFAEL TORRES"),
    ]
    
    // MARK: - Functions
    
    func fetch(cardId: String) -> CardSensitiveData? { db[cardId] }
    
    func prettyPAN(_ pan: String) -> String {
        if pan.count == 15 {
            let a = pan.prefix(4)
            let b = pan.dropFirst(4).prefix(6)
            let c = pan.suffix(5)
            return "\(a)  \(b)  \(c)"
        }
        return stride(from: 0, to: pan.count, by: 4).map { i in
            let s = pan.index(pan.startIndex, offsetBy: i)
            let e = pan.index(s, offsetBy: min(4, pan.distance(from: s, to: pan.endIndex)), limitedBy: pan.endIndex) ?? pan.endIndex
            return String(pan[s..<e])
        }.joined(separator: "  ")
    }
}
