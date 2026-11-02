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

/// GET {urlApi}/reports con token Bearer: reportes del ciudadano (solo los
/// suyos), paginados de 50 en 50. Los convierte al tipo Reporte de la app
/// (estado "Pendiente", "En proceso" o "Resuelto").
Future<ResultadoReportesStruct> listarMisReportes(
  String urlApi,
  String token,
) async {
  // Los decimales de MySQL pueden llegar como texto ("20.676650").
  double? numero(Object? valor) =>
      valor is num ? valor.toDouble() : double.tryParse('${valor ?? ''}');
  String texto(Object? valor) => valor == null ? '' : '$valor'.trim();
  String estadoVisible(Map item) {
    switch (texto(item['estadoCodigo']).toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En proceso';
      case 'resolved':
        return 'Resuelto';
    }
    final estado = item['estado'];
    final etiqueta = estado is Map
        ? texto(estado['nombre'] ?? estado['name'])
        : texto(estado);
    return etiqueta.isEmpty ? 'Pendiente' : etiqueta;
  }

  String categoriaDe(Map item) {
    final categoria = item['categoria'] ?? item['category'];
    if (categoria is Map) {
      return texto(
          categoria['nombre'] ?? categoria['name'] ?? categoria['codigo']);
    }
    return texto(categoria ?? item['categoriaNombre']);
  }

  ReporteStruct convertir(Map item) {
    final latitud = numero(item['latitud']);
    final longitud = numero(item['longitud']);
    final precision = numero(item['precisionUbicacion']);
    final foto = texto(item['fotoUrl']);
    return ReporteStruct(
      idServidor: texto(item['id']),
      folio: texto(item['folio']),
      categoria: categoriaDe(item),
      descripcion: texto(item['descripcion']),
      direccion: texto(item['direccion']),
      latitud: latitud,
      longitud: longitud,
      precisionUbicacion: precision,
      origenUbicacion: texto(item['origenUbicacion']),
      estado: estadoVisible(item),
      fecha: DateTime.tryParse(texto(item['creadoEn'] ?? item['createdAt']))
          ?.toLocal(),
      tieneFoto: foto.isNotEmpty,
      fotoUrl: foto,
    );
  }

  if (token.isEmpty) {
    return ResultadoReportesStruct(
      exito: false,
      codigoHttp: 401,
      mensaje: 'Tu sesión venció. Inicia sesión nuevamente.',
      reportes: [],
    );
  }
  try {
    final base = urlApi.trim().replaceAll(RegExp(r'/+$'), '');
    final reportes = <ReporteStruct>[];
    // Hasta 10 páginas (500 reportes) para no quedarse cargando sin fin.
    for (var pagina = 1; pagina <= 10; pagina++) {
      final respuesta = await http.get(
        Uri.parse('$base/reports?page=$pagina&perPage=50'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(const Duration(seconds: 20));
      if (respuesta.statusCode == 401) {
        return ResultadoReportesStruct(
          exito: false,
          codigoHttp: 401,
          mensaje: 'Tu sesión venció. Inicia sesión nuevamente.',
          reportes: [],
        );
      }
      if (respuesta.statusCode == 403) {
        return ResultadoReportesStruct(
          exito: false,
          codigoHttp: 403,
          mensaje:
              'Tu cuenta no tiene acceso a los reportes. Contacta al administrador de City Care.',
          reportes: [],
        );
      }
      if (respuesta.statusCode != 200) {
        return ResultadoReportesStruct(
          exito: false,
          codigoHttp: respuesta.statusCode,
          mensaje:
              'No pudimos cargar tus reportes (error ${respuesta.statusCode}).',
          reportes: [],
        );
      }
      // Respuesta: {"data": [...], "meta": {"lastPage", "currentPage", ...}}.
      final json =
          jsonDecode(utf8.decode(respuesta.bodyBytes, allowMalformed: true));
      final datos = json is Map ? json['data'] : json;
      final lista = datos is List ? datos : const [];
      reportes.addAll(lista.whereType<Map>().map(convertir));
      final meta =
          json is Map && json['meta'] is Map ? json['meta'] as Map : const {};
      final ultima =
          int.tryParse('${meta['lastPage'] ?? meta['last_page'] ?? ''}') ??
              pagina;
      if (pagina >= ultima || lista.isEmpty) break;
    }
    reportes.sort(
        (a, b) => (b.fecha ?? DateTime(0)).compareTo(a.fecha ?? DateTime(0)));
    return ResultadoReportesStruct(
      exito: true,
      codigoHttp: 200,
      mensaje: '',
      reportes: reportes,
    );
  } on TimeoutException {
    return ResultadoReportesStruct(
      exito: false,
      codigoHttp: 0,
      mensaje: 'El servidor tardó demasiado en responder.',
      reportes: [],
    );
  } catch (_) {
    return ResultadoReportesStruct(
      exito: false,
      codigoHttp: 0,
      mensaje: 'No pudimos conectar con el servidor.',
      reportes: [],
    );
  }
}
