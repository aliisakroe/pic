//
//  ScrollViewController.swift
//  
//
//  Created by Aliisa Roe on 12/5/15.
//
//

import UIKit
import Photos

class ScrollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var collectionView: UICollectionView!

    var photoList = PhotoList.sharedInstance
    var delegate:ScrollViewControllerDelegate? = nil
    
    
    
    //Mark: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCollectionView", name: newKeepersNotification, object: nil)
    }
    
    func reloadCollectionView(){
        dispatch_async(dispatch_get_main_queue(), { self.collectionView.reloadData() })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.keepers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("scrollImage", forIndexPath: indexPath) as! CollectionViewCell
        dispatch_async(dispatch_get_main_queue(), {
            let manager = PHImageManager.defaultManager()
            let photoIndex =  self.photoList.sortedListOfPhotoIndices(.keepers)[indexPath.row]
            let photoKey = self.photoList.keepers[photoIndex]!
            manager.requestImageForAsset(photoKey.asset,
                targetSize: CGSizeMake(4000.0, 4000.0),
                contentMode: .AspectFill ,
                options: nil) { (result, _) in
                    cell.imageForScroll!.image = result!
            }
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        selectedCell.highlighted = true
        let photoIndex =  self.photoList.sortedListOfPhotoIndices(.keepers)[indexPath.row]
        let photoKey = self.photoList.allPhotoList[photoIndex]!
        if (self.delegate != nil) {
            self.delegate!.scrollViewSelection(self, selectedPhotoKey: photoKey)
        }
    }
    
    
    
    //end
}
