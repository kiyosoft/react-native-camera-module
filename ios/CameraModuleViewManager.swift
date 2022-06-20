import NextLevel
import AVFoundation
import UIKit
import Foundation
import React

@objc(CameraModuleViewManager)
class CameraModuleViewManager: RCTViewManager {
    
    override func view() -> UIView! {
        return CameraView()
    }
    
    override var methodQueue: DispatchQueue! {
        return DispatchQueue.main
    }
    
    @objc
    final func start(_ node: NSNumber) {
        let component = getCameraView(withTag: node)
        component.start()
    }
    
    
    @objc
    final func stop(_ node: NSNumber) {
        let component = getCameraView(withTag: node)
        component.stop()
    }
    
    @objc
    final func startRecording(_ node: NSNumber, options: NSDictionary, onRecordCallback: @escaping RCTResponseSenderBlock) {
        let component = getCameraView(withTag: node)
        component.startCapture(options: options, callback: onRecordCallback)
    }
    
    @objc
    final func stopRecording(_ node: NSNumber) {
        let component = getCameraView(withTag: node)
        component.endCapture()
    }
    
    @objc
    final func pauseRecording(_ node: NSNumber) {
        let component = getCameraView(withTag: node)
        component.pauseCapture()
    }
    
    @objc
    final func getDevices(_ node: NSNumber, position: String, devicesList: @escaping RCTResponseSenderBlock) {
        let component = getCameraView(withTag: node)
        let callback = Callback(devicesList);
        callback.resolve(component.getSupportedDevices(position: position))
    }
    
    private func getCameraView(withTag tag: NSNumber) -> CameraView {
        return self.bridge.uiManager.view(forReactTag: tag) as! CameraView
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
