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

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lee el token guardado con guardarTokenSeguro. Si encuentra el token de una
/// versión anterior (sin cifrar), lo mueve al almacenamiento seguro.
Future<String> leerTokenSeguro() async {
  const almacen = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  try {
    final preferencias = await SharedPreferences.getInstance();
    final anterior = preferencias.getString('ff_tokenSesion') ?? '';
    if (anterior.isNotEmpty) {
      await almacen.write(key: 'city_care_access_token', value: anterior);
    }
    await preferencias.remove('ff_tokenSesion');
  } catch (_) {}
  try {
    return await almacen.read(key: 'city_care_access_token') ?? '';
  } catch (_) {
    return '';
  }
}
