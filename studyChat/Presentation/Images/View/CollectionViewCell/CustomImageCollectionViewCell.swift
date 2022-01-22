//
//  CustomImageCollectionViewCell.swift
//  studyChat
//
//  Created by Gleb Bocharov on 22.11.2021.
//

import UIKit

class CustomImageCollectionViewCell: UICollectionViewCell {
    
    var networkService: NetworkService?
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setConstraints() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    func configure(with model: ResponseData) {
        let url = model.previewURL
        if #available(iOS 15.0, *) {
            fetchRequestImage(url: url)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 15.0, *)
    func fetchRequestImage(url: String) {
        Task {
            do {
                guard let networkService = networkService else { return }
                let image = try await networkService.sendImageRequest(url: url)
                updateCollectionViewCell(with: image)
            }
        }
    }
    
    func updateCollectionViewCell(with image: UIImage) {
        self.imageView.image = image
    }
    
}
