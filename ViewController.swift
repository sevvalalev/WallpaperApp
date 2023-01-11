//
//  ViewController.swift
//  WallpaperApp
//
//  Created by Sevval Alev on 9.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    var pictures: ImageData? {
        didSet{
            collectionView.reloadData()
        }
    }
    var imageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        fetchData()
        configureCollectionView()
    }
    
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0.5
        collectionView.register(PictureCollectionViewCell.nib(), forCellWithReuseIdentifier: PictureCollectionViewCell.identifier)//we are giving our custom cell with identifier
        
    }
    
    private func fetchData() {
        imageManager.delegate = self
        imageManager.fetchPhotos(type: .random)
    }
    
    func configureTextField() {
        searchTextField.placeholder = "Search picture"
        searchTextField.delegate = self
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 0.5
        searchTextField.layer.borderColor = UIColor.gray.cgColor
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchTextField.endEditing(true)
        guard let text = searchTextField.text else { return }
        imageManager.fetchPhotos(type: .query(searchedText: text))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Search Picture"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.endEditing(true)
        guard let text = searchTextField.text else {return}
        imageManager.fetchPhotos(type: .query(searchedText: text))
    }
    
}

//MARK: - Collection View Data Source Methods
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures?.results.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifier, for: indexPath) as? PictureCollectionViewCell {
            cell.configure(with: pictures?.results[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedImageVC") as? SelectedImageVC {
            let selectedPicture = pictures?.results[indexPath.row]
            vc.picture = selectedPicture
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension ViewController: SendPictureDataTransferDelegate {
    func sendPictureData(picture: ImageData) {
        pictures = picture
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3.2, height: view.frame.size.height/4)
    }
}
