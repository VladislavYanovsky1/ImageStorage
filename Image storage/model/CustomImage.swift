
import Foundation
import UIKit


class CustomImage: Codable {
    var imageURL: String
    var comment: String? = nil
    var isLiked: Bool =  false
    private var isFake: Bool // не меняем эти значения из других мест
    private var privateImage: UIImage = UIImage()
    
    let key: String
    ///Инициализируем объект с картинкой
    ///Остальные проперти - опциональны и при добавлении картинки равны ничему.
    /// инит опциональный для того, чтобы вернулся нил, если что-то пойдёт не так
    init?(for image: UIImage, isFake: Bool = false ) {
        self.key =  UUID().uuidString
        let fileName = key + ".jpg"
        self.isFake = isFake
        self.privateImage = image
    
        
        ///если я правильно понимаю, что imageURL == fileName а не путь к файлу
        self.imageURL = fileName
        
    
        ///Сохранить картинку ЮзерДефолтс
        if !isFake{
           guard let _ = saveImageLocally(image: image, with: fileName) else { fatalError("Что-то не так с сохранением") }}
        
    }
    

    
    private enum CodingKeys: String, CodingKey {
           case imageURL
           case comment
           case isLiked
           case key
       }
    
    //достает из Json
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            imageURL = try container.decode(String.self, forKey: .imageURL)
            comment = try container.decodeIfPresent(String.self, forKey: .comment)
            isLiked = try container.decode(Bool.self, forKey: .isLiked)
            key = try container.decode(String.self, forKey: .key)
            privateImage = UIImage()
            isFake = false
            
        }

    // кодирует
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.imageURL, forKey: .imageURL)
        try container.encode(self.comment, forKey: .comment)
        try container.encode(self.isLiked, forKey: .isLiked)
        try container.encode(self.key, forKey: .key)
    }
    
    func removeFromUserDefaults() {
        print("Удаляю объект для ключа", self.key)
        UserDefaults.standard.removeObject(forKey: self.key)
    }
    
    /// загрузить изо по имени из локального хранилища
    func image() -> UIImage? {
        if isFake {
            return self.privateImage
        }
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(self.imageURL)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        return nil
    }
}

private extension CustomImage {
    
    /// Сохранить изо локально
    func saveImageLocally(image: UIImage, with name: String) -> Bool? {
        guard !isFake else {
            return false
        }
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false}
        
        
        let fileURL = documentsDirectory.appendingPathComponent(name)
        guard let data = image.jpegData(compressionQuality: 1) else { return false}
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
            saveToUserDefaults()
            print("SAVED IMAGE: \(fileURL)")
            return true
            
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    
    //
    /// Сохранить себя в ЮзерДефаултс
    /// Ключ: свой ЮЮАйДи
    func saveToUserDefaults () {
        do {
            /// Получить только имя файла - это будет ключ для хранения в юзерДефолтс
            let key = self.imageURL.components(separatedBy: ".").first!
            try UserDefaults.standard.setObject(self, forKey: key)
            print("Saved to UserDefaults for key: \(key)")
        }  catch {
            print(error)
        }
    }
    
    
    
    
}


