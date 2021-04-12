
import UIKit

class CustomCollectionViewCellObject {
    let object: CustomImage
    let delegate: CustomCollectionViewCellDelegate
    
    init(object: CustomImage, delegate: CustomCollectionViewCellDelegate) {
        self.object = object
        self.delegate = delegate
    }
}

protocol CustomCollectionViewCellDelegate {
}

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    private var imageID: String?

    override func configure(with object: Any) {
        guard let data = object as? CustomCollectionViewCellObject else { fatalError("Not correct object") }
            self.imageID = data.object.imageURL
            self.image.image = data.object.image()
    }
}
