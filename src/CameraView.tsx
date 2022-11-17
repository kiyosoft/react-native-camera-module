import React, { forwardRef, useImperativeHandle, useRef } from 'react';
import {
  findNodeHandle,
  NativeModules,
  Platform,
  requireNativeComponent,
  UIManager,
  ViewStyle,
} from 'react-native';

export interface CameraViewProps {
  torch?: 'on' | 'off' | 'auto';
  device?: 'back' | 'front';
  style?: ViewStyle;
  zoom?: string;
  deviceType: 'ultra-wide-angle-camera' | 'wide-angle-camera' | '';
  ref: any;
}

export interface RecordingOptions {
  maxDuration: number;
  saveToCameraRoll: boolean;
  recordingCallback: (recordingResponse: RecordingResponse) => void;
}

export interface RecordingResponse {
  isSuccessful: boolean;
  path: string;
  error: string;
}

export interface RefMethods {
  start: () => void;
  stop: () => void;
  record: (options: RecordingOptions) => void;
  pause: () => void;
  finish: () => void;
  getSupportedDevices: (devicePosition: string, callback: any) => string[];
}

const LINKING_ERROR =
  `The package 'react-native-camera-module' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

type CameraModuleProps = {
  style: ViewStyle;
  device?: 'back' | 'front';
  flash?: 'on' | 'off' | 'auto';
  torch?: 'on' | 'off' | 'auto';
  zoom?: string;
  deviceType: string;
  ref?: any;
};

const ComponentName = 'CameraModuleView';

export const CameraModuleView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<CameraModuleProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

export const CameraModule = NativeModules.CameraModuleViewManager;

const CameraView: React.FC<CameraViewProps> = forwardRef(
  ({ torch, device, style, zoom, deviceType }, parentRef) => {
    const ref = useRef<any>();

    const handle = () => {
      const nodeHandle = findNodeHandle(ref?.current);
      if (nodeHandle == null || nodeHandle === -1) {
        throw new Error(
          'system/view-not-found' +
            "Could not get the Camera's native view tag! Does the Camera View exist in the native view-tree?"
        );
      }

      return nodeHandle;
    };

    useImperativeHandle(parentRef, () => ({
      start: () => {
        const nodeHandle = handle();
        CameraModule.start(nodeHandle);
      },
      stop: () => {
        const nodeHandle = handle();
        CameraModule.stop(nodeHandle);
      },
      record: (options: RecordingOptions) => {
        const nodeHandle = handle();
        CameraModule.startRecording(nodeHandle, options, (response: any) => {
          options.recordingCallback(response);
        });
      },
      pause: () => {
        const nodeHandle = handle();
        CameraModule.pauseRecording(nodeHandle);
      },
      finish: () => {
        const nodeHandle = handle();
        CameraModule.stopRecording(nodeHandle);
      },
      getSupportedDevices: (devicePosition: string, callback: any) => {
        const nodeHandle = handle();
        return CameraModule.getDevices(nodeHandle, devicePosition, callback);
      },
    }));

    return (
      <CameraModuleView
        ref={ref}
        device={device}
        torch={torch}
        style={style ? style : {}}
        zoom={zoom}
        deviceType={deviceType}
      />
    );
  }
);

export default CameraView;
