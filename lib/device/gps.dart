import 'package:geolocator/geolocator.dart';

class GpsSensor {
  Future<LocationPermission>
      get permissionStatus async => // Usando GeoLocator verifica el estado de los permisos

          await Geolocator.checkPermission();

  Future<Position>
      get currentLocation async => // Usando GeoLocator obten la posicion actual

          await Geolocator.getCurrentPosition();

  Future<LocationAccuracyStatus>
      get locationAccuracy async => // Usando GeoLocator verifica la precision de la ubicacion con soporte para web

          await Geolocator.getLocationAccuracy();

  Future<LocationPermission> requestPermission() async {
    // TODO: Debes configurar correctamente el AndroidManifest.xml para Android:
    // 1. <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    // 2. <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    // TODO: Si usas iOS debes configurar el Info.plist usando Xcode
    // 1. <key>NSLocationWhenInUseUsageDescription</key>
    //    <string>Esta aplicación necesita acceso a la ubicación cuando está abierta.</string>
    // 2. <key>NSLocationAlwaysUsageDescription</key>
    //    <string>Esta aplicación necesita acceso a la ubicación cuando está en segundo plano.</string>

    // TODO: Usando GeoLocator solicita los permisos

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return permission;
  }
}
