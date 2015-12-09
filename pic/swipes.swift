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
    
    func swipeUpDelete(imageView: UIImageView) -> PhotoKey {
        let currentPhotoKey = imageToPhotoKey(imageView.image!)
        let nextPhotoKey = getNextPhotoKey(currentPhotoKey, direction: .right)
        photoList.keepPhoto(currentPhotoKey, list: .discards)
        photoList.discards[currentPhotoKey.index] = currentPhotoKey
        return nextPhotoKey
    }
    
    func getNextPhotoKey(currentPhotoKey: PhotoKey, direction: Swipe.direction) -> PhotoKey {
        var nextIndex = 0
        let sortedKeepers = photoList.sortedListOfPhotoIndices(.keepers)
        if sortedKeepers.count > 1 {
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
        }
        return photoList.keepers[nextIndex]!
    }

    func isSameAsset(asset1: PHAsset, asset2: PHAsset) -> Bool {
        var isSame = false
        if asset1.isEqual(asset2) {
            isSame = true
        }
        return isSame
    }
    
    func imageToAsset(img: UIImage) -> PHAsset {
        let thePhotoKey = imageToPhotoKey(img)
        return thePhotoKey.asset
    }
    
    
    func differentPhoto(nextPhotoKey: PhotoKey, imageView2: UIImageView, direction: Swipe.direction) -> PhotoKey {
        let otherViewAsset = imageToPhotoKey(imageView2.image!)
        if isSameAsset(nextPhotoKey.asset, asset2: otherViewAsset.asset) {
           return getNextPhotoKey(nextPhotoKey, direction: direction)
        } else {
            return nextPhotoKey
        }
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
        let photo = PhotoKey(index: indexForPhoto, image: nil, asset: asset)
        return photo
    }
    
//    func imageToPhotoKey(image: UIImage) -> PhotoKey {
//        var thePhotoKey : PhotoKey?
//        print(photoList.allPhotoList.count)
//        for photo in photoList.allPhotoList.values {
//            if isSameAsset(photo.asset, asset2: imageToAsset(image)) {
//                thePhotoKey = photo
//            }
//        }
//        return thePhotoKey!
//    }
    
    func photoIsIn(image: UIImage) -> PhotoList.list? {
        var list: PhotoList.list?
        for eachPhotoKey in photoList.keepers.values {
            if isSameAsset(imageToAsset(image), asset2: eachPhotoKey.asset) {
                list = .keepers
            }
        }
        for eachPhotoKey in photoList.discards.values {
            if isSameAsset(imageToAsset(image), asset2: eachPhotoKey.asset) {
                list = .discards
            }
        }
        return list
    }

    //end
}