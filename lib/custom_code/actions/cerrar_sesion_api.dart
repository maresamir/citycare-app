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

import 'dart:async';

import 'package:http/http.dart' as http;

/// POST {urlApi}/account/logout con token Bearer: invalida el token en el
/// servidor. Devuelve true si el servidor lo aceptó; la app cierra la sesión
/// local de todos modos.
Future<bool> cerrarSesionApi(
  String urlApi,
  String token,
) async {
  if (token.isEmpty) {
    return true;
  }
  try {
    final base = urlApi.trim().replaceAll(RegExp(r'/+$'), '');
    final respuesta = await http.post(
      Uri.parse('$base/account/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ).timeout(const Duration(seconds: 10));
    return respuesta.statusCode == 200 ||
        respuesta.statusCode == 204 ||
        respuesta.statusCode == 401;
  } catch (_) {
    return false;
  }
}
