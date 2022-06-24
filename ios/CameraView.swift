//
//  CameraView.swift
//  react-native-camera-module
//
//  Created by Kidus Solomon on 16/06/2022.
//

import Foundation
import NextLevel
import AVFoundation
import Photos
import UIKit


class CameraView: UIView {

    internal var previewView: UIView?
    internal var jsCallbackFunc: RCTResponseSenderBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initCameraSession()
        initDeligates()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCameraSession()
        initDeligates()
    }

    @objc var torch: String = "off" {
        didSet {
            if(torch == "on") {
                NextLevel.shared.torchMode = .on
            } else if(torch == "auto") {
                NextLevel.shared.torchMode = .auto
            } else {
                NextLevel.shared.torchMode = .off
            }
        }
    }

    @objc var flash: String = "off" {
        didSet {
            if(flash == "on") {
                NextLevel.shared.flashMode = .on
            } else if(flash == "auto") {
                NextLevel.shared.flashMode = .auto
            } else {
                NextLevel.shared.flashMode = .off
            }
        }
    }

    @objc var device: String = "back" {
        didSet {
            if(device == "front") {
                NextLevel.shared.devicePosition = .front
            } else {
                NextLevel.shared.devicePosition = .back
            }
        }
    }

    @objc var zoom: String = "1.0" {
        didSet {
            print(zoom)
            NextLevel.shared.videoZoomFactor = (zoom as NSString).floatValue
        }
    }


    @objc var deviceType: String = "wide-angle-camera" {
        didSet {
            if(deviceType == "ultra-wide-angle-camera") {
                do {
                    try NextLevel.shared.changeCaptureDeviceIfAvailable(captureDevice: .ultraWideAngleCamera)
                }catch {

                }
            } else if(deviceType == "wide-angle-camera") {
                do {
                    try NextLevel.shared.changeCaptureDeviceIfAvailable(captureDevice: .wideAngleCamera)
                }catch {

                }
            }
        }
    }

    var saveVideoToCameraRoll: Bool = true

    private func initViews() {

        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let screenBounds = UIScreen.main.bounds

        self.previewView = UIView(frame: screenBounds)
        if let previewView = self.previewView {
            previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            previewView.backgroundColor = UIColor.black
            NextLevel.shared.previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(NextLevel.shared.previewLayer)
            self.addSubview(previewView)
        }
    }

    private func initCameraSession() {
        let nextLevel = NextLevel.shared

        nextLevel.videoStabilizationMode = .standard
        nextLevel.deviceOrientation = .portrait
        nextLevel.videoConfiguration.preset = .hd1280x720
        if #available(iOS 11.0, *) {
            nextLevel.videoConfiguration.codec = .hevc
        } else {
            // Fallback on earlier versions
            if #available(iOS 11.0, *) {
                nextLevel.videoConfiguration.codec = .h264
            }
        }

        if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            do {
                try NextLevel.shared.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            NextLevel.requestAuthorization(forMediaType: AVMediaType.video) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    do {
                        let nextLevel = NextLevel.shared
                        try nextLevel.start()
                    } catch {
                        print("NextLevel, failed to start camera session")
                    }
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
            NextLevel.requestAuthorization(forMediaType: AVMediaType.audio) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    do {
                        let nextLevel = NextLevel.shared
                        try nextLevel.start()
                    } catch {
                        print("NextLevel, failed to start camera session")
                    }
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
        }

    }


    private func initDeligates(){
        let nextLevel = NextLevel.shared

        nextLevel.videoDelegate = self
        nextLevel.delegate = self
    }
}

extension CameraView: NextLevelDelegate {
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {

    }

    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {

    }

    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {

    }

    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        initViews()
    }

    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {

    }

    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {

    }

    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {

    }

    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {

    }

    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {

    }
}


// MARK: - NextLevelVideoDelegate
extension CameraView: NextLevelVideoDelegate {

    // video zoom
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {
    }

    // video frame processing
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
    }

    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
    }

    // enabled by isCustomContextVideoRenderingEnabled
    func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue) {
    }

    // video recording session
    func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didAppendVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didSkipVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }

    func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession) {
        // called when a configuration time limit is specified
        self.endCapture()
    }

    // video frame photo
    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String: Any]?) {
        if let dictionary = photoDict,
           let photoData = dictionary[NextLevelPhotoJPEGKey] as? Data,
           let photoImage = UIImage(data: photoData) {
            self.savePhoto(photoImage: photoImage)
        }
    }

}

extension CameraView {

    internal func start() {
        initCameraSession()
    }

    internal func stop() {
        NextLevel.shared.stop();
    }

