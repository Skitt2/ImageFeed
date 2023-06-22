import UIKit

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!

    @IBOutlet var likeButton: UIButton!
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            self.likeButton.imageView?.image = UIImage(named: "activeLike")
        } else {
            self.likeButton.imageView?.image = UIImage(named: "noActiveLike")
        }
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
