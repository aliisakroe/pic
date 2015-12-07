//
//  DiscardsVC.swift
//  pic
//
//  Created by Aliisa Roe on 12/4/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import UIKit

private let reuseIdentifier = "photoCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class DiscardsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var largePhotoIndexPath : NSIndexPath? {
        didSet {
            //2
            var indexPaths = [NSIndexPath]()
            if largePhotoIndexPath != nil {
                indexPaths.append(largePhotoIndexPath!)
            }
            if oldValue != nil {
                indexPaths.append(oldValue!)
            }
            //3
            collectionView?.performBatchUpdates({
                self.collectionView?.reloadItemsAtIndexPaths(indexPaths)
                return
                }){
                    completed in
                    //4
                    if self.largePhotoIndexPath != nil {
                        self.collectionView?.scrollToItemAtIndexPath(
                            self.largePhotoIndexPath!,
                            atScrollPosition: .CenteredVertically,
                            animated: true)
                    }
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoList = PhotoList.sharedInstance
   // var delegate : DiscardsVC? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if photoList.discards.count == 0 {
            label.text = "You have not discarded any photos yet!"
            label.hidden = false
        } else {
            collectionView.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
    
    
    /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
        let cellImage = Array(photoList.getTotalImages("keepers").values)[indexPath.row]
        if (delegate != nil) {
            delegate!.scrollViewSelection(self, image: cellImage)
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let image = Array(photoList.getTotalImages("keepers").values)[indexPath.section]
        NSNotificationCenter.defaultCenter().postNotificationName(selectedCellNotification, object: self)
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let selectedPhoto = photoForIndexPath(indexPath)
            
            // New code
            if indexPath == largePhotoIndexPath {
                var size = collectionView.bounds.size
                size.height -= topLayoutGuide.length
                size.height -= (sectionInsets.top + sectionInsets.right)
                size.width -= (sectionInsets.left + sectionInsets.right)
                return selectedPhoto.sizeToFillWidthOfSize(size)
            }
            // Previous code
            if var size = selectedPhoto.thumbnail?.size {
                size.width += 10
                size.height += 10
                return size
            }
            return CGSize(width: 100, height: 100)
    }
    
    
    
    
    */
    
    
    
    //I WOULD LIKE AN OPTION TO RESTORE A PHOTO TO KEEPERS, DELETE PHOTOS FROM PHONE
    
    
    
    
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "swipeBack" {
            let destination = segue.destinationViewController as? MainCompare
        }
        // Pass the selected object to the new view controller.
    }
    */

    //end
}
