 //
//  swipes.swift
//  pic
//
//  Created by Aliisa Roe on 12/6/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import Foundation
import UIKit
import Photos

    var photoList = PhotoList.sharedInstance

class Swipe {
    
    enum direction {
        case right
        case left
    }
    
    func swipeUpDelete(imageView: UIImageView, currentPhotoKey: PhotoKey) -> PhotoKey {
        var nextPhotoKey : PhotoKey? = nil
        if photoList.keepers.count == 2 {
            nextPhotoKey = currentPhotoKey
        } else {
            nextPhotoKey = getNextPhotoKey(currentPhotoKey, direction: .right)
        }
        photoList.keepPhoto(currentPhotoKey, list: .discards)
        return nextPhotoKey!
    }
    
    func getNextPhotoKey(currentPhotoKey: PhotoKey, direction: Swipe.direction) -> PhotoKey {
        var nextIndex : Int?
        let sortedKeepers = photoList.sortedListOfPhotoIndices(.keepers)
            for i in 0 ..< sortedKeepers.count  {
                if sortedKeepers[i] == currentPhotoKey.index {
                    if direction == .left {
                        nextIndex = i - 1
                    } else {
                        nextIndex = i + 1
                    }
                    if nextIndex > sortedKeepers.count - 1 {
                        nextIndex = 0
                    } else if nextIndex < 0 {
                        nextIndex = sortedKeepers.count - 1
                    }
                }
        }
        let realNextIndex = sortedKeepers[nextIndex!]
        let nextPhotoKey = photoList.keepers[realNextIndex]!
        return nextPhotoKey
    }

    func isSameAsset(asset1: PHAsset, asset2: PHAsset) -> Bool {
        var isSame = false
        if asset1.isEqual(asset2) {
            isSame = true
        }
        return isSame
    }
    
    func isSamePhoto(img1: UIImage, img2: UIImage) -> Bool {
        var isSame = false
        if UIImagePNGRepresentation(img1)!.isEqual(UIImagePNGRepresentation(img2)!) {
            isSame = true
        }
        print(isSame)
        return isSame
    }
    
    func differentPhoto(nextPhotoKey: PhotoKey, otherPhotoKey: PhotoKey, direction: Swipe.direction) -> PhotoKey? {
        if photoList.keepers.count != 1 {
        if isSameAsset(nextPhotoKey.asset, asset2: otherPhotoKey.asset) {
            return getNextPhotoKey(nextPhotoKey, direction: direction)
        } else {
            return nextPhotoKey
        }
        } else {
            return nil
        }
    }
    
    func imageToAsset(img: UIImage) -> PHAsset {
        print("Image to asset")
        let thePhotoKey = imageToPhotoKey(img)
        return thePhotoKey.asset
    }
    
    func findPhotoKeyForAsset(asset: PHAsset ) -> PhotoKey? {
        var thePhotoKey : PhotoKey?
        var found = false
        for photo in photoList.keepers.values {
            if isSameAsset(asset, asset2: photo.asset){
                thePhotoKey = photo
                found = true
            }
        }
        if !found { //if photo not in keepers will look if the key exists at all yet
            for photo in photoList.allPhotoList.values {
                if isSameAsset(asset, asset2: photo.asset) {
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
    
    func makePhotoKeyFromPHAsset(asset: PHAsset) -> PhotoKey {
        let indexForPhoto = photoList.keepers.count + 1
        let photo = PhotoKey(index: indexForPhoto, asset: asset)
        return photo
    }
    
    func imageToPhotoKey(image: UIImage) -> PhotoKey {
        var thePhotoKey : PhotoKey?
        for photo in photoList.allPhotoList.values {
            let manager = PHImageManager.defaultManager()
            let asset = photo.asset
            manager.requestImageForAsset(asset,
            targetSize: CGSizeMake(4000, 4000),
            contentMode: .AspectFill ,
            options: nil) { (result, _) in
                let imageForPhoto = result!
                if self.isSamePhoto(image, img2: imageForPhoto) {
                    thePhotoKey = photo
                }
            }
        }
        return thePhotoKey!
    }
    
    func photoIsIn(photoKeyToCheck: PhotoKey) -> PhotoList.list? {
        var list: PhotoList.list?
        for eachPhotoKey in photoList.keepers.values {
            if isSameAsset(photoKeyToCheck.asset, asset2: eachPhotoKey.asset) {
                list = .keepers
            }
        }
        for eachPhotoKey in photoList.discards.values {
            if isSameAsset(photoKeyToCheck.asset, asset2: eachPhotoKey.asset) {
                list = .discards
            }
        }
        return list
    }

    //end
}