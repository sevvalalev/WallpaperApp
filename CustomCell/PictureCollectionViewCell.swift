//
//  PictureCollectionViewCell.swift
//  WallpaperApp
//
//  Created by Sevval Alev on 9.01.2023.
//

import UIKit
import SDWebImage

class PictureCollectionViewCell: UICollectionViewCell {

    static let identifier = "PictureCollectionViewCell"
    
    @IBOutlet private var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
     

    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    func configure(with image: Result?) {
        guard let image = image else {
            return
        }
        
        guard let imageUrl = image.urls?.regular else { return }
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.sd_setImage(with: URL(string: imageUrl))
    }

}
