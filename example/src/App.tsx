import * as React from 'react';
import CameraView, { RefMethods } from '../../src/CameraView';
import { useEffect, useRef } from 'react';

export default function App() {
  const ref = useRef<RefMethods>();

  useEffect(() => {
    console.log(
      ref.current?.getSupportedDevices('back', (devices: any) => {
        console.log(devices);
      })
    );
    setTimeout(() => {
      ref.current?.stop();
    }, 2000);
    setTimeout(() => {
      ref.current?.start();
    }, 4000);
  }, []);

  return (
    <CameraView
      device={'back'}
      ref={ref}
      zoom={3.1}
      deviceType={'wide-angle-camera'}
    />
  );
}
