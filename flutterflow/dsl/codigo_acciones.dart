// Generado por .ffai_staging/acciones/generar_codigo_dsl.py: no editar a mano.
// Código de las acciones personalizadas que sube dsl/edit.dart.

final codigoEnviarReporte = r'''
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
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
    final campo = RegExp(r'"field"\s*:\s*"([A-Za-z]+)"').firstMatch(cuerpo)?.group(1);
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
    if (cuerpo.contains('E_REPORT_DESCRIPTION_REQUIRED') || campo == 'descripcion') {
      return 'Describe brevemente el problema que deseas reportar.';
    }
    if (cuerpo.contains('E_REPORT_LOCATION_SOURCE_INVALID') || campo == 'origenUbicacion') {
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
        final json = jsonDecode(utf8.decode(catalogo.bodyBytes, allowMalformed: true));
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
      // En el navegador la ubicación es fija: no se presenta como lectura de GPS.
      ..fields['origenUbicacion'] = kIsWeb ? 'manual' : origenUbicacion;
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
    if (!kIsWeb &&
        precisionUbicacion.isFinite &&
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
    final respuesta =
        await http.Response.fromStream(enviada).timeout(const Duration(seconds: 60));
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
      mensaje: 'No se pudo enviar el reporte. Revisa tu conexión e inténtalo otra vez.',
    );
  }
}
''';

final codigoListarMisReportes = r'''
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
    final etiqueta = estado is Map ? texto(estado['nombre'] ?? estado['name']) : texto(estado);
    return etiqueta.isEmpty ? 'Pendiente' : etiqueta;
  }

  String categoriaDe(Map item) {
    final categoria = item['categoria'] ?? item['category'];
    if (categoria is Map) {
      return texto(categoria['nombre'] ?? categoria['name'] ?? categoria['codigo']);
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
      fecha: DateTime.tryParse(texto(item['creadoEn'] ?? item['createdAt']))?.toLocal(),
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
          mensaje: 'Tu cuenta no tiene acceso a los reportes. Contacta al administrador de City Care.',
          reportes: [],
        );
      }
      if (respuesta.statusCode != 200) {
        return ResultadoReportesStruct(
          exito: false,
          codigoHttp: respuesta.statusCode,
          mensaje: 'No pudimos cargar tus reportes (error ${respuesta.statusCode}).',
          reportes: [],
        );
      }
      // Respuesta: {"data": [...], "meta": {"lastPage", "currentPage", ...}}.
      final json = jsonDecode(utf8.decode(respuesta.bodyBytes, allowMalformed: true));
      final datos = json is Map ? json['data'] : json;
      final lista = datos is List ? datos : const [];
      reportes.addAll(lista.whereType<Map>().map(convertir));
      final meta = json is Map && json['meta'] is Map ? json['meta'] as Map : const {};
      final ultima = int.tryParse('${meta['lastPage'] ?? meta['last_page'] ?? ''}') ?? pagina;
      if (pagina >= ultima || lista.isEmpty) break;
    }
    reportes.sort((a, b) => (b.fecha ?? DateTime(0)).compareTo(a.fecha ?? DateTime(0)));
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
''';

final codigoObtenerDetalleReporte = r'''
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// GET {urlApi}/reports/{id} con token Bearer: folio, estado, fotografía
/// (URL firmada temporal) e historial de cambios de estado.
Future<DetalleServidorStruct> obtenerDetalleReporte(
  String urlApi,
  String token,
  String idServidor,
) async {
  String texto(Object? valor) => valor == null ? '' : '$valor'.trim();
  String estadoVisible(Object? codigo, Object? etiqueta) {
    switch (texto(codigo).toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En proceso';
      case 'resolved':
        return 'Resuelto';
    }
    final valor = etiqueta is Map ? texto(etiqueta['nombre'] ?? etiqueta['name']) : texto(etiqueta);
    return valor.isEmpty ? 'Pendiente' : valor;
  }

  if (idServidor.trim().isEmpty || token.isEmpty) {
    return DetalleServidorStruct(exito: false, codigoHttp: 0, mensaje: '', historial: []);
  }
  try {
    final base = urlApi.trim().replaceAll(RegExp(r'/+$'), '');
    final respuesta = await http.get(
      Uri.parse('$base/reports/${Uri.encodeComponent(idServidor.trim())}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ).timeout(const Duration(seconds: 20));
    if (respuesta.statusCode == 401) {
      return DetalleServidorStruct(
        exito: false,
        codigoHttp: 401,
        mensaje: 'Tu sesión venció. Inicia sesión nuevamente.',
        historial: [],
      );
    }
    if (respuesta.statusCode == 404) {
      return DetalleServidorStruct(
        exito: false,
        codigoHttp: 404,
        mensaje: 'Este reporte ya no está disponible.',
        historial: [],
      );
    }
    if (respuesta.statusCode != 200) {
      return DetalleServidorStruct(
        exito: false,
        codigoHttp: respuesta.statusCode,
        mensaje: 'No pudimos cargar el detalle (error ${respuesta.statusCode}).',
        historial: [],
      );
    }
    final json = jsonDecode(utf8.decode(respuesta.bodyBytes, allowMalformed: true));
    final item = json is Map && json['data'] is Map ? json['data'] as Map : (json is Map ? json : const {});
    // Historial (contrato: estadoNuevoCodigo, estadoNuevo, observacion,
    // creadoEn), del más antiguo al más reciente.
    final historial = <String>[];
    final cambios = item['historial'];
    if (cambios is List) {
      final ordenados = cambios.whereType<Map>().toList()
        ..sort((a, b) => texto(a['creadoEn']).compareTo(texto(b['creadoEn'])));
      for (final cambio in ordenados) {
        final estado = estadoVisible(
          cambio['estadoCodigo'] ?? cambio['estadoNuevoCodigo'],
          cambio['estado'] ?? cambio['estadoNuevo'],
        );
        final fecha = DateTime.tryParse(texto(cambio['creadoEn'] ?? cambio['fecha']))?.toLocal();
        final nota = texto(cambio['observacion'] ?? cambio['comentario'] ?? cambio['nota']);
        final cuando = fecha == null
            ? ''
            : '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
        historial.add([estado, cuando, nota].where((t) => t.isNotEmpty).join(' · '));
      }
    }
    return DetalleServidorStruct(
      exito: true,
      codigoHttp: 200,
      mensaje: '',
      folio: texto(item['folio']),
      estado: estadoVisible(item['estadoCodigo'], item['estado']),
      fotoUrl: texto(item['fotoUrl']),
      historial: historial,
    );
  } on TimeoutException {
    return DetalleServidorStruct(
      exito: false,
      codigoHttp: 0,
      mensaje: 'El servidor tardó demasiado en responder.',
      historial: [],
    );
  } catch (_) {
    return DetalleServidorStruct(
      exito: false,
      codigoHttp: 0,
      mensaje: 'No pudimos conectar con el servidor.',
      historial: [],
    );
  }
}
''';

final codigoObtenerUbicacionGps = r'''
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';

Future<UbicacionGpsStruct> obtenerUbicacionGps() async {
  // En el navegador (modo Run) no se consulta el GPS: se usa el centro de
  // Guadalajara. En Android siempre se lee el GPS real.
  if (kIsWeb) {
    return UbicacionGpsStruct(
      estado: 'ok',
      latitud: 20.67665,
      longitud: -103.34751,
      precision: 0,
    );
  }
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
''';

final codigoGuardarTokenSeguro = r'''
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
''';

final codigoLeerTokenSeguro = r'''
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
''';
