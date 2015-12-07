//
//  ScrollViewController.swift
//  
//
//  Created by Aliisa Roe on 12/5/15.
//
//

import UIKit

class ScrollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:ScrollViewControllerDelegate? = nil

  //  @IBOutlet weak var scrollView: UIScrollView!
  //  @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
   // @IBOutlet weak var scrollView: UIScrollView

    
    var photoList = PhotoList.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCollectionView", name: newKeepersNotification, object: nil)
    }

    
        //imageView = UIImageView(image: UIImage(named: "image.png"))
        
        //let scrollView = UIScrollView(frame: view.bounds)
       /* scrollView.frame = self.view.frame
        scrollView.backgroundColor = UIColor.grayColor()
        scrollView.contentSize = self.collectionView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        scrollView.addSubview(collectionView)
        view.addSubview(scrollView)
        print(collectionView)*/

        // Do any additional setup after loading the view.
    
    
    
    func reloadCollectionView(){
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    func collectionViewContentSize() -> CGSize {
        let width = photoList.keepers.count * 100
         return CGSize(width: width, height: 128)
    }
    */
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        print(photoList.keepers.count)
        return 1
    }
    
    //0 when first load, need notification to tell to reload collection view after BSImagePicker ??
    
    
    
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
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
        let cellImage = Array(photoList.getTotalImages(.keepers).values)[indexPath.row]
        if (delegate != nil) {
            delegate!.scrollViewSelection(self, image: cellImage)
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let image = Array(photoList.getTotalImages(.keepers).values)[indexPath.section]
    }
    
    func removeView() {
        self.view.removeFromSuperview()
    }
    
  /*  override func viewDidLayoutSubviews() {
        <#code#>
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
