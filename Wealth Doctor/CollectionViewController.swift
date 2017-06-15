




import UIKit

class DynamicCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
        
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
}
