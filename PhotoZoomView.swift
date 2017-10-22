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
    var videoPlayButton : UIButton?
    
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
        imageView!.isUserInteractionEnabled = false
        self.addSubview(imageView!)
        
        titleLabel = UILabel(frame: CGRect(x: 10.0, y: 20.0, width: self.bounds.size.width - 20.0, height: 30.0))
        titleLabel!.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        titleLabel!.backgroundColor = UIColor.clear
        titleLabel!.textColor = UIColor.white
        titleLabel!.textAlignment = NSTextAlignment.center
        titleLabel!.numberOfLines = 0
        titleLabel!.font = UIFont.boldSystemFont(ofSize: 15.0)
        self.addSubview(titleLabel!)
        
        subTitleLabel = UILabel(frame: CGRect(x: 10.0, y: 50.0, width: self.bounds.size.width - 20.0, height: 40.0))
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
        
        videoPlayButton = UIButton(type: UIButtonType.custom)
        videoPlayButton!.frame = CGRect(x: (self.bounds.size.width - 66.0) / 2, y: (self.bounds.size.height - 66.0) / 2, width: 66.0, height: 66.0)
        videoPlayButton!.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        videoPlayButton!.setImage(drawPlayVideoIcon(imageSize: videoPlayButton!.frame.size), for: UIControlState.normal)
        self.addSubview(videoPlayButton!)
        
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
    
    func drawPlayVideoIcon(imageSize: CGSize) -> UIImage {
        // Get the current context
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        // Draw triangle
        let triangleRect = CGRect(x: (imageSize.width - 30.0) / 2, y: (imageSize.height - 36.0) / 2, width: 36.0, height: 36.0)
        context.move(to: CGPoint(x: triangleRect.minX, y: triangleRect.minY))
        context.addLine(to: CGPoint(x: triangleRect.maxX, y: triangleRect.midY))
        context.addLine(to: CGPoint(x: triangleRect.minX, y: triangleRect.maxY))
        context.closePath()
        context.setFillColor(UIColor.white.cgColor)
        context.fillPath()
        
        // Draw a round Circle
        context.addArc(center: CGPoint(x: imageSize.width / 2, y: imageSize.width / 2), radius: imageSize.width / 2 - 3.0, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: false);
        context.closePath()
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(6.0)
        context.strokePath()
        
        // Save the context as a new UIImage
        let uiImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return uiImage!
    }
}
