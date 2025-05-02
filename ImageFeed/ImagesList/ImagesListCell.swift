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
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    func configure(with model: ImagesListCellViewModel) {
        cellImage.image = model.image
        likeButton.isSelected = model.isLiked
        dateLabel.text = model.date
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}
