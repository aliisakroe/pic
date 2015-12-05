//
//  codeFile.swift
//  pic
//
//  Created by Aliisa Roe on 12/1/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import Foundation
import Photos

class PhotoList {
    var keepers: [ Int : PhotoKey ] = [:]
    var allPhotoList: [ Int : PhotoKey ] = [:]
    var discards: [ Int : PhotoKey ] = [:]
    
    func photoIsInList(photo: PhotoKey, list: [PhotoKey]) -> Bool {
        var found = false
        for eachPhoto in list {
            if photo.index == eachPhoto.index {
                found = true
            } else {
                found = false
            }
        }
        return found
    }
    
    func keepPhoto(photo: PhotoKey, keep: Bool) {
        if keep {
            keepers[photo.index] = photo
            if !photoIsInList(photo, list: Array(self.allPhotoList.values) ) {
                allPhotoList[photo.index] = photo
            }
        } else {
            self.keepers[photo.index] = nil
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


    func getTotalImages(list: String) -> [Int : UIImage] {
        var imageDict = [Int: UIImage]()
        if list == "discards" {
            for i in 0 ..< self.discards.count {
                let photo = Array(self.discards.values)[i].image
                imageDict[i] = photo
            }
        }
        return imageDict
    }
    
    
    //end
}

