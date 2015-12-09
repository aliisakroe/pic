//
//  LandscapeViewController.swift
//  pic
//
//  Created by Aliisa Roe on 12/6/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import UIKit


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
        var nextImage = swipe.swipeUpDelete(rightImage)
        nextImage = swipe.differentPhoto(nextImage, imageView2: leftImage, direction: .right)
        rightImage.image = nextImage
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        if photoList.keepers.count == 1 {
             NSNotificationCenter.defaultCenter().postNotificationName(lastPhoto, object: self)
        }
    }
    
    //COULD PROBABLY REWRITE ALL OF THESE INTO A FUNCTION :P
    
    @IBAction func leftSwipeUp (sender: UISwipeGestureRecognizer) {
        var nextImage = swipe.swipeUpDelete(leftImage)
        nextImage = swipe.differentPhoto(nextImage, imageView2: rightImage, direction: .right)
        leftImage.image = nextImage
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
        if photoList.keepers.count == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(lastPhoto, object: self)
        }
    }
    
    @IBAction func swipeRonL(sender: AnyObject) {
        var nextImage = swipe.getNextPhoto(leftImage.image!, direction: .right)
        nextImage = swipe.differentPhoto(nextImage, imageView2: rightImage, direction: .right)
        leftImage.image = nextImage
    }

    @IBAction func swipeRonR(sender: AnyObject) {
        var nextImage = swipe.getNextPhoto(rightImage.image!, direction: .right)
        nextImage = swipe.differentPhoto(nextImage, imageView2: leftImage, direction: .right)
        rightImage.image = nextImage
    }
    
    @IBAction func swipeLonL(sender: AnyObject) {
        var nextImage = swipe.getNextPhoto(leftImage.image!, direction: .left)
        nextImage = swipe.differentPhoto(nextImage, imageView2: rightImage, direction: .left)
        leftImage.image = nextImage
    }
    @IBAction func swipeLonR(sender: AnyObject) {
        var nextImage = swipe.getNextPhoto(rightImage.image!, direction: .left)
        nextImage = swipe.differentPhoto(nextImage, imageView2: leftImage, direction: .left)
        rightImage.image = nextImage
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
