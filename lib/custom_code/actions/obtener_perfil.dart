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
import 'dart:convert';

import 'package:http/http.dart' as http;

/// GET {urlApi}/account/profile con token Bearer. Devuelve los datos del
/// usuario; codigoHttp 401 indica que la sesión venció.
Future<UsuarioSesionStruct> obtenerPerfil(
  String urlApi,
  String token,
) async {
  try {
    final base = urlApi.trim().replaceAll(RegExp(r'/+$'), '');
    final respuesta = await http.get(
      Uri.parse('$base/account/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ).timeout(const Duration(seconds: 20));
    if (respuesta.statusCode == 401) {
      return UsuarioSesionStruct(
        exito: false,
        codigoHttp: 401,
        mensaje: 'Tu sesión venció. Inicia sesión nuevamente.',
      );
    }
    if (respuesta.statusCode == 403) {
      return UsuarioSesionStruct(
        exito: false,
        codigoHttp: 403,
        mensaje:
            'Tu cuenta está desactivada. Contacta al administrador de City Care.',
      );
    }
    if (respuesta.statusCode != 200) {
      return UsuarioSesionStruct(
        exito: false,
        codigoHttp: respuesta.statusCode,
        mensaje:
            'No pudimos actualizar tu perfil (error ${respuesta.statusCode}).',
      );
    }
    // Respuesta: {"data": {"firstName", "lastName", "email", "phoneNumber", ...}}.
    final json =
        jsonDecode(utf8.decode(respuesta.bodyBytes, allowMalformed: true));
    final usuario = json is Map && json['data'] is Map
        ? json['data'] as Map
        : (json is Map ? json : <String, dynamic>{});
    final nombre =
        '${usuario['firstName'] ?? ''} ${usuario['lastName'] ?? ''}'.trim();
    return UsuarioSesionStruct(
      exito: true,
      codigoHttp: 200,
      token: token,
      nombre: nombre.isEmpty ? 'Ciudadano' : nombre,
      correo: '${usuario['email'] ?? ''}',
      telefono: '${usuario['phoneNumber'] ?? ''}',
      mensaje: '',
    );
  } on TimeoutException {
    return UsuarioSesionStruct(
      exito: false,
      codigoHttp: 0,
      mensaje: 'El servidor tardó demasiado en responder.',
    );
  } catch (_) {
    return UsuarioSesionStruct(
      exito: false,
      codigoHttp: 0,
      mensaje: 'No pudimos conectar con el servidor.',
    );
  }
}
