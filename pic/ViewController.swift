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


/** to do

- discards select photo and restore to keepers
- resize photos
- app icon
- app loadscreen
- fix orientation
*/







let newKeepersNotification = "Reload the scroll view"

protocol ScrollViewControllerDelegate{
    func scrollViewSelection(controller:ScrollViewController, image: UIImage)
}

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate, ScrollViewControllerDelegate  {
    
    
    var photoList = PhotoList.sharedInstance
    var vc = BSImagePickerViewController()
    var selectedPhotos : [PHAsset] = []
    var previousMainImage : UIImage?
    var swipe = Swipe()
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    let secondPhoto = UIImageView()
    
    @IBOutlet weak var doubleCheckButton: UIButton!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLR: UIImageView!
    @IBOutlet weak var imgLL: UIImageView!

    @IBOutlet var scrollViewController: UIView!
    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var mainSwipeRight: UISwipeGestureRecognizer!
    @IBOutlet weak var mainSwipeLeft: UISwipeGestureRecognizer!
    
    @IBOutlet weak var shareButtonOutlet: UIButton!
    
    
    
    
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
                                                                                                    //might be buggy
                        self.picButton.hidden = true
                        var imageArray = self.swipe.getInitialImages(self.photoList.keepers.count)
                        self.imgMain.image = imageArray[0] as UIImage!
                        self.imgMain.hidden = false
                        
                        // tells the scroll view to reload data
                        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
                    })
                }, completion: nil)
    }
    
    
    
    
    
    // MARK: - functions
    
    
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("landscapefrom vc")
            performSegueWithIdentifier("landscape", sender: self)
        }
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            navigationController?.popViewControllerAnimated(false)
            print("Portrait from vc")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true //dope  //LANDSCAPRE MODE DOESN"T LIKEY
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkMainImage", name: newKeepersNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //from delegate protocol for collection view!!!
    
    func scrollViewSelection(controller: ScrollViewController, image: UIImage) {
        imgMain.image! = image
    }
    
    func checkMainImage(){
        var photoKey = swipe.imageToPhotoKey(imgMain.image!)
    
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
    
    
    // MARK: - Landscape Size Class
    

    
//    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow) -> Int {
//        
//       // if self.view.window?.rootViewController?.presentedViewController is LandscapeViewController {
//       //     return Int(UIInterfaceOrientationMask.All.rawValue);
//       // } else {
//            return Int(UIInterfaceOrientationMask.Portrait.rawValue);
//       // }
//        
//    }
    

    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    //MARK: - Navigation
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "discards" {
            segue.destinationViewController as? DiscardsVC
           // destination!.photoList = self.photoList                   // in favor of the singleton!!!
        }
        if segue.identifier == "scrollCollectionView" {
            var destination = segue.destinationViewController as? ScrollViewController
            destination!.delegate = self
        }
        if segue.identifier == "landscape" {
            var destination = segue.destinationViewController as? LandscapeViewController
           // destination!.delegate = self
        }
    }
    
    
    
    
    // MARK: - Action (Gestures)
    
    
    @IBAction func swipeToCollectionView(sender: UIPanGestureRecognizer) {      //getting called twice?!?!?! must be long press thing
        print("Going to discards collection view")
        performSegueWithIdentifier("discards", sender: sender)
    }
    
    @IBAction func swipeUpMain(sender: AnyObject) {
        if photoList.keepers.count != 1 {
            //doubleCheck(false)
            swipe.swipeUpDelete(imgMain)
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        }
    }

    @IBAction func mainSwipeLeft(sender: UISwipeGestureRecognizer) {
        if photoList.keepers.count != 1 {
            let newImage = swipe.getNextPhoto(imgMain.image!, direction: .left)
            imgMain.image = newImage
        }
    }
    
    @IBAction func mainSwipeRight(sender: UISwipeGestureRecognizer) {
        if photoList.keepers.count != 1 {
        let newImage = swipe.getNextPhoto(imgMain.image!, direction: .right)
        imgMain.image = newImage
        }
    }

    @IBAction func shareButtonAction(sender: AnyObject) {
        shareOptions()
    }
    
    @IBAction func doubleCheckButtonAction(sender: UIButton) {
        swipe.swipeUpDelete(imgMain)
    }
   
    
    //end
}



