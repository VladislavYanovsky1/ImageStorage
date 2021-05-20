
import Foundation

protocol ObjectSavable {
    func setObject<T: Codable>(_ object: T, forKey: String) throws
    func getObject<T: Codable>(forKey: String, castTo type: T.Type) throws -> T
}

extension UserDefaults: ObjectSavable {
    func setObject<T: Codable>(_ object: T, forKey: String) throws   {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
        
    func getObject <T: Codable> (forKey: String, castTo type: T.Type) throws -> T {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
