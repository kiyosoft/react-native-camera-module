import * as React from 'react';
import { useEffect, useRef } from 'react';
import CameraView, { RefMethods } from '../../src/CameraView';
import { Button, View, StyleSheet,SafeAreaView } from 'react-native';

export default function App() {
  const ref = useRef<RefMethods>();

  useEffect(() => {
    console.log(
      ref.current?.getSupportedDevices('back', (devices: any) => {
        console.log(devices);
      }),
    );
    setTimeout(() => {
      ref.current?.stop();
    }, 2000);
    setTimeout(() => {
      ref.current?.start();
    }, 4000);
  }, []);

  return (
    <SafeAreaView>
      <CameraView
        device={'back'}
        ref={ref}
        zoom={'3.1'}
        deviceType={'wide-angle-camera'}
      />
      <Button style={{...StyleSheet.absoluteFillObject, position: 'absolute',bottom: 200,top: 200, zIndex: 99 }} title={'Record'} onPress={() => {
        ref?.current?.record({
          maxDuration: 5,
          saveToCameraRoll: true,
          recordingCallback: (recordingResponse: { isSuccessful: any; path: any; }) => {
            if (recordingResponse && recordingResponse?.isSuccessful) {
              console.log(recordingResponse.path);
            }
          },
        });
      }} />
    </SafeAreaView>
  );
}
