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
//import PhotoSlider                                                                                            "cannot load underlying module for PhotoSlider"?
//import SLPagingViewSwift

class ViewController: UIViewController {
    
    var vc = BSImagePickerViewController()
    var selectedPhotos : [PHAsset] = []
    let manager = PHImageManager.defaultManager()
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgLR: UIImageView!
    @IBOutlet weak var imgLL: UIImageView!
    var imgMainPhoto : UIImage!
    var imgLLPhoto : UIImage!
    var imgLRPhoto : UIImage!
    var photosToChoose : [UIImage] = []
    
    @IBAction func imagePicker(sender: AnyObject) {
            selectedPhotos = [PHAsset]()
            let _ = BSImagePickerViewController()
            
            bs_presentImagePickerController(vc, animated: true,
                select: { (asset: PHAsset) -> Void in
                    self.selectedPhotos.append(asset)
                }, deselect: { (asset: PHAsset) -> Void in
                    //self.selectedPhotos.remove(asset)                         //not removing deselected photos from list
                }, cancel: { (assets: [PHAsset]) -> Void in
                }, finish: { (assets: [PHAsset]) -> Void in
                    var imageArray = self.getInitialImages(3)
                    self.imgMainPhoto = imageArray[0] as UIImage
                    self.imgLLPhoto = imageArray[1] as UIImage
                    self.imgLRPhoto =  imageArray[2] as UIImage
                    
                    self.imgMain.hidden = false
                    self.imgLR.hidden = false
                    self.imgLL.hidden = false
                }, completion: nil)
    }

//viewController
    let albumName = "Pic"
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    //var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // check if folder exists, if not, create it
       /* let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@" , albumName)
        
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{
            self.albumFound = true
              self.assetCollection = first_Obj as! PHAssetCollection
        } else {
            var albumPlaceholder:PHObjectPlaceholder!
        //create the folder
        NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName)
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(self.albumName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
            },
                completionHandler: {(success:Bool, error:NSError?)in
                    if(success){
                        print("Successfully created folder")
                        self.albumFound = true
                        let collection = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([albumPlaceholder.localIdentifier], options: nil)
                        self.assetCollection = collection.firstObject as! PHAssetCollection
                    }else{
                        print("Error creating folder")
                        self.albumFound = false
                }
        })
    }*/
    }
    
    override func viewWillAppear(animated: Bool) {
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getInitialImages(numberOfImages: Int) -> [UIImage] {
        var imageArray = [UIImage]()
       for i in 0..<numberOfImages {
            let photo = selectedPhotos[i] as PHAsset
            manager.requestImageForAsset(photo,
                targetSize: CGSize(width: 300.0, height: 300.0),
                contentMode: .AspectFill,
                options: nil) { (result, _) in
                    imageArray.append(result!)
        }
        }
        return imageArray
    }
    
    
    func getTotalImages() -> [UIImage] {
        var imageArray = [UIImage]()
        for i in 0..<selectedPhotos.count {
            let photo = selectedPhotos[i] as PHAsset
            manager.requestImageForAsset(photo,
                targetSize: CGSize(width: 300.0, height: 300.0),
                contentMode: .AspectFill,
                options: nil) { (result, _) in
                    imageArray.append(result!)
            }
        }
        print("This is SELCETED PHOTOS: \(selectedPhotos.count)")
        print("This is IMAGEARRAY: \(imageArray.count)")
        return imageArray
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TwoView" {
            let destination : TwoVC = segue.destinationViewController as! TwoVC
            var imageArray = getInitialImages(3)
            destination.imgMainPhoto = imageArray[0] as UIImage
            destination.imgLLPhoto = imageArray[1] as UIImage
            destination.imgLRPhoto = imageArray[2] as UIImage
            let totalImageArray = getTotalImages()
            destination.photosToChoose = totalImageArqray
        }
    }*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

