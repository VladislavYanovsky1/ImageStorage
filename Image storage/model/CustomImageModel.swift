//
//  CustomImageModel.swift
//  Image storage
//
//  Created by Влад on 2/17/21.
//

import Foundation
import UIKit

var fakeImagesList: [CustomImage?] = [
    CustomImage(for: UIImage(named: "1") ?? UIImage(),isFake: true),
    CustomImage(for: UIImage(named: "2") ?? UIImage(),isFake: true),
    CustomImage(for: UIImage(named: "3") ?? UIImage(),isFake: true)

].compactMap({ $0 }) // избавляемся от картинки который нет


class CustomImageModel {
    
    var imagesList: [CustomImage?] = []
    let isLoggedUser: Bool
    
    init(isLoggedUser: Bool) {
        self.isLoggedUser = isLoggedUser
        
        if isLoggedUser == false {
            self.imagesList = fakeImagesList
        }  else {
            loadImagesFromDefaults()
        }
    }
    
    
    
    /// Будем считать, что в песочнице для нашей проги в Документах хранятся только наши фотки
    /// Названия фоток - ЮЮАйДи.jpg
    /// берём только название: 6BD805B9-AB61-4165-835A-C31397BEC17A
    /// Это будет ключ в ЮзерДефаултс в котором будет храниться инфа об объекте
    func getFiles() -> [String]? {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
//            print(directoryContents)

            // if you want to filter the directory contents you can do like this:
            let imageFiles = directoryContents.filter{ $0.pathExtension == "jpg" }
//            print("images urls:", imageFiles)
            let imageFilesNames = imageFiles.map{ $0.deletingPathExtension().lastPathComponent }
//            print("imageFiles list:", imageFilesNames)
            return imageFilesNames
        } catch {
            print(error)
            return nil
        }
    }
    
    func removeItemAtIndex(index: Int) {
        imagesList[index]?.removeFromUserDefaults()
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
