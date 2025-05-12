//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 23.02.2025.
//

import UIKit
import Kingfisher

struct ImagesListCellViewModel {
    let image: UIImage
    let isLiked: Bool
    let date: String
}

final class ImagesListCell: UITableViewCell {
    // MARK: - Services
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UI Elements
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBAction private func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
        print("Like button is tapped")
    }
    
    func configure(with model: ImagesListCellViewModel) {
        cellImage.image = model.image
        likeButton.isSelected = model.isLiked
        dateLabel.text = model.date
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(cell: ImagesListCell, _ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}


