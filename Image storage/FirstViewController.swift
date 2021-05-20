

import UIKit
import Foundation


class FirstViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var imageCollection: UICollectionView!

    //MARK: Variables
    
    var model: CustomImageModel?
    var currentSelectedImageIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        imageCollection.register(cellType: CustomCollectionViewCell.self)
        imageCollection.register(cellType: PlusCollectionViewCell.self)
        imageCollection.delegate = self
        imageCollection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)

        imageCollection.reloadData()
    }

    //MARK: IBActions

    @IBAction func addImageButtonPressed(_ sender: UIButton) {
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
            
            guard let model = model else { fatalError("Model is absent") }
           
            picker.dismiss(animated: true){
                guard let object = CustomImage(for: pickedImage) else { fatalError("There is something wrong with the picture") }
                model.imagesList.append(object)
                print("model.imagesList: \(model.imagesList.count)")
                let indexPath = IndexPath(row: model.imagesList.count, section: 0)
                print("try 2 reload \(indexPath), ")
                self.imageCollection.reloadData()
               
            }
        }
    }
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else { fatalError("Model is absent") }
        print(#function, model.imagesList.count)
        model.imagesList.forEach({print($0.key)})
        return model.imagesList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performImagePicker()
        } else {
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
        }
        
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  PlusCollectionViewCell.cellIdentifier, for: indexPath) as? PlusCollectionViewCell  else { return UICollectionViewCell() }
            return cell
        } else {

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  CustomCollectionViewCell.cellIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }

            cell.configure(with: CustomCollectionViewCellObject(object: model.imagesList[indexPath.row - 1], delegate: self))
            cell.image.contentMode = .scaleAspectFill
            return cell
        }
    }
}


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

extension UICollectionViewCell {

    static var cellIdentifier: String { return String(describing: self) }

    @objc func configure (with object: Any) {
  
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type){
        let nib = UINib(nibName: cellType.cellIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: cellType.cellIdentifier)
    }
}