    internal func startCapture(options: NSDictionary, callback jsCallbackFunc: @escaping RCTResponseSenderBlock) {
        self.jsCallbackFunc = jsCallbackFunc;

        if((options["maxDuration"]) != nil) {
            NextLevel.shared.videoConfiguration.maximumCaptureDuration = CMTimeMakeWithSeconds(options["maxDuration"] as! Float64, preferredTimescale: 600)
        }

        if((options["bitrate"]) != nil) {
            NextLevel.shared.videoConfiguration.bitRate = options["bitrate"] as! Int
        }

        if((options["saveVideoToCameraRoll"]) != nil) {
            self.saveVideoToCameraRoll = options["saveVideoToCameraRoll"] as! Bool
        }


        NextLevel.shared.record()
    }

    internal func pauseCapture() {
        print("Pause Capture")
        NextLevel.shared.pause()
    }

    internal func endCapture() {
        print("End Capture")
        if let session = NextLevel.shared.session {

            let callback = Callback(jsCallbackFunc!)

            if session.clips.count > 1 {
                session.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { (url: URL?, error: Error?) in
                    if let url = url {
                        if(self.saveVideoToCameraRoll) {
                            self.saveVideo(withURL: url)
                        }
                        callback.resolve([
                            "path": url.path,
                            "isSuccessful": true,
                        ])

                    } else if let _ = error {
                        callback.reject(error: "failed to merge clips at the end of capture \(String(describing: error))")
                        print("failed to merge clips at the end of capture \(String(describing: error))")
                    }
                })
            } else if let lastClipUrl = session.lastClipUrl {
                if(self.saveVideoToCameraRoll){
                    self.saveVideo(withURL: lastClipUrl)
                }
                callback.resolve([
                    "isSuccessful": true,
                    "path": lastClipUrl.path,
                ])
            } else if session.currentClipHasStarted {
                session.endClip(completionHandler: { (clip, error) in
                    if error == nil, let url = clip?.url {
                        if(self.saveVideoToCameraRoll){
                            self.saveVideo(withURL: url)
                        }
                        callback.resolve([
                            "isSuccessful": true,
                            "path": url.path,
                        ])
                    } else {
                        callback.reject(error: "Error saving video: \(error?.localizedDescription ?? "")")
                        print("Error saving video: \(error?.localizedDescription ?? "")")
                    }
                    self.restartSession();
                })
            } else {
                // prompt that the video has been saved
                callback.reject(error: "Not enough video captured!")
                self.restartSession();
            }
        }
    }


    internal func getSupportedDevices(position: String) -> Any {
        var cameraPosition: AVCaptureDevice.Position = .back
        if(position == "front") {
            cameraPosition = .front
        }
        var discoverySession: AVCaptureDevice.DiscoverySession
        if #available(iOS 13.0, *) {
            discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
                                                                    [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera, .builtInUltraWideCamera, .builtInTelephotoCamera],
                                                                mediaType: .video, position: cameraPosition)
        } else {
            discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
                                                                    [ .builtInWideAngleCamera, .builtInTelephotoCamera],
                                                                mediaType: .video, position: cameraPosition)
        }

        return discoverySession.devices.map { AVCaptureDevice in
            AVCaptureDevice.deviceType
        }
    }


    internal func restartSession() {
        let nextLevel = NextLevel.shared
        do {
            nextLevel.session?.reset()
            nextLevel.session?.removeAllClips(removeFiles: true)
            try nextLevel.start()
        } catch {

        }
    }

    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            return result.firstObject
        }
        return nil
    }

    internal func authorizePhotoLibaryIfNecessary() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .restricted:
            fallthrough
        case .denied:
            let alertController = UIAlertController(title: "Oh no!", message: "Access denied.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.parentViewController?.present(alertController, animated: true, completion: nil)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {

                } else {

                }
            })
            break
        case .authorized:
            break
        case .limited:
            break
        @unknown default:
            fatalError("unknown authorization type")
        }
    }

    internal func saveVideo(withURL url: URL) {
        self.authorizePhotoLibaryIfNecessary()
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewController.nextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CameraViewController.nextLevelAlbumTitle)
                _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (_: Bool, _: Error?) in
                if let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewController.nextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                    }, completionHandler: { (success2: Bool, _: Error?) in
                        if success2 == true {

                        } else {

                        }
                    })
                }
            })
    }

    internal func savePhoto(photoImage: UIImage) {

        PHPhotoLibrary.shared().performChanges({

            let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewController.nextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CameraViewController.nextLevelAlbumTitle)
                _ = changeRequest.placeholderForCreatedAssetCollection
            }

        }, completionHandler: { (success1: Bool, error1: Error?) in

            if success1 == true {
                if let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewController.nextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                        let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                        let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                        assetCollectionChangeRequest?.addAssets(enumeration)
                    }, completionHandler: { (success2: Bool, _: Error?) in
                        if success2 == true {
                            let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.parentViewController?.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
            } else if let _ = error1 {
                print("failure capturing photo from video frame \(String(describing: error1))")
            }

        })
    }
}
