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
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!

    
    var photoList = PhotoList.sharedInstance
    var delegate: ViewController? = nil
    var selectedImages = [PhotoKey]()
    
    
    
    
    
    //Mark: - Functions
    
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
            let photoIndex = self.photoList.sortedListOfPhotoIndices(.discards)[indexPath.row]
            let photoKey = self.photoList.discards[photoIndex]!
            let manager = PHImageManager.defaultManager()
            
                manager.requestImageForAsset(photoKey.asset,
                targetSize: CGSizeMake(4000.0, 4000.0),
                contentMode: .AspectFill ,
                options: nil) { (result, _) in
                    cell.image!.image = result!
            }
            })
        cell.hidden = false
        cell.image.hidden = false
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        selectedCell.checkIcon.hidden = false
        let photoIndex =  self.photoList.sortedListOfPhotoIndices(.discards)[indexPath.row]
        let thePhotoKey = self.photoList.discards[photoIndex]
        self.selectedImages.append(thePhotoKey!)
        if selectedImages.count != 0 {
            trashButton.enabled = true
            undoButton.enabled = true
            
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath){
        let selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        selectedCell.checkIcon.hidden = true
        let photoIndex =  self.photoList.sortedListOfPhotoIndices(.discards)[indexPath.row]
        for i in 0 ..< selectedImages.count {
            if selectedImages[i].index == photoIndex {                                      //BUGGY dispatch????
                selectedImages.removeAtIndex(i)
            }
        }
        if selectedImages.count == 0 {
            trashButton.enabled = false
            undoButton.enabled = false
        }
    }
    
    
    func deleteFromPhone() {
        var assetsToDelete = [PHAsset]()
        var photoKeyArray = [PhotoKey]()
        PHPhotoLibrary.sharedPhotoLibrary().performChanges( {
            for thePhotoKey in self.selectedImages{
                assetsToDelete.append(thePhotoKey.asset)
                photoKeyArray.append(thePhotoKey)
            }
            PHAssetChangeRequest.deleteAssets(assetsToDelete)
            },
            completionHandler: { success, error in
                NSLog("Finished deleting asset. %@",  (success ? "Success" : error!))
                if success {
                    for thePhotoKey in photoKeyArray{
                        self.photoList.deletePhoto(thePhotoKey)
                        self.collectionView.reloadData()
                    }
                }
        })
    }
    
    
    
    
    
    //Mark: - IBAction
    
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
    
    @IBAction func swipeBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
   //end
}




