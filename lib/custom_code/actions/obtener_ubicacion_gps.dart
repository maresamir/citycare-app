// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:geolocator/geolocator.dart';

Future<UbicacionGpsStruct> obtenerUbicacionGps() async {
  try {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      return UbicacionGpsStruct(estado: 'servicio_desactivado');
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.deniedForever) {
      return UbicacionGpsStruct(estado: 'permiso_denegado_siempre');
    }
    if (permiso != LocationPermission.always &&
        permiso != LocationPermission.whileInUse) {
      return UbicacionGpsStruct(estado: 'permiso_denegado');
    }
    final posicion = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
    if (posicion.latitude == 0 && posicion.longitude == 0) {
      return UbicacionGpsStruct(estado: 'error');
    }
    return UbicacionGpsStruct(
      estado: 'ok',
      latitud: posicion.latitude,
      longitud: posicion.longitude,
      precision: posicion.accuracy,
    );
  } on LocationServiceDisabledException {
    return UbicacionGpsStruct(estado: 'servicio_desactivado');
  } on PermissionDeniedException {
    return UbicacionGpsStruct(estado: 'permiso_denegado');
  } catch (_) {
    return UbicacionGpsStruct(estado: 'error');
  }
}
