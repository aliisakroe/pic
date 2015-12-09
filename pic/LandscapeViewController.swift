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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: nil, name: newKeepersNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lastPhotos", name: lastPhoto, object: nil)
        rightImage.image = photoList.getTotalImages(.keepers)[0]
        leftImage.image = photoList.getTotalImages(.keepers)[1]

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("hi")
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
        leftImage.image = photoList.getTotalImages(.keepers)[0]
        print("i know this is the last photo ~landscape")
    }
    
    
    func lastPhotos() {
        leftImage.removeGestureRecognizer(self.leftSwipeUp)
        leftImage.removeGestureRecognizer(self.swipeRonL)
        leftImage.removeGestureRecognizer(self.swipeLonL)
        rightImage.removeGestureRecognizer(self.swipeLonR)
        rightImage.removeGestureRecognizer(self.swipeRonR)
        rightImage.removeGestureRecognizer(self.rightSwipeUp)
        if photoList.keepers.count == 1 {
            lastPhotoFunc()
        }
    }

    @IBAction func rightSwipeUp(sender: UISwipeGestureRecognizer) {
        var nextPhotoKey = swipe.swipeUpDelete(rightImage)
        nextPhotoKey = swipe.differentPhoto(nextPhotoKey, imageView2: leftImage, direction: .right)
        setImg(rightImage, asset: nextPhotoKey.asset)
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        if photoList.keepers.count == 1 {
             NSNotificationCenter.defaultCenter().postNotificationName(lastPhoto, object: self)
        }
    }
    
    func setImg(imageView: UIImageView, asset: PHAsset) {
        let manager = PHImageManager.defaultManager()
        manager.requestImageForAsset(asset,
            targetSize: CGSizeMake(4000.0, 4000.0),
            contentMode: .AspectFill ,
            options: nil) { (result, _) in
                var imageForPhoto = result!
                imageView.image = imageForPhoto
        }
    }
    
    //COULD PROBABLY REWRITE ALL OF THESE INTO A FUNCTION :P
    
    @IBAction func leftSwipeUp (sender: UISwipeGestureRecognizer) {
        var nextPhotoKey = swipe.swipeUpDelete(leftImage)
        nextPhotoKey = swipe.differentPhoto(nextPhotoKey, imageView2: rightImage, direction: .right)
        setImg(leftImage, asset: nextPhotoKey.asset)
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        if photoList.keepers.count == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(lastPhoto, object: self)
        }
    }
    
    func swipeAndSetPhoto(imageView: UIImageView, direction: Swipe.direction) {
        let currentPhotoKey = swipe.imageToPhotoKey(imageView.image!)
        var nextPhotoKey = swipe.getNextPhotoKey(currentPhotoKey, direction: direction)
        nextPhotoKey = swipe.differentPhoto(nextPhotoKey, imageView2: rightImage, direction: direction)
        setImg(imageView, asset: nextPhotoKey.asset)
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
