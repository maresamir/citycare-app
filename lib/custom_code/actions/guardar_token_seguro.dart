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

/// Guarda el token de sesión en el almacenamiento cifrado del sistema
/// (Keystore en Android). Con token vacío lo borra.
Future<void> guardarTokenSeguro(String token) async {
  const almacen = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  try {
    if (token.isEmpty) {
      await almacen.delete(key: 'city_care_access_token');
    } else {
      await almacen.write(key: 'city_care_access_token', value: token);
    }
  } catch (_) {}
}
