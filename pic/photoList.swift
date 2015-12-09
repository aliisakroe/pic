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
    
    static let sharedInstance = PhotoList()
    private init() {}
    
    var keepers: [ Int : PhotoKey ] = [:]
    var allPhotoList: [ Int : PhotoKey ] = [:]
    var discards: [ Int : PhotoKey ] = [:]
    
    enum list {
        case keepers
        case discards
    }
    
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
    
    func keepPhoto(photo: PhotoKey, list: PhotoList.list) {
        if list == .keepers {
            keepers[photo.index] = photo
            self.discards[photo.index] = nil
            if !photoIsInList(photo, list: Array(self.allPhotoList.values) ) {
                allPhotoList[photo.index] = photo
            }
        }
        if list == .discards {
            self.keepers[photo.index] = nil
        }
    }
    
    func deletePhoto(photo: PhotoKey) {
        self.keepers[photo.index] = nil
        self.discards[photo.index] = nil
        self.allPhotoList[photo.index] = nil
    }

    func sortedListOfPhotoIndices(list: PhotoList.list) -> [Int] {
        var sortedIndices = [Int]()
        if list == .keepers {
            sortedIndices = keepers.keys.sort()
        }
        if list == .discards {
            sortedIndices = discards.keys.sort()
        }
        return sortedIndices
    }


    func getTotalImages(list: PhotoList.list) -> [Int : UIImage] {
        var imageDict = [Int: UIImage]()
        if list == .discards {
            for i in 0 ..< self.discards.count {
                let photo = Array(self.discards.values)[i].image
                imageDict[i] = photo
            }
        } else if list == .keepers {
            for i in 0 ..< self.keepers.count {
                let photo = Array(self.keepers.values)[i].image
                imageDict[i] = photo
            }
        }

        return imageDict
    }
    
    
    //end
}

