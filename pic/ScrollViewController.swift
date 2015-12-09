//
//  ScrollViewController.swift
//  
//
//  Created by Aliisa Roe on 12/5/15.
//
//

import UIKit

class ScrollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var collectionView: UICollectionView!

    
    var photoList = PhotoList.sharedInstance
    var delegate:ScrollViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCollectionView", name: newKeepersNotification, object: nil)
    }
    
    func reloadCollectionView(){
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        print(photoList.keepers.count)
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.keepers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("scrollImage", forIndexPath: indexPath) as! CollectionViewCell
        dispatch_async(dispatch_get_main_queue(), {
            let allPhotos = Array(self.photoList.getTotalImages(.keepers).values)
            cell.imageForScroll!.image = allPhotos[indexPath.row]
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellImage = Array(photoList.getTotalImages(.keepers).values)[indexPath.row]
        if (delegate != nil) {
            delegate!.scrollViewSelection(self, image: cellImage)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
