import Foundation
import Security

class CredentialsManager {
    static let shared = CredentialsManager()
    
    private let service = "MovieSearch.credentials"
    private let usernameKey = "userKey"
    private let passwordKey = "passKey"
    
    func saveCredentials(username: String, password: String) -> Bool {
        guard let usernameData = username.data(using: .utf8),
              let passwordData = password.data(using: .utf8) else {
            return false
        }

        // Check if username already exists in Keychain
        if retrievePassword(username: username) != nil {
            // Username already exists, update the password
            return updatePassword(passwordData, for: username)
        }

        let queryUsername: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: usernameKey,
            kSecValueData: usernameData
        ]

        let queryPassword: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: passwordKey,
            kSecValueData: passwordData
        ]

        let statusUsername = SecItemAdd(queryUsername as CFDictionary, nil)
        guard statusUsername == errSecSuccess else {
            print("Error saving username to Keychain: \(statusUsername)")
            return false
        }

        let statusPassword = SecItemAdd(queryPassword as CFDictionary, nil)
        guard statusPassword == errSecSuccess else {
            print("Error saving password to Keychain: \(statusPassword)")
            return false
        }

        return true
    }

    private func updatePassword(_ passwordData: Data, for username: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: usernameKey
        ]

        let attributesToUpdate: [CFString: Any] = [
            kSecValueData: passwordData
        ]

        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        guard status == errSecSuccess else {
            print("Error updating password in Keychain: \(status)")
            return false
        }

        return true
    }

    
    func retrievePassword(username: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: usernameKey,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else {
            print("Error retrieving password from Keychain: \(status)")
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
