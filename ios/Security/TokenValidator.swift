import Foundation

struct TokenPayload: Codable {
    
    let cardId: String
    let iat: Int64
    let exp: Int64
    let nonce: String
    
}

enum TokenError: String, Error {
    
    case invalid = "TOKEN_INVALID"
    case expired = "TOKEN_EXPIRED"
    
    var message: String {
        switch self {
        case .expired:
            return "Token Expirado"
        case .invalid:
            return "Token Inválido"
        }
    }
    
}

enum SecureCardCloseReason: String {
    
    case userDismiss = "USER_DISMISS"
    case timeout = "TIMEOUT"
    
}


final class TokenValidator {
    
    // MARK: - Properties

    private static let secret = "iO"
    
    // MARK: - Functions

    static func simpleHash(_ str: String) -> String {
        var h: Int32 = 0
        for scalar in str.unicodeScalars {
            h = (h &* 31) &+ Int32(scalar.value)
        }
        if h < 0 { h = -h }
        return String(h, radix: 36)
    }
    
    static func decodePayload(_ encoded: String) -> TokenPayload? {
        guard let decodedStr = encoded.removingPercentEncoding,
              let data = decodedStr.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(TokenPayload.self, from: data)
    }
    
    static func validate(token: String, expectedCardId: String) -> Result<TokenPayload, TokenError> {
        let parts = token.split(separator: ".")
        guard parts.count == 2 else { return .failure(.invalid) }
        
        let payloadEncoded = String(parts[0])
        let signature = String(parts[1])
        
        let expectedSig = simpleHash("\(payloadEncoded).\(secret)")
        guard signature == expectedSig else { return .failure(.invalid) }
        
        guard let payload = decodePayload(payloadEncoded) else { return .failure(.invalid) }
        
        guard payload.cardId == expectedCardId else { return .failure(.invalid) }
        
        let now = Int64(Date().timeIntervalSince1970 * 1000)
        guard now <= payload.exp else { return .failure(.expired) }
        
        return .success(payload)
    }
    
    static func remainingSeconds(token: String, now: Date = Date()) -> TimeInterval {
        let parts = token.split(separator: ".")
        guard parts.count == 2,
              let payload = decodePayload(String(parts[0])) else { return 0 }
        let nowMs = Int64(now.timeIntervalSince1970 * 1000)
        let remainingMs = max(0, payload.exp - nowMs)
        return TimeInterval(remainingMs) / 1000.0
    }
}
