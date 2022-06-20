#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(CameraModuleViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(device, NSString)
RCT_EXPORT_VIEW_PROPERTY(flash, NSString)
RCT_EXPORT_VIEW_PROPERTY(torch, NSString)
RCT_EXPORT_VIEW_PROPERTY(deviceType, NSString)
RCT_EXPORT_VIEW_PROPERTY(zoom, CGFloat)

// Camera View Functions
RCT_EXTERN_METHOD(start:(nonnull NSNumber *)node);
RCT_EXTERN_METHOD(stop:(nonnull NSNumber *)node);
RCT_EXTERN_METHOD(startRecording:(nonnull NSNumber *)node options:(NSDictionary *)options onRecordCallback:(RCTResponseSenderBlock)onRecordCallback);
RCT_EXTERN_METHOD(pauseRecording:(nonnull NSNumber *)node);
RCT_EXTERN_METHOD(resumeRecording:(nonnull NSNumber *)node);
RCT_EXTERN_METHOD(stopRecording:(nonnull NSNumber *)node);
RCT_EXTERN_METHOD(takePhoto:(nonnull NSNumber *)node options:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(focus:(nonnull NSNumber *)node point:(NSDictionary *)point resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(getDevices:(nonnull NSNumber *)node position:(NSString *)position devicesList:(RCTResponseSenderBlock)onRecordCallback);

@end
