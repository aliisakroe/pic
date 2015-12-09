//
//  DiscardsVC.swift
//  pic
//
//  Created by Aliisa Roe on 12/4/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "photoCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class DiscardsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    
    var photoList = PhotoList.sharedInstance
    var delegate: ViewController? = nil
    var selectedImages = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.allowsMultipleSelection = true
        self.navigationController!.navigationBar.hidden = false
        if photoList.discards.count == 0 {
            label.text = "You have not discarded any photos yet!"
            label.hidden = false
        } else {
            collectionView.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.discards.count
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell 
        dispatch_async(dispatch_get_main_queue(), {
        let allPhotos = Array(self.photoList.getTotalImages(.discards).values)
        cell.image!.image = allPhotos[indexPath.row]
        cell.hidden = false
        cell.image.hidden = false
        })
        return cell
    }
    
    func deleteImage(element: UIImage) {
        selectedImages = selectedImages.filter() { $0 !== element }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        selectedCell.checkIcon.hidden = false
        let cellImage = Array(photoList.getTotalImages(.discards).values)[indexPath.row]
        self.selectedImages.append(cellImage)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath){
        let selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        selectedCell.checkIcon.hidden = true
        let cellImage = Array(photoList.getTotalImages(.discards).values)[indexPath.row]
        deleteImage(cellImage)
    }
    
    @IBAction func backUndo(sender: AnyObject) {
        if (delegate != nil) {
            delegate!.restoreImagesToKeepers(selectedImages)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func trash(sender: AnyObject) {
         print(selectedImages)
        deleteFromPhone()
    }
    
    
    func deleteFromPhone() {
       var assetsToDelete = [PHAsset]()
        var photoKeyArray = [PhotoKey]()
        let swipe = Swipe()
            PHPhotoLibrary.sharedPhotoLibrary().performChanges( {
                for image in self.selectedImages{
                    let thePhotoKey = swipe.imageToPhotoKey(image)
                    assetsToDelete.append(thePhotoKey.asset)
                    photoKeyArray.append(thePhotoKey)
                }
                PHAssetChangeRequest.deleteAssets(assetsToDelete)
                },
                completionHandler: { success, error in
                    NSLog("Finished deleting asset. %@", (success ? "Success" : error!))
                    if success {
                        for thePhotoKey in photoKeyArray{
                            self.photoList.deletePhoto(thePhotoKey)
                            self.collectionView.reloadData()
                        }
                    }
            })
    }
    
}
