//
//  ImageViewController.swift
//  Cassini
//
//  Created by Aditya Bhat on 11/7/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // view.addSubview(imageView)  // "view" is a special var that represents the root view (of this VC)
        imageURL = DemoURL.stanford
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // only want to load image if it's going to be displayed
        if image == nil {
            fetchImage()
        }
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1
            scrollView.contentSize = imageView.frame.size
            // adding view programatically
            scrollView.addSubview(imageView)
        }
    }

    fileprivate var imageView = UIImageView()  // same as initializing with (frame: CGRect.zero)

    private var image: UIImage? {
        get {
            return imageView.image
        }
        set(newImage) {
            imageView.image = newImage
            imageView.sizeToFit()
            // scrollView might be nil! (if outlets not setup yet) so optional chain
            scrollView?.contentSize = imageView.frame.size
        }
    }

    private func fetchImage() {
        if let url = imageURL {
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                image = UIImage(data: imageData)
            }
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    // extending the above class to conform to the delegate protocol
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
