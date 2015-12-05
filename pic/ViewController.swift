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

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate  {
    
    
    
    
    var photoList = PhotoList()
    var vc = BSImagePickerViewController()
    var selectedPhotos : [PHAsset] = []
   // let manager = PHImageManager.defaultManager()
    var previousMainImage : UIImage?
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLR: UIImageView!
    @IBOutlet weak var imgLL: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var picButton: UIButton!
    
    
    
    
    
    
    // MARK: - BSImageSelector updates most of what viewDidLoad would
    
    @IBAction func imagePicker(sender: AnyObject) {
            selectedPhotos = [PHAsset]()
            let _ = BSImagePickerViewController()
            
            bs_presentImagePickerController(vc, animated: true,
                select: { (asset: PHAsset) -> Void in
                //if findPhotoKey finds key, knows created and reselected
                if let reselectedPhotoKey = self.findPhotoKeyForAsset(asset) {
                        self.photoList.keepPhoto(reselectedPhotoKey, keep: true)
                    }
                //if findPhotoKey doesn't find key creates a new one
                else {
                        let newPhotoKey = self.makePhotoKeyFromPHAsset(asset)
                        self.photoList.keepPhoto(newPhotoKey, keep: true)
                    }
                }, deselect: { (asset: PHAsset) -> Void in
                    let photoKeyForAsset = self.findPhotoKeyForAsset(asset)!
                    self.photoList.keepPhoto(photoKeyForAsset, keep: false)
                }, cancel: { (assets: [PHAsset]) -> Void in
                }, finish: { (assets: [PHAsset]) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                                                                    //might be buggy
                        self.picButton.hidden = true
                        var imageArray = self.getInitialImages(self.photoList.keepers.count)
                        if imageArray.count == 1 {
                            self.imgMain.image = imageArray[0] as UIImage!
                            self.imgMain.hidden = false
                        } else if imageArray.count == 2 {
                            self.imgLR.image = imageArray[0] as UIImage!
                            self.imgLL.image = imageArray[1] as UIImage!
                            self.imgLR.hidden = false
                            self.imgLL.hidden = false
                        } else {
                            self.imgMain.image = imageArray[0] as UIImage!
                            self.imgLL.image = imageArray[1] as UIImage!
                            self.imgLR.image =  imageArray[2] as UIImage!
                            self.imgMain.hidden = false
                            self.imgLR.hidden = false
                            self.imgLL.hidden = false
                        }
                    })
                }, completion: nil)
    }
    
    
    
    
    
    // MARK: - functions
    
    //do i really need these?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // called from BSImagePicker
    func getInitialImages(numberSelected : Int) -> [UIImage] {
        var imageArray = [UIImage]()
        var numPhotos : Int
        if numberSelected > 3 {
            numPhotos = 3
        } else {
            numPhotos = numberSelected
        }
        for i in 0 ... numPhotos - 1 {
            let photo = Array(self.photoList.keepers.values)[i]
            imageArray.append(photo.image)
        }
        return imageArray
    }
    
    
    
    func imageToPhotoKey(image: UIImage) -> PhotoKey {
        var thePhotoKey : PhotoKey?
        for photo in self.photoList.allPhotoList.values {
            if isSamePhoto(photo.image, img2: image) {
                thePhotoKey = photo
            }
        }
        return thePhotoKey!
    }
    
    
    
    func makePhotoKeyFromPHAsset(asset: PHAsset) -> PhotoKey {
        var imageForPhoto = UIImage()
        let indexForPhoto = photoList.keepers.count + 1
        let manager = PHImageManager.defaultManager()
        manager.requestImageForAsset(asset,
            targetSize: CGSize(width: 300.0, height: 300.0),
            contentMode: .AspectFill,
            options: nil) { (result, _) in
                imageForPhoto = result!
        }
        let photo = PhotoKey(index: indexForPhoto, image: imageForPhoto)
        return photo
    }
    
    
    
    func findPhotoKeyForAsset(asset: PHAsset ) -> PhotoKey? {
        var thePhotoKey : PhotoKey?
        var dataToSearch = NSData()
        let manager = PHImageManager.defaultManager()
        var found = false
        manager.requestImageForAsset(asset,
            targetSize: CGSize(width: 300.0, height: 300.0),
            contentMode: .AspectFill,
            options: nil) { (result, _) in
                dataToSearch = UIImagePNGRepresentation(result!)! //REMEMBER THAT SOME PHOTO TYPES RETURN nil ?!
        }
        for photo in self.photoList.keepers.values {
            if (UIImagePNGRepresentation(photo.image)!.isEqual(dataToSearch)) {
                thePhotoKey = photo
                found = true
            }
        }
        if !found { //if photo not in keepers will look if the key exists at all yet
            for photo in self.photoList.allPhotoList.values {
                if (UIImagePNGRepresentation(photo.image)!.isEqual(dataToSearch)) {
                    thePhotoKey = photo
                }
            }
        }
        if thePhotoKey != nil {
            return thePhotoKey
        } else {
            return nil
        }
    }
    
    
    
    func isSamePhoto(img1: UIImage, img2: UIImage) -> Bool {
        var isSame = false
        if (UIImagePNGRepresentation(img1)!.isEqual(UIImagePNGRepresentation(img2)!)) {
            isSame = true
        }
        return isSame
    }
    
    
    
    func anySamePhoto(imgToCheck: UIImage, img2: UIImage, img3: UIImage) -> Bool {
        var isSame  = false
        let photoKeyVariable = imageToPhotoKey(imgToCheck)
        let photoKey2 = imageToPhotoKey(img2)
        let photoKey3 = imageToPhotoKey(img3)
        if (photoKeyVariable.index == photoKey2.index) || (photoKeyVariable.index == photoKey3.index) {
            isSame = true
        }
        return isSame
    }
    

    func changePhoto(image: UIImageView, backward: Bool = false) -> UIImage {
        var newImage = getNextPhoto(image.image!, backward: backward)!
        if image == imgMain {
            while anySamePhoto(newImage, img2: imgLL.image!, img3: imgLR.image!) { //need to make variables...
                newImage = getNextPhoto(newImage, backward: backward)!
            }
        } else if image == imgLL {
                while anySamePhoto(newImage, img2: imgMain.image!, img3: imgLR.image!) { //need to make variables...
                    newImage = getNextPhoto(newImage, backward: backward)!
            }
        } else if image == imgLR {
            while anySamePhoto(newImage, img2: imgMain.image!, img3: imgLL.image!) { //need to make variables...
                newImage = getNextPhoto(newImage, backward: backward)!
            }
        }
        return newImage
    }
    
    
    
    func getNextPhoto(currentPhoto: UIImage, backward: Bool = false) -> UIImage? {
        var nextImage = UIImage()
        var nextIndex : Int
        let sortedKeepers = self.photoList.sortedListOfPhotoIndices(true)
        let thePhotoKey = imageToPhotoKey(currentPhoto)
        
        for i in 0 ..< sortedKeepers.count {
            if sortedKeepers[i] == thePhotoKey.index {
                if backward {
                    nextIndex = i - 1
                } else {
                    nextIndex = i + 1
                }
                if nextIndex > sortedKeepers.count - 1 {
                    nextIndex = 0
                } else if nextIndex < 0 {
                    nextIndex = sortedKeepers.count - 1
                }
                nextIndex = sortedKeepers[nextIndex]
                for index in self.photoList.keepers.keys {
                    if nextIndex == index {
                        let nextPhotoKey = self.photoList.keepers[index]
                        nextImage = (nextPhotoKey?.image)!
                    }
                }
            }
        }
        return nextImage
    }
    
    
    
    func doubleCheck() {
        // when swipe up to delete, fuzz out and tap to really delete
        // if tap then swipeUpToDelete
    }
    
    
    
    func swipeUpDelete(image: UIImageView) {
        let currentPhotoKey = imageToPhotoKey(image.image!)
        if photoList.keepers.count > 3 {
            let newImage = changePhoto(image)
            image.image = newImage
        }
        self.photoList.keepPhoto(currentPhotoKey, keep: false)
        self.photoList.discards[currentPhotoKey.index] = currentPhotoKey
        
        //resize images if less than the three images
        
        if photoList.keepers.count == 2 {
            if image == imgMain {
                imgMain.image = imgLR.image
                imgLR.hidden = true
                imgLR.image = nil
            } else {
                image.hidden = true
                image.image = nil
            }
        } else if photoList.keepers.count == 1 {
            
            //final photo now share functionality
            
            imgLL.hidden = true
            imgLR.hidden = true
            shareButton.hidden = false
            if image == imgMain {
                imgMain.image = imgLL.image
                imgLL.image = nil
            }
        }
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
            destination!.photoList = self.photoList
           // destination!.delegate = self
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    
    
    
    // MARK: - Action (Gestures)
    
    
    
    @IBAction func tapLL(sender: AnyObject) {
        if isSamePhoto(imgMain.image!, img2: imgLL.image!) {
            imgMain.image = self.previousMainImage!
        } else {
            self.previousMainImage = imgMain.image!
            imgMain.image = imgLL.image!
            
        }
    }
    
    @IBAction func tapLR(sender: AnyObject) {
        if imgMain.image != nil {
            if isSamePhoto(imgMain.image!, img2: imgLR.image!) {
                if previousMainImage != nil {
                    imgMain.image = self.previousMainImage!
                }
            }else {
                self.previousMainImage = imgMain.image!
            }
        } //BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY BUGGY 
            imgMain.image = imgLR.image!
            imgMain.hidden = false
    }
    
    @IBAction func landscapeLLSwipe(sender: AnyObject) {
        let newImage = changePhoto(imgLL)
        imgLL.image = newImage
    }
    
    @IBAction func swipeToCollectionView(sender: UIPanGestureRecognizer) {      //getting called twice?!?!?! must be long press thing
        print("Going to discards collection view")
        performSegueWithIdentifier("discards", sender: sender)
    }
    
    @IBAction func landscapeLRSwipe(sender: AnyObject) {
        let newImage = changePhoto(imgLR)
        imgLR.image = newImage
    }
    
    //ONLY IN LANDSCAPE, what about imgMain access??
    @IBAction func swipeUpLL(sender: AnyObject) {
        swipeUpDelete(imgLL)
    }
    
    //ONLY IN LANDSCAPE, what about imgMain access??
    @IBAction func swipeUpLR(sender: AnyObject) {
        swipeUpDelete(imgLR)
    }
    
    @IBAction func swipeUpMain(sender: AnyObject) {
        swipeUpDelete(imgMain)
    }

    @IBAction func mainSwipeLeft(sender: UISwipeGestureRecognizer) {
        let newImage = changePhoto(imgMain, backward: true)
        imgMain.image = newImage
    }
    
    @IBAction func mainSwipeRight(sender: UISwipeGestureRecognizer) {
        let newImage = changePhoto(imgMain)
        imgMain.image = newImage
    }
    @IBAction func shareButton(sender: AnyObject) {
        shareOptions()
    }
    
}



