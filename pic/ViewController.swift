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
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

/** to do
- app icon
- app loadscreen
- clear BSImagePicker
*/



let newKeepersNotification = "Reload the scroll view"
let lastPhoto = "final steps"
let finalPhoto = "final photo"

protocol ScrollViewControllerDelegate {
    func scrollViewSelection(controller:ScrollViewController, selectedPhotoKey: PhotoKey)
}

protocol DiscardsViewControllerDelegate {
    func restoreImagesToKeepers(photoKeyArray: [PhotoKey])
}

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate, ScrollViewControllerDelegate, DiscardsViewControllerDelegate, FBSDKLoginButtonDelegate {
    
    
    var photoList = PhotoList.sharedInstance
    var selectedPhotos : [PHAsset] = []
    var previousMainImage : UIImage?
    var swipe = Swipe()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    let secondPhoto = UIImageView()
    var currentImgMainPhotoKey : PhotoKey?
    var logInButton = FBSDKLoginButton()
    
    @IBOutlet weak var picAgainButton: UIButton!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet var scrollViewController: UIView!
    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var mainSwipeRight: UISwipeGestureRecognizer!
    @IBOutlet weak var mainSwipeLeft: UISwipeGestureRecognizer!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var swipeUpMain: UISwipeGestureRecognizer!
    
    
    
    
    
    
    
    
    // MARK: - BSImageSelector loads UI most of what viewDidLoad would--look in finish: closure
    
    @IBAction func imagePicker(sender: AnyObject) {

            selectedPhotos = [PHAsset]()
            let _ = BSImagePickerViewController()
            var vc = BSImagePickerViewController()
            
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
                        let firstPhotoKey = Array(self.photoList.keepers.values)[0]
                        self.currentImgMainPhotoKey = firstPhotoKey
                        self.setImg(self.imgMain, asset: firstPhotoKey.asset)
                        self.imgMain.hidden = false
                        self.imgMain.addGestureRecognizer(self.swipeUpMain)
                        
                        // tells the scroll view to reload data
                        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
                    })
                    
                }, completion: nil )
    }
    
    
    
    
    
    
    
    
    // MARK: - functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
//        logInButton.readPermissions = ["public_profile", "email", "user_friends"]
//        logInButton.center = self.view.center
//        logInButton.delegate = self
//        
//        if FBSDKAccessToken.currentAccessToken() == nil {
//            print("Not logged in...")
//            //self.view.addSubview(logInButton)
//        } else {
//            print("Logged in!")
//        }
        
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
    
    
    //called from newKeepers notification to see if main image was deleted in another viewcontroller
    func checkImgMain() {
        if let currentPhotoKey = self.currentImgMainPhotoKey {
        if swipe.photoIsIn(currentPhotoKey) == .discards {
            let index = photoList.sortedListOfPhotoIndices(.keepers).last!
            let photoKey =  photoList.keepers[index]
            setImg(imgMain, asset: photoKey!.asset)
        }
        } else {
            imgMain.hidden = true
        }
    }
    
    
    

    //from scrollViewDelegate to set selected photo
    func scrollViewSelection(controller: ScrollViewController, selectedPhotoKey: PhotoKey) {
        self.setImg(imgMain, asset: selectedPhotoKey.asset)
    }
    
    
    //from discards delegate to undo selected deleted photos
    func restoreImagesToKeepers(photoKeyArray: [PhotoKey]){
        for thePhotoKey in photoKeyArray{
            photoList.keepPhoto(thePhotoKey, list: .keepers)
            NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
            self.scrollViewController.hidden = false
            self.picAgainButton.hidden = true
            shareButtonOutlet.hidden = true
            imgMain.addGestureRecognizer(swipeUpMain)
        }
    }
    
    
    //called from lastPhoto notification, adds share button and removes collection view
    func lastPhotoView() {
        picAgainButton.hidden = false
        self.scrollViewController.hidden = true
        self.shareButtonOutlet.hidden = false
        let index = photoList.sortedListOfPhotoIndices(.keepers)[0]
        let lastPhotoKey = photoList.keepers[index]
        setImg(imgMain, asset: lastPhotoKey!.asset) //sets first here
        imgMain.removeGestureRecognizer(swipeUpMain)

    }
    
    
    //MARK: - Facebook Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error ==  nil {
            print("Login complete.")
             self.logInButton.hidden = true
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }
    
    
    
    
    //MARK: - SOCIAL FRAMEWORK actionSheet
    

    
    func share(){
        
        PHImageManager.defaultManager().requestImageDataForAsset(currentImgMainPhotoKey!.asset, options: PHImageRequestOptions(), resultHandler:
            {
                (imagedata, dataUTI, orientation, info) in
                if info!.keys.contains(NSString(string: "PHImageFileURLKey")){
                    
                    let someText:String =  "Check out my photo!"
                    let pathURL = info![NSString(string: "PHImageFileURLKey")] as! NSURL
                    print(pathURL)
                    let activityViewController = UIActivityViewController(
                        activityItems: [someText, pathURL],
                        applicationActivities: nil)
                    self.navigationController?.presentViewController(activityViewController,
                        animated: true,
                        completion: nil)
                }
        })
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
            destination?.leftPhotoKey = currentImgMainPhotoKey!
        }
    }
    
    
    
    
    // MARK: - Action (Gestures)
    
    
    @IBAction func swipeToCollectionView(gesture: UIPanGestureRecognizer) {
        if (gesture.state != .Ended){                                                           //HACK!!
            return
        }
        performSegueWithIdentifier("discards", sender: gesture)
    }
    
    func getImg(photoKey: PhotoKey) -> UIImage? {
        let manager = PHImageManager.defaultManager()
        manager.requestImageForAsset(photoKey.asset,
            targetSize: CGSizeMake(4000.0, 4000.0),
            contentMode: .AspectFill ,
            options: nil) { (result, _) in
                return result!
        }
        return nil
    }
    
    
    func setImg(imageView: UIImageView, asset: PHAsset) {
        let manager = PHImageManager.defaultManager()
        manager.requestImageForAsset(asset,
            targetSize: CGSizeMake(4000.0, 4000.0),
            contentMode: .AspectFill ,
            options: nil) { (result, _) in
                let imageForPhoto = result!
                imageView.image = imageForPhoto
        }
        if imageView == imgMain {
            self.currentImgMainPhotoKey = swipe.findPhotoKeyForAsset(asset)
        }
    }
    
    func swipeAndSetPhoto(imageView: UIImageView, direction: Swipe.direction) {
        let nextPhotoKey = swipe.getNextPhotoKey(self.currentImgMainPhotoKey!, direction: direction)
        setImg(imageView, asset: nextPhotoKey.asset)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBAction func swipeUpMain(sender: AnyObject) {
        swipe.swipeUpDelete(imgMain, currentPhotoKey: self.currentImgMainPhotoKey!)
        if photoList.keepers.count == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(lastPhoto, object: self)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        }
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
        share()
    }
    
    @IBAction func picAgainButton(sender: AnyObject) {
        self.photoList.clearPhotos()
        currentImgMainPhotoKey = nil
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        picButton.hidden = false
        self.scrollViewController.hidden = false
        picAgainButton.hidden = true
    }
    
    //end
}



