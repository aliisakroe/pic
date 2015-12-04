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

class MainCompare: UIViewController, UIDocumentInteractionControllerDelegate  {
    
    var instaController = UIDocumentInteractionController()
    
    var photoList = PhotoList()
    var vc = BSImagePickerViewController()
    var selectedPhotos : [PHAsset] = []
    let manager = PHImageManager.defaultManager()
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLR: UIImageView!
    @IBOutlet weak var imgLL: UIImageView!
    
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
                        let newPhotoKey = self.PHAssetToPhotoKey(asset)
                        self.photoList.keepPhoto(newPhotoKey, keep: true)
                    }
                }, deselect: { (asset: PHAsset) -> Void in
                    var photoKeyForAsset = self.findPhotoKeyForAsset(asset)!
                    print(photoKeyForAsset)
                    self.photoList.keepPhoto(photoKeyForAsset, keep: false)
                }, cancel: { (assets: [PHAsset]) -> Void in
                }, finish: { (assets: [PHAsset]) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        //how to make go only if 3 are selected?
                        
                        var imageArray = self.getInitialImages()
                        self.imgMain.image = imageArray[0] as UIImage!
                        self.imgLL.image = imageArray[1] as UIImage!
                        self.imgLR.image =  imageArray[2] as UIImage!
                        self.imgMain.hidden = false
                        self.imgLR.hidden = false
                        self.imgLL.hidden = false
                    })
                }, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*
        var instagramURL = NSURL(string: "instagram://app")
        if UIApplication.sharedApplication().canOpenURL(instagramURL!) {
            // Success
            var img = imageView.image
            
            var savePath: String = NSHomeDirectory().stringByAppendingPathComponent("Documents/Test.igo")
            UIImageJPEGRepresentation(img, 1).writeToFile(savePath, atomically: true)
            var imgURL = NSURL(string: NSString(format: "file://%@", savePath) as! String)
            
            docController = UIDocumentInteractionController(URL: imgURL!) // 1
            docController.UTI = "com.instagram.exclusivegram" // 2
            docController.delegate = self
            docController.annotation = ["InstagramCaption":"\(myTextField.text) \(myTextField2text)"] // 3
            docController.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true) // 4
        } else {
            // Error
        } */
    }
    
    override func viewWillAppear(animated: Bool) {
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isSamePhoto(img1: UIImage, img2: UIImage) -> Bool {
        var isSame = false
        if (UIImagePNGRepresentation(img1)!.isEqual(UIImagePNGRepresentation(img2)!)) {
            isSame = true
        }
        return isSame
    }
    
    func getPhotoKeyForImage(image: UIImage) -> PhotoKey {
        var thePhotoKey : PhotoKey?
        let dataToSearch = UIImagePNGRepresentation(image)!
        for photo in self.photoList.allPhotoList.values {
            if isSamePhoto(photo.image, img2: image) {
            //if (UIImagePNGRepresentation(photo.image)!.isEqual(dataToSearch)) {
                thePhotoKey = photo
            }
        }
        return thePhotoKey!
    }
    
    func anySamePhoto(imgToCheck: UIImage, img2: UIImage, img3: UIImage) -> Bool {
        var isSame  = false
        var photoKeyVariable = getPhotoKeyForImage(imgToCheck)
        var photoKey2 = getPhotoKeyForImage(img2)
        var photoKey3 = getPhotoKeyForImage(img3)
        
        if (photoKeyVariable.index == photoKey2.index) || (photoKeyVariable.index == photoKey3.index) {
            isSame = true
        }
        return isSame
    }
    
    func getNextPhoto(currentPhoto: UIImage, backward: Bool = false) -> UIImage? {
        var nextImage = UIImage()
        var nextIndex : Int
        let sortedKeepers = self.photoList.sortedListOfPhotoIndices(true)
        var thePhotoKey = getPhotoKeyForImage(currentPhoto)
        
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
                        var nextPhotoKey = self.photoList.keepers[index]
                        nextImage = (nextPhotoKey?.image)!
                    }
                }
            }
        }
        return nextImage
    }
    
    func getInitialImages() -> [UIImage] {
        var imageArray = [UIImage]()
       for i in 0 ... 2 {
            let photo = Array(self.photoList.keepers.values)[i]
            imageArray.append(photo.image)
        }
        return imageArray
    }
    
    
    func PHAssetToPhotoKey(asset: PHAsset) -> PhotoKey {
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
    
    func doubleCheck() {
        // when swipe up to delete, fuzz out and tap to really delete
        // if tap then swipeUpToDelete
    }
    
    func swipeUpDelete(image: UIImageView) {
        let currentPhotoKey = getPhotoKeyForImage(image.image!)
        print(photoList.keepers.count)
        if photoList.keepers.count > 3 {
            let newImage = changePhoto(image)
            image.image = newImage
        }
        self.photoList.keepPhoto(currentPhotoKey, keep: false)
        self.photoList.discards[currentPhotoKey.index] = currentPhotoKey
        if photoList.keepers.count == 2 {
            print("UO OH")
            if image == imgMain {
                imgMain.image = imgLR.image
                imgLR.hidden = true
                imgLR.image = nil
            } else {
                image.hidden = true
                image.image = nil
            }
        } else if photoList.keepers.count == 1 {
            //perform segue to share
            print("NOW WHAT")
            imgLL.hidden = true
            if image == imgMain {
                imgMain.image = imgLL.image
                imgLL.image = nil
            }
            //share buttons . hidden = false
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "discards" {
            let destination = segue.destinationViewController as? DiscardsVC
           // destination!.delegate = self
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    
    
    
    // MARK: - Action (Gestures)
    
    
    
    @IBAction func tapLL(sender: AnyObject) {
        imgMain.image = imgLL.image
        // load next image instead put main to back of list
    }
    
    @IBAction func tapLR(sender: AnyObject) {
        imgMain.image = imgLR.image
        //  imgLR.image = getNextPhoto(imgLR.image!)
        // load next image instead put main to back of list
    }
    
    @IBAction func landscapeLLSwipe(sender: AnyObject) {
        let newImage = changePhoto(imgLL)
        imgLL.image = newImage
    }
    
    @IBAction func swipeToCollectionView(sender: UIGestureRecognizer) {
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
        
        // get last image
    }
    
    @IBAction func mainSwipeRight(sender: UISwipeGestureRecognizer) {
        let newImage = changePhoto(imgMain)
        imgMain.image = newImage
    }
    
    // i would like to have a scrolling bottom view...
}



