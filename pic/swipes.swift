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
    
    func swipeUpDelete(imageView: UIImageView) {
        let currentPhotoKey = imageToPhotoKey(imageView.image!)
        if photoList.keepers.count > 2 {
            let currentImage = imageView.image!
            let newImage = getNextPhoto(currentImage, direction: .right)
            imageView.image = newImage
        }
        photoList.keepPhoto(currentPhotoKey, list: .discards)
        photoList.discards[currentPhotoKey.index] = currentPhotoKey
    }
    
    func getNextPhoto(currentPhoto: UIImage, direction: Swipe.direction) -> UIImage {
        var nextImage = UIImage()
        var nextIndex : Int
        let sortedKeepers = photoList.getTotalImages(.keepers)
        if sortedKeepers.count > 1 {
            for i in 0 ..< sortedKeepers.count  {
                if isSamePhoto(sortedKeepers[i]!, img2: currentPhoto) {
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
                    nextImage = sortedKeepers[nextIndex]!
                }
            }
        }
        return nextImage
    }

    func isSamePhoto(img1: UIImage, img2: UIImage) -> Bool {
        var isSame = false
        if (UIImagePNGRepresentation(img1)!.isEqual(UIImagePNGRepresentation(img2)!)) {
            isSame = true
        }
        return isSame
    }
    
    func differentPhoto(potentialImage: UIImage, imageView2: UIImageView, direction: Swipe.direction) -> UIImage {
        var differentImage = UIImage()
        if isSamePhoto(potentialImage, img2: imageView2.image!) {
            differentImage = getNextPhoto(potentialImage, direction: direction)
        } else {
            differentImage = potentialImage
        }
        return differentImage
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
        for photo in photoList.keepers.values {
            if (UIImagePNGRepresentation(photo.image)!.isEqual(dataToSearch)) {
                thePhotoKey = photo
                found = true
            }
        }
        if !found { //if photo not in keepers will look if the key exists at all yet
            for photo in photoList.allPhotoList.values {
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
    
    func imageToPhotoKey(image: UIImage) -> PhotoKey {
        var thePhotoKey : PhotoKey?
        for photo in photoList.allPhotoList.values {
            if isSamePhoto(photo.image, img2: image) {
                thePhotoKey = photo
            }
        }
        return thePhotoKey!
    }
    
    func photoIsIn(image: UIImage) -> PhotoList.list? {
        var list: PhotoList.list?
        var photoKey = imageToPhotoKey(image)
        for eachPhotoKey in photoList.keepers.values {
            if isSamePhoto(image, img2: eachPhotoKey.image) {
                list = .keepers
            }
        }
        for eachPhotoKey in photoList.discards.values {
            if isSamePhoto(image, img2: eachPhotoKey.image) {
                list = .discards
            }
        }
        return list
    }
    
    func getInitialImages(numberSelected : Int) -> [UIImage] {
        var imageArray = [UIImage]()
        var numPhotos : Int
        if numberSelected > 3 {
            numPhotos = 3
        } else {
            numPhotos = numberSelected
        }
        for i in 0 ... numPhotos - 1 {
            let photo = Array(photoList.keepers.values)[i]
            imageArray.append(photo.image)
        }
        return imageArray
    }

    
}