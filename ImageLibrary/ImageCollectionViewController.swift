//
//  ImageCollectionViewController.swift
//  ImageLibrary
//
//  Created by Aislin Liu on 7/8/20.
//  Copyright © 2020 Aislin Liu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController, UIDropInteractionDelegate, UINavigationControllerDelegate {
    
    var galleryChoice : String = "Monday"
    
    var cache = Dictionary<String, Array<UIImage>>()
    

    //MARK: UIDropInteractionDelegate
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for dragItem in session.items {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (obj, err) in
                if let err = err {
                    print("sad error \(err)")
                    return
                }
                
                guard let draggedImage = obj as? UIImage else {return}
                
                DispatchQueue.main.async{
                    self.cache[self.galleryChoice]?.append(draggedImage)
                    self.collectionView.reloadData()
                }
                
            })
            
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addInteraction(UIDropInteraction(delegate: self))
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: CGFloat(200), height: CGFloat(200))
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 50
        cache[galleryChoice] = Array<UIImage>()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cache[galleryChoice]?.count ?? 0
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        cell.imageView.image = cache[galleryChoice]?[indexPath.item]
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 12 * 3) / 3 //some width
        let height = width * 1.5 //ratio
        return CGSize(width: width, height: height)
    }


}

class ImageCell : UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension ImageCollectionViewController: GallerySelectionDelegate {
  func gallerySelected(_ newGallery: String) {
    galleryChoice = newGallery
    if !cache.keys.contains(galleryChoice) {
        cache[galleryChoice] = Array<UIImage>()
    }
    collectionView.reloadData()
  }
}
