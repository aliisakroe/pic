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
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoList = PhotoList()
    var delegate : DiscardsVC? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if photoList.discards.count == 0 {
            label.text = "You have not discarded any photos yet!"
            label.hidden = false
        } else {
            collectionView.hidden = false
        }
        
        // Uncomment the following line to preserve selection between presentations
       // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        // Do any additional setup after loading the view.
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell //ERROR
        dispatch_async(dispatch_get_main_queue(), {
        let allPhotos = Array(self.photoList.getTotalImages("discards").values)
        cell.image!.image = allPhotos[indexPath.row]
        cell.hidden = false
        cell.image.hidden = false
        })
        return cell
    }
    
   /* @IBAction func swipeBack(sender: UIPanGestureRecognizer) {
        performSegueWithIdentifier("swipeBack", sender: nil)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "swipeBack" {
            let destination = segue.destinationViewController as? MainCompare
        }
        // Pass the selected object to the new view controller.
    }
    */

}
