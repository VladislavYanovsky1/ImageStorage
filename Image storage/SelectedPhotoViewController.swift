
import UIKit

class SelectedPhotoViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    

    var selectedImageIndex: Int?
    var model: CustomImageModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedImageIndex ?? -1 >= 0 {
            guard let model = model, let index = selectedImageIndex else { return }
            let imageObject = model.imagesList[index] 
            selectedImageView.image =  imageObject.image()
            selectedImageView.contentMode = .scaleAspectFill
        } else {
            return
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let index = selectedImageIndex else { return }
        
        model?.removeItemAtIndex(index: index)
        navigationController?.popViewController(animated: true)
    }
}
