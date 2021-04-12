

import UIKit
import Foundation


class FirstViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var imageCollection: UICollectionView!
    

//    var model: CustomImageModel? = CustomImageModel(isLoggedUser: true)//  CustomImageModel(isLoggedUser: false) // dependency injection  найти и сохранить хорошую инфу а то вечно забываю и на слове божьем работает
    var model: CustomImageModel?
    var currentSelectedImageIndex = -1
    //MARK: Variables
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        imageCollection.register(cellType: CustomCollectionViewCell.self)
        imageCollection.register(cellType: PlusCollectionViewCell.self) // self тк передаю сам класс
        imageCollection.delegate = self
        imageCollection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
//        let indexPath = IndexPath(row: currentSelectedImageIndex, section: 0)
//        imageCollection.deleteItems(at: [indexPath])
        imageCollection.reloadData()
    }
    
    
    
    
    //MARK: IBActions

    @IBAction func addImageButtonPressed(_ sender: UIButton) {
//        performImagePicker()
        imageCollection.reloadData()
    }

    //MARK: Functions
     
    private func performImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension FirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            guard let model = model else { fatalError("Model is absent!") }
           
            picker.dismiss(animated: true){
                guard let object = CustomImage(for: pickedImage) else { fatalError("Что-то не так с картинкой") }
                model.imagesList.append(object)
                print("model.imagesList: \(model.imagesList.count)")
                
                let indexPath = IndexPath(row: model.imagesList.count, section: 0)
                print("try 2 reload \(indexPath), ")
                self.imageCollection.reloadData()
                //                self.imageCollection.insertItems(at: [indexPath])
            }
        }
    }
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else { fatalError("Model is absent!") }
        print(#function, model.imagesList.count)
        model.imagesList.map({print($0?.key)})
        return model.imagesList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performImagePicker()
        } else {
            print("test")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let selectedPhotoViewController = storyboard.instantiateViewController(identifier: String(describing: SelectedPhotoViewController.self)) as SelectedPhotoViewController
            selectedPhotoViewController.modalPresentationStyle = .fullScreen
            
            selectedPhotoViewController.selectedImageIndex = indexPath.row - 1
            selectedPhotoViewController.model = self.model
            currentSelectedImageIndex = indexPath.row - 1
            self.navigationController?.pushViewController(selectedPhotoViewController, animated: true)
        }
     }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let model = self.model else {
            return UICollectionViewCell()
        } // проверка что модель загрузилась кооректо и не было краша
        
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  PlusCollectionViewCell.cellIdentifier, for: indexPath) as? PlusCollectionViewCell  else { return UICollectionViewCell() }
            return cell
        } else {
            // Создать ячейку
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  CustomCollectionViewCell.cellIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
            print("ячейка для картинки", model.imagesList[indexPath.row - 1]?.key)
            // Вызвать метод для конфигурации ячейки
            cell.configure(with: CustomCollectionViewCellObject(object: model.imagesList[indexPath.row - 1]!, delegate: self))
            cell.image.contentMode = .scaleAspectFill
            return cell
        }
    }
}

// Устанавливаем размеры картинок
extension FirstViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 10) / 2
        print("width: \(width)")
        return CGSize(width: width,
                      height: width)
    }
}

extension FirstViewController: CustomCollectionViewCellDelegate {
}

//MARK: - Наваяем расширения для ячеек коллекции, чтобы потом меньше писанины было
extension UICollectionViewCell {
    
    /// Чтобы не нужно было в дизайнере указывать reuseIdentifier, создадим переменную, которая будет за это отвечать
    /// reuseIdentifier = наименование класса ячейки
    static var cellIdentifier: String { return String(describing: self) }
    
    /// Метод для конфигурации ячейки
    /// Универсальный метод. Для любого типа кастомной и не очень ячейки -
    /// Передаём любой объект, а внутри кастим к тому, который нам нужен.
    @objc func configure (with object: Any) {
        // расширили функциональость класса UICollectionViewCell   каждая ячейка поддерживает этот метод  но реализует по свойму и потому надо его ovverride  в класса где создаю ячейку 
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type){
        // Создать/вызвать ниб для кастомной ячейки - НАЗВАНИЕ НИБА СОВАДАТЬ ДОЛЖНО С НАЗВАНИЕМ КЛАССА ЯЧЕЙКИ (прост для удобства)
        let nib = UINib(nibName: cellType.cellIdentifier, bundle: nil)
        // 2. Зарегать ячейку для коллекции
        register(nib, forCellWithReuseIdentifier: cellType.cellIdentifier)
    }
}
