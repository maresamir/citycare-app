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
import 'package:http_parser/http_parser.dart';

/// POST {urlApi}/reports en multipart/form-data con token Bearer
/// (contrato city-care.v1). Devuelve el folio o un mensaje de error en español.
Future<ResultadoEnvioStruct> enviarReporte(
  String urlApi,
  String token,
  String categoria,
  String descripcion,
  String direccion,
  double latitud,
  double longitud,
  double precisionUbicacion,
  String origenUbicacion,
  FFUploadedFile foto,
) async {
  // Errores del backend: {"error": {"code", "message", "details": [{"field"}]}}.
  String mensajeDeError(int codigo, String cuerpo) {
    final campo =
        RegExp(r'"field"\s*:\s*"([A-Za-z]+)"').firstMatch(cuerpo)?.group(1);
    String? mensajeServidor;
    try {
      final json = jsonDecode(cuerpo);
      final error = json is Map ? json['error'] : null;
      if (error is Map && error['message'] is String) {
        mensajeServidor = error['message'] as String;
      }
    } catch (_) {}
    if (codigo == 401 || cuerpo.contains('E_UNAUTHORIZED_ACCESS')) {
      return 'Tu sesión venció. Inicia sesión nuevamente.';
    }
    if (codigo == 403) {
      return 'Tu cuenta no tiene permiso para crear reportes. Contacta al administrador de City Care.';
    }
    if (codigo == 413) {
      return 'La fotografía es demasiado pesada. Usa una de máximo 10 MB.';
    }
    if (cuerpo.contains('E_REPORT_DESCRIPTION_REQUIRED') ||
        campo == 'descripcion') {
      return 'Describe brevemente el problema que deseas reportar.';
    }
    if (cuerpo.contains('E_REPORT_LOCATION_SOURCE_INVALID') ||
        campo == 'origenUbicacion') {
      return 'No pudimos confirmar el origen de la ubicación. Toca Reintentar.';
    }
    if (cuerpo.contains('E_REPORT_LOCATION_INVALID') ||
        campo == 'latitud' ||
        campo == 'longitud' ||
        campo == 'precisionUbicacion') {
      return 'La ubicación no es válida. Toca Reintentar para leer el GPS de nuevo.';
    }
    if (cuerpo.contains('E_REPORT_CATEGORY_INVALID') || campo == 'categoria') {
      return 'Esa categoría no está disponible por ahora. Elige otra.';
    }
    if (campo == 'foto') {
      return 'La fotografía no es válida. Usa una foto JPG o PNG de máximo 10 MB.';
    }
    if (campo == 'direccion') {
      return 'La dirección es demasiado larga. Toca Reintentar para leerla de nuevo.';
    }
    if (codigo == 503) {
      return 'El servidor de fotografías no está disponible. Tu reporte sigue aquí: inténtalo en unos minutos.';
    }
    if (codigo >= 500) {
      return 'El servidor no pudo guardar el reporte. Inténtalo más tarde.';
    }
    if (mensajeServidor != null && mensajeServidor.trim().isNotEmpty) {
      return mensajeServidor;
    }
    if (codigo == 422) {
      return 'Revisa los datos del reporte e inténtalo de nuevo.';
    }
    return 'No se pudo enviar el reporte (error $codigo). Inténtalo otra vez.';
  }

  try {
    final base = urlApi.trim().replaceAll(RegExp(r'/+$'), '');
    // El servidor espera el nombre exacto de su catálogo: si difiere en
    // mayúsculas o acentos ("Alumbrado publico"), se usa el del servidor.
    var categoriaServidor = categoria.trim();
    try {
      String normal(String t) {
        var r = t.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
        const con = 'áéíóúüñ';
        const sin = 'aeiouun';
        for (var i = 0; i < con.length; i++) {
          r = r.replaceAll(con[i], sin[i]);
        }
        return r;
      }

      final catalogo = await http.get(
        Uri.parse('$base/report-categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(const Duration(seconds: 10));
      if (catalogo.statusCode == 200) {
        final json =
            jsonDecode(utf8.decode(catalogo.bodyBytes, allowMalformed: true));
        final lista = json is Map ? json['data'] : json;
        if (lista is List) {
          for (final c in lista.whereType<Map>()) {
            final nombre = '${c['nombre'] ?? c['name'] ?? ''}';
            if (nombre.isNotEmpty &&
                (normal(nombre) == normal(categoria) ||
                    normal('${c['codigo'] ?? ''}') == normal(categoria))) {
              categoriaServidor = nombre;
              break;
            }
          }
        }
      }
    } catch (_) {}
    final solicitud = http.MultipartRequest('POST', Uri.parse('$base/reports'))
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..headers['ngrok-skip-browser-warning'] = 'true'
      ..fields['categoria'] = categoriaServidor
      ..fields['latitud'] = latitud.toString()
      ..fields['longitud'] = longitud.toString()
      ..fields['origenUbicacion'] = origenUbicacion;
    final textoDescripcion = descripcion.trim();
    if (textoDescripcion.isNotEmpty) {
      solicitud.fields['descripcion'] = textoDescripcion;
    }
    final textoDireccion = direccion.trim();
    if (textoDireccion.isNotEmpty) {
      solicitud.fields['direccion'] = textoDireccion.length > 500
          ? textoDireccion.substring(0, 500)
          : textoDireccion;
    }
    if (precisionUbicacion.isFinite &&
        precisionUbicacion >= 0 &&
        precisionUbicacion <= 100000) {
      solicitud.fields['precisionUbicacion'] = precisionUbicacion.toString();
    }
    final bytes = foto.bytes ?? <int>[];
    final esPng = bytes.length > 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
    solicitud.files.add(http.MultipartFile.fromBytes(
      'foto',
      bytes,
      filename: esPng ? 'evidencia.png' : 'evidencia.jpg',
      contentType: MediaType('image', esPng ? 'png' : 'jpeg'),
    ));

    final enviada = await solicitud.send().timeout(const Duration(seconds: 60));
    final respuesta = await http.Response.fromStream(enviada)
        .timeout(const Duration(seconds: 60));
    final cuerpo = utf8.decode(respuesta.bodyBytes, allowMalformed: true);
    if (respuesta.statusCode != 201 && respuesta.statusCode != 200) {
      return ResultadoEnvioStruct(
        exito: false,
        codigoHttp: respuesta.statusCode,
        mensaje: mensajeDeError(respuesta.statusCode, cuerpo),
      );
    }
    var datos = <String, dynamic>{};
    try {
      final json = jsonDecode(cuerpo);
      if (json is Map<String, dynamic>) {
        datos = json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;
      }
    } catch (_) {}
    return ResultadoEnvioStruct(
      exito: true,
      codigoHttp: respuesta.statusCode,
      id: int.tryParse('${datos['id'] ?? ''}'),
      folio: '${datos['folio'] ?? ''}',
      estado: const {
            'pending': 'Pendiente',
            'in_progress': 'En proceso',
            'resolved': 'Resuelto',
          }['${datos['estadoCodigo'] ?? ''}'] ??
          (datos['estado'] is String && '${datos['estado']}'.isNotEmpty
              ? '${datos['estado']}'
              : 'Pendiente'),
      estadoEvidencia: '${datos['estadoEvidencia'] ?? ''}',
      creadoEn: '${datos['creadoEn'] ?? ''}',
      mensaje: '',
    );
  } on TimeoutException {
    return ResultadoEnvioStruct(
      exito: false,
      codigoHttp: 0,
      mensaje:
          'El servidor tardó demasiado en responder. Revisa tu conexión e inténtalo otra vez.',
    );
  } catch (_) {
    return ResultadoEnvioStruct(
      exito: false,
      codigoHttp: 0,
      mensaje:
          'No se pudo enviar el reporte. Revisa tu conexión e inténtalo otra vez.',
    );
  }
}
