//
//  LandscapeViewController.swift
//  pic
//
//  Created by Aliisa Roe on 12/6/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import UIKit
import Photos


class LandscapeViewController: UIViewController {


    @IBOutlet weak var lastImageView: UIImageView!
    @IBOutlet weak var rightSwipeUp: UISwipeGestureRecognizer!
    @IBOutlet weak var leftSwipeUp: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeRonR: UISwipeGestureRecognizer!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var swipeRonL: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeLonL: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeLonR: UISwipeGestureRecognizer!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    var swipe = Swipe()
    var rightPhotoKey : PhotoKey?
    var leftPhotoKey : PhotoKey?
    
    
    
    //Mark: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: nil, name: newKeepersNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lastPhotoFunc", name: lastPhoto, object: nil)
        if photoList.keepers.count == 1 {
            lastPhotoFunc()
        } else {
        setImg(leftImage, photoKey: leftPhotoKey!)
        let photoIndex = photoList.sortedListOfPhotoIndices(.keepers)[0]
        var photoKey = photoList.keepers[photoIndex]!
        photoKey = swipe.differentPhoto(photoKey, otherPhotoKey: leftPhotoKey!, direction: .right)!
        setImg(rightImage, photoKey: photoKey)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if photoList.keepers.count == 1 {
            lastPhotoFunc()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func lastPhotoFunc() {
        stackView.removeFromSuperview()
       lastImageView.hidden = false
        removeGestures()
        let photoIndex = photoList.sortedListOfPhotoIndices(.keepers)[0]
        let photoKey = photoList.keepers[photoIndex]!
        setImg(lastImageView, photoKey: photoKey)
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
    }
    
    
    func removeGestures() {
        leftImage.removeGestureRecognizer(self.leftSwipeUp)
        leftImage.removeGestureRecognizer(self.swipeRonL)
        leftImage.removeGestureRecognizer(self.swipeLonL)
        rightImage.removeGestureRecognizer(self.swipeLonR)
        rightImage.removeGestureRecognizer(self.swipeRonR)
        rightImage.removeGestureRecognizer(self.rightSwipeUp)
    }
    
    
    func setImg(imageView: UIImageView, photoKey: PhotoKey) {
        if imageView == rightImage {
            rightPhotoKey = photoKey
        }
        if imageView == leftImage {
            leftPhotoKey = photoKey
        }
        let manager = PHImageManager.defaultManager()
        manager.requestImageForAsset(photoKey.asset,
            targetSize: CGSizeMake(4000.0, 4000.0),
            contentMode: .AspectFill ,
            options: nil) { (result, _) in
                let imageForPhoto = result!
                imageView.image = imageForPhoto
        }
    }
    
    func swipeAndSetPhoto(imageView: UIImageView, direction: Swipe.direction) {
        var nextPhotoKey : PhotoKey?
        if imageView == leftImage {
            nextPhotoKey = swipe.getNextPhotoKey(leftPhotoKey!, direction: direction)
            nextPhotoKey = swipe.differentPhoto(nextPhotoKey!, otherPhotoKey: rightPhotoKey!, direction: direction)
        }
        if imageView == rightImage {
            nextPhotoKey = swipe.getNextPhotoKey(rightPhotoKey!, direction: direction)
            nextPhotoKey = swipe.differentPhoto(nextPhotoKey!, otherPhotoKey: leftPhotoKey!, direction: direction)
        }
        setImg(imageView, photoKey: nextPhotoKey!)
    }
    
    
    
    
//MARK: - IBAction

    @IBAction func rightSwipeUp(sender: UISwipeGestureRecognizer) {
        let nextPhotoKey = swipe.swipeUpDelete(rightImage, currentPhotoKey: rightPhotoKey!)
        if photoList.keepers.count == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(lastPhoto, object: self)
        } else {
        if let differentPhotoKey = swipe.differentPhoto(nextPhotoKey, otherPhotoKey: leftPhotoKey!, direction: .right){
                NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
                setImg(rightImage, photoKey: differentPhotoKey)
            }
        }
    }
    
    @IBAction func leftSwipeUp (sender: UISwipeGestureRecognizer) {
        let nextPhotoKey = swipe.swipeUpDelete(leftImage, currentPhotoKey: leftPhotoKey!)
        if photoList.keepers.count == 1 {
             NSNotificationCenter.defaultCenter().postNotificationName(lastPhoto, object: self)
        } else {
        if let differentPhotoKey = swipe.differentPhoto(nextPhotoKey, otherPhotoKey: rightPhotoKey!, direction: .right) {
            setImg(leftImage, photoKey: differentPhotoKey)
            NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
            }
        }
    }
    
    @IBAction func swipeRonL(sender: AnyObject) {
        swipeAndSetPhoto(leftImage, direction: .right)
    }

    @IBAction func swipeRonR(sender: AnyObject) {
        swipeAndSetPhoto(rightImage, direction: .right)
    }
    
    @IBAction func swipeLonL(sender: AnyObject) {
        swipeAndSetPhoto(leftImage, direction: .left)
    }
    @IBAction func swipeLonR(sender: AnyObject) {
        swipeAndSetPhoto(rightImage, direction: .left)
    }
    
    
    
    
    
    
 //end
}


