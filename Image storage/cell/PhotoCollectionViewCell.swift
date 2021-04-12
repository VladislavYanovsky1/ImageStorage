

import UIKit



class PhotoCollectionViewCellObject {
    let object: CustomImage
    let delegate: CustomCollectionViewCellDelegate
    
    init(object: CustomImage, delegate: CustomCollectionViewCellDelegate) {
        self.object = object
        self.delegate = delegate
    }
}


class PhotoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var image: UIImageView!
    

    
    private var imageID: String?
    
    override func configure(with object: Any) {
        print(#function)
        guard let data = object as? PhotoCollectionViewCellObject else { fatalError("Not correct object") }
        
        if  self.imageID == nil {
            self.imageID = data.object.imageURL
            self.image.image = data.object.image()
        }
        
        
        
        
    }
}
