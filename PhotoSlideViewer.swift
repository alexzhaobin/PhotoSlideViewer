//
//  PhotoSlideViewer.swift
//  GrowthTimeline
//
//  Created by Alex Bin Zhao on 16/8/17.
//  Copyright © 2017 Mobility Arts. All rights reserved.
//

import Foundation

@objc public protocol PhotoSlideViewerSource {
    func loadPhoto(photoObject: AnyObject, titleCallBack: (_ title: String?, _ subtitle: String?) -> Void, videoCallBack: (_ isVideo: Bool) -> Void, imageCallBack: (_ image: UIImage?) -> Void)
    func playVideo(photoObject: AnyObject)
}

@objc public class PhotoSlideViewer: UIView {
    var photos: [AnyObject]?
    var photoPosition : Int = 0
    public var photoSource : PhotoSlideViewerSource?
    
    var photoZoomViewFront : PhotoZoomView?;
    var photoZoomViewBack : PhotoZoomView?;

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        photoZoomViewBack = PhotoZoomView(frame: self.bounds)
        photoZoomViewBack!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoZoomViewBack!.videoPlayButton!.addTarget(self, action: #selector(playVideo), for: UIControlEvents.touchUpInside)
        self.addSubview(photoZoomViewBack!);
        
        photoZoomViewFront = PhotoZoomView(frame: self.bounds)
        photoZoomViewFront!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoZoomViewFront!.videoPlayButton!.addTarget(self, action: #selector(playVideo), for: UIControlEvents.touchUpInside)
        self.addSubview(photoZoomViewFront!);
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeLeftGestureOnImageView(swipeGesture:)))
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeftGestureRecognizer);
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeRightGestureOnImageView(swipeGesture:)))
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRightGestureRecognizer);
    }
    
    func playVideo() {
        let photo = photos?[Int(photoZoomViewFront!.photoPosition)];
        photoSource?.playVideo(photoObject: photo!)
    }
    
    func handleSwipeLeftGestureOnImageView(swipeGesture: UISwipeGestureRecognizer) {
        if (photoPosition == (photos?.count)! - 1) {
            photoPosition = 0;
        } else {
            photoPosition += 1;
        }
        
        swapPhotoViewsToDisplayCurrentPhoto(goLeft: false)
    }
    
    func handleSwipeRightGestureOnImageView(swipeGesture: UISwipeGestureRecognizer) {
        if (photoPosition == 0) {
            photoPosition = (photos?.count)! - 1;
        } else {
            photoPosition -= 1;
        }
        
        swapPhotoViewsToDisplayCurrentPhoto(goLeft: true)
    }
    
    func swapPhotoViewsToDisplayCurrentPhoto(goLeft: Bool) {
        let photoZoomView = photoZoomViewFront
        photoZoomViewFront = photoZoomViewBack
        photoZoomViewBack = photoZoomView
        displayCurrentPhoto(photoZoomView: photoZoomViewFront!)
        
        photoZoomViewFront?.frame = CGRect(x: self.bounds.size.width * (goLeft ? -1 : 1), y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { 
            self.photoZoomViewFront?.frame = self.bounds
            self.photoZoomViewBack?.frame = CGRect(x: self.bounds.size.width * (goLeft ? 1 : -1), y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height)
        }) { (finished: Bool) in
        }
    }
    
    func displayCurrentPhoto(photoZoomView: PhotoZoomView) {
        if photos == nil {
            return;
        }
        
        if (photoZoomView.photoPosition == photoPosition && (photoZoomView.imageView!.image != nil)) {
            return;
        }
        
        if ((photos?.count)! > 0) {
            if (photoPosition > (photos?.count)! - 1) {
                photoPosition = (photos?.count)! - 1
            }
            let photo = photos?[Int(photoPosition)];
            
            photoZoomView.photoPosition = photoPosition
            
            photoZoomView.imageView?.image = nil
            photoZoomView.spinner?.startAnimating()
            photoSource?.loadPhoto(photoObject: photo!,
                               titleCallBack: { (title: String?, subtitle: String?) in
                                    photoZoomView.titleLabel?.text = title
                                    photoZoomView.subTitleLabel?.text = subtitle
            },
                               videoCallBack: { (isVideo: Bool) in
                                    photoZoomView.videoPlayButton?.isHidden = !isVideo
            },
                               imageCallBack: { (image : UIImage?) in
                                    photoZoomView.imageView?.image = image
                                    photoZoomView.spinner?.stopAnimating()
            })
        }
    }
    
    public func setPhotos(photos: [AnyObject]?, initialPhotoPosition: Int) {
        self.photos = photos
        self.photoPosition = initialPhotoPosition;
        displayCurrentPhoto(photoZoomView: photoZoomViewFront!)
    }
}
