import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
//        fullsizeImageView.kf.cancelDownloadTask()
//    }
    
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
