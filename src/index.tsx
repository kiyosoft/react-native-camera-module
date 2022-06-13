import {
  requireNativeComponent,
  UIManager,
  Platform,
  ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-camera-module' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

type CameraModuleProps = {
  color: string;
  style: ViewStyle;
};

const ComponentName = 'CameraModuleView';

export const CameraModuleView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<CameraModuleProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
