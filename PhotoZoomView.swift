//
//  PhotoView.swift
//  GrowthTimeline
//
//  Created by Alex Bin Zhao on 16/8/17.
//  Copyright © 2017 Mobility Arts. All rights reserved.
//

import Foundation

public class PhotoZoomView: UIScrollView, UIScrollViewDelegate {
    public var photoPosition : Int = 0
    
    var isZoomed : Bool = false
    var imageView : UIImageView?
    var titleLabel : UILabel?
    var subTitleLabel : UILabel?
    var spinner : UIActivityIndicatorView?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)

        backgroundColor = UIColor.black
        delegate = self
        maximumZoomScale = 3
        minimumZoomScale = 1
        
        imageView = UIImageView(frame: self.bounds)
        imageView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView!.contentMode = .scaleAspectFit
        imageView!.isUserInteractionEnabled = true
        self.addSubview(imageView!)
        
        titleLabel = UILabel(frame: CGRect(x: 10.0, y: 20.0, width: self.bounds.size.width - 20.0, height: 30.0))
        titleLabel!.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        titleLabel!.backgroundColor = UIColor.clear
        titleLabel!.textColor = UIColor.white
        titleLabel!.textAlignment = NSTextAlignment.center
        titleLabel!.numberOfLines = 0
        titleLabel!.font = UIFont.boldSystemFont(ofSize: 15.0)
        self.addSubview(titleLabel!)
        
        subTitleLabel = UILabel(frame: CGRect(x: 10.0, y: 50.0, width: self.bounds.size.width - 20.0, height: 30.0))
        subTitleLabel!.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        subTitleLabel!.backgroundColor = UIColor.clear
        subTitleLabel!.textColor = UIColor.white
        subTitleLabel!.textAlignment = NSTextAlignment.center
        subTitleLabel!.numberOfLines = 0
        subTitleLabel!.font = UIFont.boldSystemFont(ofSize: 15.0)
        self.addSubview(subTitleLabel!)
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
        spinner!.frame = CGRect(x: self.bounds.size.width / 2 - spinner!.frame.size.width / 2, y: (self.bounds.size.height / 2) - spinner!.frame.size.height * 2, width: spinner!.frame.size.width, height: spinner!.frame.size.height)
        spinner!.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.addSubview(spinner!)
        
        let doubleTapGestureOnDayView = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTapGestureOnImageView(tapGesture:)))
        doubleTapGestureOnDayView.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureOnDayView);
    }
    
    func handleDoubleTapGestureOnImageView(tapGesture: UITapGestureRecognizer) {
        isZoomed = !isZoomed
        if isZoomed {
            var location = tapGesture.location(ofTouch: 0, in: imageView)
            location.x /= imageView!.bounds.size.width
            location.y /= imageView!.bounds.size.height
            location.x *= self.contentSize.width
            location.y *= self.contentSize.height
            location.x -= self.bounds.size.width / 2;
            location.y -= self.bounds.size.height / 2;
            
            self.setZoomScale(2.5, animated: true)
            self.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        } else {
            self.setZoomScale(1.0, animated: true)
            self.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        }
        
    }
    
    // MARK: UIScrollViewDelegate methods
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
