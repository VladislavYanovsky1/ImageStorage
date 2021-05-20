
import Foundation
import UIKit

var fakeImagesList: [CustomImage] = [
    CustomImage(for: UIImage(named: "1") ?? UIImage(),isFake: true),
    CustomImage(for: UIImage(named: "2") ?? UIImage(),isFake: true),
    CustomImage(for: UIImage(named: "3") ?? UIImage(),isFake: true)

].compactMap({ $0 }) 

class CustomImageModel {
    
    var imagesList: [CustomImage] = []
    let isLoggedUser: Bool
    
    init(isLoggedUser: Bool) {
        self.isLoggedUser = isLoggedUser
    
        if isLoggedUser == false {
            self.imagesList = fakeImagesList
        }  else {
            loadImagesFromDefaults()
        }
    }
    
    func getFiles() -> [String]? {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            let imageFiles = directoryContents.filter{ $0.pathExtension == "jpg" }
            let imageFilesNames = imageFiles.map{ $0.deletingPathExtension().lastPathComponent }
            return imageFilesNames
        } catch {
            print(error)
            return nil
        }
    }
    
    func removeItemAtIndex(index: Int) {
        imagesList[index].removeFromUserDefaults()
        imagesList.remove(at: index)
    }
    
    func loadImagesFromDefaults() {
        
        guard let files = getFiles() else {
            print("There is no prev saved files")
            return
        }
        
        for imageID in files{
            do {
               let image = try UserDefaults.standard.getObject(forKey: imageID, castTo: CustomImage.self)
                imagesList.append(image)
                print("appended: \(image)")
            } catch  {
                print(error)
            }
            
        }
        
    }
    
    
    
}
