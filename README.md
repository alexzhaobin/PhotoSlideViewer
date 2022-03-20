# PhotoSlideViewer

An implementation of Photo Slider UI in iOS using swift, with photo zoom capability.

The photo loading and video playing logic is abstracted with protocol `PhotoSlideViewerSource` which needs to be implemented separately.

```
@objc public protocol PhotoSlideViewerSource {
    func loadPhoto(photoObject: AnyObject, titleCallBack: @escaping (_ title: String?, _ subtitle: String?) -> Void, videoCallBack: @escaping (_ isVideo: Bool) -> Void, imageCallBack: @escaping (_ image: UIImage?) -> Void)
    func playVideo(photoObject: AnyObject)
}
```
