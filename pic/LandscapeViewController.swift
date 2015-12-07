//
//  LandscapeViewController.swift
//  pic
//
//  Created by Aliisa Roe on 12/6/15.
//  Copyright © 2015 Aliisa Roe. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    var swipe = Swipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: nil, name: newKeepersNotification, object: nil)
        rightImage.image = photoList.getTotalImages(.keepers)[0]
        leftImage.image = photoList.getTotalImages(.keepers)[1]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
         return UIInterfaceOrientationMask.Landscape
    }


    @IBAction func rightSwipeUp(sender: UISwipeGestureRecognizer) {
        print("I felt that, right")
        swipe.swipeUpDelete(rightImage)
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
    }
    
    
    @IBAction func leftSwipeUp (sender: UISwipeGestureRecognizer) {
        print("i felt that, left")
        swipe.swipeUpDelete(leftImage)
        NSNotificationCenter.defaultCenter().postNotificationName(newKeepersNotification, object: self)
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
