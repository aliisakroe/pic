//
//  ViewController.swift
//  pic
//
//  Created by Aliisa Roe on 11/29/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import Social
//import Cocoa
//import NSImage


/** to do
- resize photos
- app icon
- app loadscreen
-final image, then restore one from discards to keepers...
- add swipe back gesture to discards
- social
*/
/* ask
- error mesage for collection view
- resize images***
- singleton okay?
*/



let newKeepersNotification = "Reload the scroll view"
let lastPhoto = "final steps"
let finalPhoto = "final photo"

protocol ScrollViewControllerDelegate {
    func scrollViewSelection(controller:ScrollViewController, image: UIImage)
}

protocol DiscardsViewControllerDelegate {
    func restoreImagesToKeepers(imageArray: [UIImage])
}

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate, ScrollViewControllerDelegate, DiscardsViewControllerDelegate  {
    
    
    var photoList = PhotoList.sharedInstance
    var vc = BSImagePickerViewController()
    var selectedPhotos : [PHAsset] = []
    var previousMainImage : UIImage?
    var swipe = Swipe()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    let secondPhoto = UIImageView()
    
    @IBOutlet weak var doubleCheckButton: UIButton!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet var scrollViewController: UIView!
    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var mainSwipeRight: UISwipeGestureRecognizer!
    @IBOutlet weak var mainSwipeLeft: UISwipeGestureRecognizer!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var swipeUpMain: UISwipeGestureRecognizer!
    
    
    
    // MARK: - BSImageSelector updates most of what viewDidLoad would
    
    @IBAction func imagePicker(sender: AnyObject) {

            selectedPhotos = [PHAsset]()
            let _ = BSImagePickerViewController()
            
            bs_presentImagePickerController(vc, animated: true,
                select: { (asset: PHAsset) -> Void in
                    
                //if findPhotoKey finds key, knows created and reselected
                if let reselectedPhotoKey = self.swipe.findPhotoKeyForAsset(asset) {
                        self.photoList.keepPhoto(reselectedPhotoKey, list: .keepers)
                    }
                //if findPhotoKey doesn't find key creates a new one
                else {
                        let newPhotoKey = self.swipe.makePhotoKeyFromPHAsset(asset)
                    self.photoList.keepPhoto(newPhotoKey, list: .keepers)
                    }
                    
                }, deselect: { (asset: PHAsset) -> Void in
                    
                    let photoKeyForAsset = self.swipe.findPhotoKeyForAsset(asset)!
                    self.photoList.keepPhoto(photoKeyForAsset, list: .discards)
                    
                }, cancel: { (assets: [PHAsset]) -> Void in
                }, finish: { (assets: [PHAsset]) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.picButton.hidden = true
                      //  var imageArray = self.swipe.getInitialImages(self.photoList.keepers.count)
//    resize                   let resizedImg = self.swipe.resizeImage(imageArray[0], targetSize: self.imgMain.frame.size)
                        
                        let manager = PHImageManager.defaultManager()
                        var firstAsset = Array(self.photoList.keepers.values)[0].asset
                        manager.requestImageForAsset(firstAsset,
                            targetSize: CGSizeMake(4000.0, 4000.0),
                            contentMode: .AspectFill ,
                            options: nil) { (result, _) in
                                var imageForPhoto = result!
                                self.imgMain.image = imageForPhoto
                        }
                        self.imgMain.hidden = false
                        // tells the scroll view to reload data
                        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
                    })
                    
                }, completion: nil)
    }
    
    
    func setImg(imageView: UIImageView) {
        let manager = PHImageManager.defaultManager()
        var firstAsset = Array(self.photoList.keepers.values)[0].asset
        manager.requestImageForAsset(firstAsset,
            targetSize: CGSizeMake(4000.0, 4000.0),
            contentMode: .AspectFill ,
            options: nil) { (result, _) in
                var imageForPhoto = result!
                imageView.image = imageForPhoto
        }
    }
    
    
    // MARK: - functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkImgMain", name: newKeepersNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "lastPhotoView", name: lastPhoto, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: nil, name: finalPhoto, object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.hidden = true
        
        //only allow portrait upright!!
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        if photoList.keepers.count == 1 {
            lastPhotoView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            if imgMain.image != nil {
                performSegueWithIdentifier("landscape", sender: self)
            }
        }
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            navigationController?.popViewControllerAnimated(false)
            if photoList.keepers.count == 1 {
                lastPhotoView()                                 //NOT WORKING
            }
        }
    }
    
    func checkImgMain() {
        if swipe.photoIsIn(imgMain.image!) == .discards {
            let nextPhoto = photoList.getTotalImages(.keepers)[0]
            imgMain.image = nextPhoto
        }
    }

    //from scrollViewDelegate!!!
    
    func scrollViewSelection(controller: ScrollViewController, image: UIImage) {
        imgMain.image! = image
    }
    
    func restoreImagesToKeepers(imageArray: [UIImage]){
        for image in imageArray{
            var thePhotoKey = swipe.imageToPhotoKey(image)
            photoList.keepPhoto(thePhotoKey, list: .keepers)
            NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        }
    }
    
    func lastPhotoView() {
        print("lastPhotoView()")
        self.scrollViewController.hidden = true
        imgMain.image = Array(photoList.keepers.values)[0].image
        imgMain.removeGestureRecognizer(swipeUpMain)
        shareButtonOutlet.hidden = false
    }
    
    
    
    
    
    
    //MARK: - SOCIAL FRAMEWORK actionSheet
    
    func shareOptions() {
        let actionSheet = UIAlertController(title: "", message: "Share your Note", preferredStyle: UIAlertControllerStyle.ActionSheet)

        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
                // Check if sharing to Twitter is possible.
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                    // Initialize the default view controller for sharing the post.
                    let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    
                    // Set the note text as the default post message.
                    self.presentViewController(twitterComposeVC, animated: true, completion: nil)
            }
                else {
                    //self.showAlertMessage("You are not logged in to your Twitter account.")
            }
        }
    
        // Configure a new action to share on Facebook.
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                    let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    
                    facebookComposeVC.setInitialText("MY FOTO MAKE U SO JELLY")
                    
                    self.presentViewController(facebookComposeVC, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage("You are not connected to your Facebook account.")
            }
        }
        
        // Configure a new action to show the UIActivityViewController
       /* let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default) { (action) -> Void in
            let activityViewController = UIActivityViewController(activityItems: [self.imgMain.image!], applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }*/
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        //actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    

    

    
    //MARK: - Navigation
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "discards" {
            let destination = segue.destinationViewController as? DiscardsVC
            destination!.delegate = self
        }
        if segue.identifier == "scrollCollectionView" {
            let destination = segue.destinationViewController as? ScrollViewController
            destination!.delegate = self
        }
        if segue.identifier == "landscape" {
            let destination = segue.destinationViewController as? LandscapeViewController
        }
    }
    
    
    
    
    // MARK: - Action (Gestures)
    
    
    @IBAction func swipeToCollectionView(gesture: UIPanGestureRecognizer) {
        if (gesture.state != .Ended){                                                           //HACK!!
            return
        }
        performSegueWithIdentifier("discards", sender: gesture)
    }
    
    func setImg(imageView: UIImageView, asset: PHAsset) {
        let manager = PHImageManager.defaultManager()
        manager.requestImageForAsset(asset,
            targetSize: CGSizeMake(4000.0, 4000.0),
            contentMode: .AspectFill ,
            options: nil) { (result, _) in
                var imageForPhoto = result!
                imageView.image = imageForPhoto
        }
    }
    
    func swipeAndSetPhoto(imageView: UIImageView, direction: Swipe.direction) {
        let currentPhotoKey = swipe.imageToPhotoKey(imageView.image!)
        var nextPhotoKey = swipe.getNextPhotoKey(currentPhotoKey, direction: direction)
        setImg(imageView, asset: nextPhotoKey.asset)
    }
    
    @IBAction func swipeUpMain(sender: AnyObject) {
        let newPhotoKey = swipe.swipeUpDelete(imgMain)
        setImg(imgMain, asset: newPhotoKey.asset)
        if photoList.keepers.count == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(lastPhoto, object: self)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
    }

    @IBAction func mainSwipeLeft(sender: UISwipeGestureRecognizer) {
        if photoList.keepers.count != 1 {
            swipeAndSetPhoto(imgMain, direction: .left)
        }
    }
    
    @IBAction func mainSwipeRight(sender: UISwipeGestureRecognizer) {
        if photoList.keepers.count != 1 {
         swipeAndSetPhoto(imgMain, direction: .right)
        }
    }

    @IBAction func shareButtonAction(sender: AnyObject) {
        shareOptions()
    }
    
    
    //end
}



