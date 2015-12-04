//
//  testFuncs.swift
//  pic
//
//  Created by Aliisa Roe on 12/2/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import Foundation
import PhotosUI


/*func keepPhoto(photo: PhotoKey, keep: Bool) {
    if keep {
        if !photoIsInList(photo, list: Array(self.keepers.values) ) {
            keepers[photo.index!] = photo
        }
    } else {
        self.keepers[photo.index!] = nil
        discards[photo.index!] = photo
    }
}

func sortedListOfPhotoIndices(keep: Bool) -> [Int] {
    var sortedIndices = [Int]()
    if keep {
        sortedIndices = keepers.keys.sort()
    } else {
        sortedIndices = discards.keys.sort()
    }
    return sortedIndices
}


func PHAssetToPhotoKey(asset: PHAsset) -> PhotoKey {
    var photo = PhotoKey()
    let manager = PHImageManager.defaultManager()
    manager.requestImageForAsset(asset,
        targetSize: CGSize(width: 300.0, height: 300.0),
        contentMode: .AspectFill,
        options: nil) { (result, _) in
            photo.image = result
    }
    photo.index = photoList.keepers.count + 1
    manager.requestImageDataForAsset(asset, options: nil, resultHandler: { imageData,dataUTI,orientation,info in
        photo.data = imageData!
    })
    print(photo.index!)
    print(photo.image!)
    return photo
}

func findPhotoKeyForAsset(asset: PHAsset ) -> PhotoKey {
    var thePhotoKey = PhotoKey()
    var imageToSearch = NSData()
    var image = UIImage()
    let manager = PHImageManager.defaultManager()
    manager.requestImageForAsset(asset,
        targetSize: CGSize(width: 300.0, height: 300.0),
        contentMode: .AspectFill,
        options: nil) { (result, _) in
            image = result!
    }
    imageToSearch = UIImagePNGRepresentation(image)!
    print("image to search \(imageToSearch)")
    for photo in self.photoList.keepers.values {
        print("photo Image \(photo.image!)")
        print(UIImagePNGRepresentation(photo.image!)!.isEqual(imageToSearch))
        if (photo.data!.isEqual(imageToSearch)) {
            thePhotoKey = photo
}
*/
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

//viewController
/*let albumName = "Pic"
var albumFound : Bool = false
var assetCollection: PHAssetCollection = PHAssetCollection()
//var photosAsset: PHFetchResult!
var assetThumbnailSize:CGSize! */

/* func addEffect(imagePosition: String){
let effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
let effectView = UIVisualEffectView(effect: effect)
if imagePosition == "LL" {
effectView.frame = imgLL.frame //layout error
}
else if imagePosition == "LR" {
effectView.frame = imgLR.frame //layout error
}
view.addSubview(view)
}*/