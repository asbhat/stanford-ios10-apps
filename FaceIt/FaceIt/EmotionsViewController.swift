//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Aditya Bhat on 11/5/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

/*
 ## View Controller Lifecycle Summary ##

 - Instantiated (from storyboard usually)
 - awakeFromNib
 - prepare(for segue:, sender:)
 - outlets get set
 - viewDidLoad
 - viewWillAppear / viewDidAppear / viewWillDisappear / viewDidDisappear
 - viewWillLayoutSubviews / viewDidLayoutSubviews
   - anytime after viewDidLoad, whether on or off screen
 - didReceiveMemoryWarning
   - can also get this at any time

*/

import UIKit

class EmotionsViewController: VCLLoggingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()  // always let super have a chance in all lifecycle methods
        // Do any additional setup after loading the view (e.g., update UI based on model)
        // better than an init because outlets are setup before this is called
        // do **not** do anything with geometry or bounds (i.e. don't know the size of the screen yet)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // view will only be 'loaded' once, but might appear and disappear a lot
        // e.g., if things are changing offscreen, maybe update before view appears (instead of once before loading)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // e.g., might want to start an animation
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // e.g., stop animations / clean-up
        // don't do anything time consuming here or app will be sluggish
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // some people match up doing / undoing...
        //      viewWillAppear <--> viewDidDisappear
        //      viewDidAppear <--> viewWillDisappear
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // for Geometry
        // happens before Autolayout
        // sometimes called very frequently with no bound changes
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // for Geometry
        // happens after Autolayout
        // sometimes called very frequently with no bound changes
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // participate in Autorotation
        //      can do custom animations (using the coordinator) when there is a rotation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
        // anything offscreen or that can been reinitialized from disk
        // generally just big things (images, sounds, movies)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // try to avoid using this!

        // put code somewhere else if possible (e.g., viewDidLoad or viewWillAppear)
        // happens before MVC is 'loaded' (and outlets are set)

        // might want to use this to change the default displayed view when split view is loaded (using delegates)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier,
            let expression = emotionalFaces[identifier] {
                faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }

    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "happy"     :   FacialExpression(eyes: .open, mouth: .smile),
        "worried"   :   FacialExpression(eyes: .open, mouth: .grimmace),
        "sad"       :   FacialExpression(eyes: .closed, mouth: .frown)
    ]
}
