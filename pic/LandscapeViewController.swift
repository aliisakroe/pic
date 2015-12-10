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


    @IBOutlet weak var rightSwipeUp: UISwipeGestureRecognizer!
    @IBOutlet weak var leftSwipeUp: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeRonR: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeRonL: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeLonL: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeLonR: UISwipeGestureRecognizer!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    var swipe = Swipe()
    var rightPhotoKey : PhotoKey?
    var leftPhotoKey : PhotoKey?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: nil, name: newKeepersNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lastPhotoFunc", name: lastPhoto, object: nil)
        if photoList.keepers.count == 1 {
            lastPhotoFunc()
        } else {
        let photoIndex = photoList.sortedListOfPhotoIndices(.keepers)[0]
        let photoKey = photoList.keepers[photoIndex]!
        setImg(rightImage, photoKey: photoKey)
        let photoIndex2 = photoList.sortedListOfPhotoIndices(.keepers)[1]
        let photoKey2 = photoList.keepers[photoIndex2]!
        setImg(leftImage, photoKey: photoKey2)
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
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        print("landscapper")
//         return UIInterfaceOrientationMask.Landscape
//    }

    func lastPhotoFunc() {
        rightImage.removeFromSuperview()
        removeGestures()
        let photoIndex = photoList.sortedListOfPhotoIndices(.keepers)[0]
        let photoKey = photoList.keepers[photoIndex]!
        setImg(leftImage, photoKey: photoKey)
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        print("i know this is the last photo ~landscape")
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
    
  //  COULD PROBABLY REWRITE ALL OF THESE INTO A FUNCTION :P
    
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
    
    /*
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if self.window?.rootViewController?.presentedViewController is SecondViewController {
            
            let secondController = self.window!.rootViewController.presentedViewController as! LandscapeViewController
            
            if secondController.isPresented {
                return UIInterfaceOrientationMask.All.rawValue
            } else {
                return UIInterfaceOrientationMask.Portrait.rawValue
            }
        } else {
            return UIInterfaceOrientationMask.Portrait.rawValue
        }
        
    }
    */

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
