import LocalAuthentication
import Foundation

class BiometricAuthService {
    static let shared = BiometricAuthService()
    
    private let userDefaults = UserDefaults.standard
    private let biometricEnabledKey = "biometricAuthEnabled"
    private let storedEmailKey = "storedEmail"
    private let storedPasswordKey = "storedPassword"
    
    private init() {}
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .none
        }
    }
    
    var isBiometricEnabled: Bool {
        get { userDefaults.bool(forKey: biometricEnabledKey) }
        set { userDefaults.set(newValue, forKey: biometricEnabledKey) }
    }
    
    func storeCredentials(email: String, password: String) {
        userDefaults.set(email, forKey: storedEmailKey)
        userDefaults.set(password, forKey: storedPasswordKey)
    }
    
    func getStoredCredentials() -> (email: String, password: String)? {
        guard let email = userDefaults.string(forKey: storedEmailKey),
              let password = userDefaults.string(forKey: storedPasswordKey) else {
            return nil
        }
        return (email, password)
    }
    
    func clearStoredCredentials() {
        userDefaults.removeObject(forKey: storedEmailKey)
        userDefaults.removeObject(forKey: storedPasswordKey)
        isBiometricEnabled = false
    }
    
    func authenticate() async throws {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw AppError.biometricNotAvailable
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                 localizedReason: "Log in to your account") { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: AppError.biometricAuthenticationFailed)
                }
            }
        }
    }
} 