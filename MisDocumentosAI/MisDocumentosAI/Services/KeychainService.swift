import Foundation
import Security

/// Servicio para gestionar credenciales de forma segura usando Keychain
class KeychainService {
    static let shared = KeychainService()
    
    private let serviceName = "com.misdocumentos.ai"
    
    private init() {}
    
    // MARK: - Token Management
    
    /// Guardar un token en el Keychain
    func saveToken(_ token: String, for account: String) {
        // Eliminar token existente si lo hay
        deleteToken(for: account)
        
        guard let data = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("⚠️ Error al guardar token en Keychain: \(status)")
        }
    }
    
    /// Obtener un token del Keychain
    func getToken(for account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    /// Eliminar un token del Keychain
    func deleteToken(for account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    /// Verificar si existe un token
    func hasToken(for account: String) -> Bool {
        return getToken(for: account) != nil
    }
    
    // MARK: - Secure Data Management
    
    /// Guardar datos seguros genéricos
    func saveSecureData(_ data: Data, for key: String) {
        deleteSecureData(for: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    /// Obtener datos seguros genéricos
    func getSecureData(for key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else { return nil }
        return item as? Data
    }
    
    /// Eliminar datos seguros
    func deleteSecureData(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Codable Extension

extension KeychainService {
    /// Guardar un objeto Codable de forma segura
    func save<T: Encodable>(_ object: T, for key: String) throws {
        let data = try JSONEncoder().encode(object)
        saveSecureData(data, for: key)
    }
    
    /// Obtener un objeto Codable del Keychain
    func get<T: Decodable>(_ type: T.Type, for key: String) throws -> T? {
        guard let data = getSecureData(for: key) else { return nil }
        return try JSONDecoder().decode(type, from: data)
    }
}
