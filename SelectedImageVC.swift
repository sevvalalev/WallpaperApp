//
//  SelectedImageVC.swift
//  WallpaperApp
//
//  Created by Sevval Alev on 11.01.2023.
//

import UIKit
import SDWebImage

class SelectedImageVC: UIViewController {

    var picture: Result?
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var downloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func configureButton() {
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0

        
        downloadButton.frame = CGRect(x: 100, y: 100, width: 250, height: 40)
        downloadButton.setTitle("Download", for: UIControl.State.normal)
        downloadButton.setTitleColor(UIColor.label, for: UIControl.State.normal)
        downloadButton.backgroundColor = UIColor.clear
        downloadButton.layer.borderWidth = 1.0
        downloadButton.layer.cornerRadius = cornerRadius
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               downloadButton.layer.borderColor = UIColor.label.cgColor
       }
    }
    
    func prepareUI() {
        guard let picture = picture else {
            return
        }
        
        imageView.layer.cornerRadius = 10
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let regularURL = picture.urls?.regular else { return }
        imageView.sd_setImage(with: URL(string: regularURL))
    }
    
    
    @IBAction func downloadButton(_ sender: UIButton) {
        saveImage()
    }
    
    
    func saveImage() {
        guard let selectedImage = imageView.image else{ return }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            let alert = UIAlertController(title: "Succes", message: "Download image successfully to gallery.🥳", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }
}

