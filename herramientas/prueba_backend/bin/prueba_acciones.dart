// Prueba local de las acciones contra el servidor simulado (city-care.v1.yaml).
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:prueba_envio/servidor_simulado.dart';

class FFUploadedFile {
  FFUploadedFile({this.name, this.bytes});
  final String? name;
  final List<int>? bytes;
}

class ResultadoEnvioStruct {
  ResultadoEnvioStruct({this.exito, this.codigoHttp, this.id, this.folio, this.estado,
      this.estadoEvidencia, this.creadoEn, this.mensaje});
  final bool? exito;
  final int? codigoHttp;
  final int? id;
  final String? folio;
  final String? estado;
  final String? estadoEvidencia;
  final String? creadoEn;
  final String? mensaje;
  @override
  String toString() => 'exito=$exito http=$codigoHttp folio=$folio estado=$estado mensaje="$mensaje"';
}

class UsuarioSesionStruct {
  UsuarioSesionStruct({this.exito, this.codigoHttp, this.mensaje, this.token, this.nombre,
      this.correo, this.telefono});
  final bool? exito;
  final int? codigoHttp;
  final String? mensaje;
  final String? token;
  final String? nombre;
  final String? correo;
  final String? telefono;
  @override
  String toString() =>
      'exito=$exito http=$codigoHttp token=${(token ?? '').isEmpty ? '(vacío)' : '${token!.substring(0, 6)}...'} nombre="$nombre" correo="$correo" tel="$telefono" mensaje="$mensaje"';
}


class ReporteStruct {
  ReporteStruct({this.idServidor, this.folio, this.categoria, this.descripcion, this.direccion,
      this.latitud, this.longitud, this.precisionUbicacion, this.origenUbicacion, this.estado,
      this.fecha, this.tieneFoto, this.fotoUrl});
  final String? idServidor;
  final String? folio;
  final String? categoria;
  final String? descripcion;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final double? precisionUbicacion;
  final String? origenUbicacion;
  final String? estado;
  final DateTime? fecha;
  final bool? tieneFoto;
  final String? fotoUrl;
  @override
  String toString() => 'id=$idServidor folio=$folio "$categoria" estado=$estado lat=$latitud lon=$longitud foto=${(fotoUrl ?? '').isNotEmpty}';
}

class ResultadoReportesStruct {
  ResultadoReportesStruct({this.exito, this.codigoHttp, this.mensaje, this.reportes});
  final bool? exito;
  final int? codigoHttp;
  final String? mensaje;
  final List<ReporteStruct>? reportes;
  @override
  String toString() => 'exito=$exito http=$codigoHttp total=${reportes?.length} mensaje="$mensaje"';
}

class DetalleServidorStruct {
  DetalleServidorStruct({this.exito, this.codigoHttp, this.mensaje, this.folio, this.estado,
      this.fotoUrl, this.historial});
  final bool? exito;
  final int? codigoHttp;
  final String? mensaje;
  final String? folio;
  final String? estado;
  final String? fotoUrl;
  final List<String>? historial;
  @override
  String toString() => 'exito=$exito http=$codigoHttp folio=$folio estado=$estado foto=$fotoUrl historial=$historial mensaje="$mensaje"';
}


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

/// POST {urlApi}/auth/login con correo y contraseña. Devuelve el token y los
/// datos del usuario, o un mensaje de error en español.
Future<UsuarioSesionStruct> iniciarSesionApi(
  String urlApi,
  String correo,
  String contrasena,
) async {
  // Errores del backend: {"error": {"code", "message", "details"}}.
  String mensajeDeError(int codigo, String cuerpo) {
    String? mensajeServidor;
    try {
      final json = jsonDecode(cuerpo);
      final error = json is Map ? json['error'] : null;
      if (error is Map && error['message'] is String) {
        mensajeServidor = error['message'] as String;
      }
    } catch (_) {}
    if (codigo == 400 || codigo == 401 || cuerpo.contains('E_INVALID_CREDENTIALS')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (codigo == 403) {
      return 'Tu cuenta está desactivada o no tiene acceso. Contacta al administrador de City Care.';
    }
    if (codigo == 429) {
      return 'Demasiados intentos. Espera un minuto e inténtalo de nuevo.';
    }
    if (codigo == 422) {
      return 'Revisa tu correo y tu contraseña.';
    }
    if (codigo >= 500) {
      return 'El servidor no está disponible. Inténtalo más tarde.';
    }
    if (mensajeServidor != null && mensajeServidor.trim().isNotEmpty) {
      return mensajeServidor;
    }
    return 'No se pudo iniciar sesión (error $codigo). Inténtalo otra vez.';
  }

  try {
    final base = urlApi.trim().replaceAll(RegExp(r'/+$'), '');
    final respuesta = await http
        .post(
          Uri.parse('$base/auth/login'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
          body: jsonEncode({'email': correo.trim(), 'password': contrasena}),
        )
        .timeout(const Duration(seconds: 30));
    final cuerpo = utf8.decode(respuesta.bodyBytes, allowMalformed: true);
    if (respuesta.statusCode != 200 && respuesta.statusCode != 201) {
      return UsuarioSesionStruct(
        exito: false,
        codigoHttp: respuesta.statusCode,
        mensaje: mensajeDeError(respuesta.statusCode, cuerpo),
      );
    }
    // Respuesta: {"data": {"user": {...}, "token": "oat_..."}}.
    var datos = <String, dynamic>{};
    try {
      final json = jsonDecode(cuerpo);
      if (json is Map<String, dynamic>) {
        datos = json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;
      }
    } catch (_) {}
    final valorToken = datos['token'];
    final token = valorToken is Map
        ? '${valorToken['value'] ?? valorToken['token'] ?? ''}'
        : '${valorToken ?? ''}';
    if (token.isEmpty) {
      return UsuarioSesionStruct(
        exito: false,
        codigoHttp: respuesta.statusCode,
        mensaje: 'El servidor no devolvió un token de acceso. Avísale al administrador.',
      );
    }
    final usuario = datos['user'] is Map ? datos['user'] as Map : <String, dynamic>{};
    final nombre = '${usuario['firstName'] ?? ''} ${usuario['lastName'] ?? ''}'.trim();
    return UsuarioSesionStruct(
      exito: true,
      codigoHttp: respuesta.statusCode,
      token: token,
      nombre: nombre.isEmpty ? 'Ciudadano' : nombre,
      correo: '${usuario['email'] ?? correo.trim()}',
      telefono: '${usuario['phoneNumber'] ?? ''}',
      mensaje: '',
    );
  } on TimeoutException {
    return UsuarioSesionStruct(
      exito: false,
      codigoHttp: 0,
      mensaje: 'El servidor tardó demasiado en responder. Revisa tu conexión.',
    );
  } catch (_) {
    return UsuarioSesionStruct(
      exito: false,
      codigoHttp: 0,
      mensaje: 'No pudimos conectar con el servidor. Revisa tu conexión e inténtalo otra vez.',
    );
  }
}

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
        mensaje: 'Tu cuenta está desactivada. Contacta al administrador de City Care.',
      );
    }
    if (respuesta.statusCode != 200) {
      return UsuarioSesionStruct(
        exito: false,
        codigoHttp: respuesta.statusCode,
        mensaje: 'No pudimos actualizar tu perfil (error ${respuesta.statusCode}).',
      );
    }
    // Respuesta: {"data": {"firstName", "lastName", "email", "phoneNumber", ...}}.
    final json = jsonDecode(utf8.decode(respuesta.bodyBytes, allowMalformed: true));
    final usuario = json is Map && json['data'] is Map
        ? json['data'] as Map
        : (json is Map ? json : <String, dynamic>{});
    final nombre = '${usuario['firstName'] ?? ''} ${usuario['lastName'] ?? ''}'.trim();
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

// ---------------------------------------------------------------------------
// Casos de prueba contra el servidor simulado (city-care.v1.yaml)
// ---------------------------------------------------------------------------
final jpeg = [0xFF, 0xD8, 0xFF, 0xE0, ...List.filled(2048, 7)];
final png = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, ...List.filled(1024, 3)];
final gif = [0x47, 0x49, 0x46, 0x38, 0x39, 0x61, ...List.filled(512, 1)];
var fallos = 0;

void comprobar(String titulo, bool ok, Object detalle) {
  if (!ok) fallos++;
  print('${ok ? 'OK   ' : 'FALLA'} $titulo\n      -> $detalle');
}

Future<ResultadoEnvioStruct> reporte(
  String url,
  String token, {
  String categoria = 'Bache',
  String descripcion = 'Bache profundo frente a una escuela',
  double lat = 20.67665,
  double lon = -103.34751,
  List<int>? foto,
}) =>
    enviarReporte(url, token, categoria, descripcion, 'Avenida Juárez 120, Guadalajara', lat,
        lon, 12.5, 'gps', FFUploadedFile(name: '1730412345.jpg', bytes: foto ?? jpeg));

Future<void> main() async {
  final servidor = ServidorSimulado()..registro = false;
  await servidor.iniciar();
  final url = 'http://127.0.0.1:${servidor.puerto}/api/v1';
  final caido = 'http://127.0.0.1:1/api/v1';

  print('== Inicio de sesión (POST /auth/login)');
  final login = await iniciarSesionApi(url, ' ciudadano@citycare.com ', 'Ciudadano123!');
  comprobar('L1. Credenciales correctas (correo con espacios)',
      login.exito == true && (login.token ?? '').startsWith('oat_') && login.nombre == 'Ana López' &&
          login.telefono == '3312345678',
      login);
  final token = login.token ?? '';
  var r = await iniciarSesionApi(url, 'ciudadano@citycare.com', 'otra');
  comprobar('L2. Contraseña incorrecta (400)', r.codigoHttp == 400 && r.mensaje == 'Correo o contraseña incorrectos.', r);
  r = await iniciarSesionApi(url, 'inactivo@citycare.com', 'Inactivo123!');
  comprobar('L3. Cuenta desactivada (403)', r.codigoHttp == 403 && (r.mensaje ?? '').contains('desactivada'), r);
  r = await iniciarSesionApi(url, '', 'x');
  comprobar('L4. Correo vacío (422)', r.codigoHttp == 422 && r.mensaje == 'Revisa tu correo y tu contraseña.', r);
  for (var i = 0; i < 5; i++) {
    r = await iniciarSesionApi(url, 'prueba@citycare.com', 'mal$i');
  }
  r = await iniciarSesionApi(url, 'prueba@citycare.com', 'mal6');
  comprobar('L5. Sexto intento en un minuto (429)', r.codigoHttp == 429 && (r.mensaje ?? '').contains('Demasiados intentos'), r);
  r = await iniciarSesionApi(caido, 'ciudadano@citycare.com', 'Ciudadano123!');
  comprobar('L6. Servidor apagado', r.codigoHttp == 0 && r.exito == false, r);
  r = await iniciarSesionApi('$url/', 'ciudadano@citycare.com', 'Ciudadano123!');
  comprobar('L7. URL con diagonal final', r.exito == true, r);

  print('\n== Perfil (GET /account/profile)');
  var p = await obtenerPerfil(url, token);
  comprobar('P1. Token válido', p.exito == true && p.nombre == 'Ana López' && p.correo == 'ciudadano@citycare.com', p);
  p = await obtenerPerfil(url, 'oat_falso');
  comprobar('P2. Token inválido (401)', p.codigoHttp == 401 && (p.mensaje ?? '').contains('sesión venció'), p);
  p = await obtenerPerfil(caido, token);
  comprobar('P3. Servidor apagado', p.codigoHttp == 0, p);

  print('\n== Reportes (POST /reports)');
  var e = await reporte(url, token);
  comprobar('R1. Reporte correcto', e.exito == true && e.folio == 'CC-2026-000001' && e.estado == 'Pendiente', e);
  print('      campos recibidos: ${servidor.ultimosCampos}');
  print('      archivo recibido: ${servidor.ultimoArchivo}');
  e = await reporte(url, token, foto: png);
  comprobar('R2. Foto PNG', e.exito == true && servidor.ultimoArchivo.contains('image/png'), e);
  final admin = await iniciarSesionApi(url, 'admin@citycare.com', 'Admin123!');
  e = await reporte(url, admin.token ?? '');
  comprobar('R3. Cuenta sin permiso para reportar (403 sin cuerpo)', e.codigoHttp == 403 && (e.mensaje ?? '').contains('permiso'), e);
  e = await reporte(url, token, categoria: 'Otro', descripcion: ' ');
  comprobar('R4. Otro sin descripción', e.codigoHttp == 422 && (e.mensaje ?? '').contains('Describe brevemente'), e);
  e = await reporte(url, token, lat: 0, lon: 0);
  comprobar('R5. Coordenadas 0,0', e.codigoHttp == 422 && (e.mensaje ?? '').contains('ubicación no es válida'), e);
  e = await reporte(url, token, foto: gif);
  comprobar('R6. Foto no válida (details.field = foto)', e.codigoHttp == 422 && (e.mensaje ?? '').contains('fotografía no es válida'), e);
  e = await reporte(url, token, categoria: 'Inundación');
  comprobar('R7. Categoría inexistente', e.codigoHttp == 422 && (e.mensaje ?? '').contains('categoría no está disponible'), e);
  e = await reporte(url, 'oat_falso');
  comprobar('R8. Token inválido (401)', e.codigoHttp == 401 && (e.mensaje ?? '').contains('sesión venció'), e);

  print('\n== Categorías del servidor (GET /report-categories)');
  e = await reporte(url, token, categoria: 'alumbrado publico');
  comprobar('C1. Nombre sin acentos se ajusta al catálogo',
      e.exito == true && servidor.ultimosCampos['categoria'] == 'Alumbrado público', e);
  e = await reporte(url, token, categoria: 'ÁRBOL CAÍDO');
  comprobar('C2. Mayúsculas se ajustan al catálogo',
      e.exito == true && servidor.ultimosCampos['categoria'] == 'Árbol caído', e);

  print('\n== Mis reportes (GET /reports)');
  final otra = await iniciarSesionApi(url, 'admin@citycare.com', 'Admin123!');
  var lista = await listarMisReportes(url, token);
  final propios = lista.reportes ?? [];
  comprobar('M1. Lista solo los reportes propios (4), del más reciente al más antiguo',
      lista.exito == true && propios.length == 4 && propios.first.categoria == 'Árbol caído', lista);
  final primero = propios.isEmpty ? ReporteStruct() : propios.last;
  comprobar('M2. Convierte los datos (decimales como texto, fecha, foto)',
      primero.folio == 'CC-2026-000001' && primero.latitud == 20.67665 &&
          primero.estado == 'Pendiente' && primero.fecha != null && primero.tieneFoto == true &&
          primero.idServidor == '1',
      primero);
  servidor.cambiarEstado(1, 'in_progress', 'En proceso');
  lista = await listarMisReportes(url, token);
  comprobar('M3. Estado in_progress se muestra como "En proceso"',
      (lista.reportes ?? []).any((r) => r.idServidor == '1' && r.estado == 'En proceso'), lista);
  lista = await listarMisReportes(url, otra.token ?? '');
  comprobar('M4. Otro usuario no ve reportes ajenos', lista.exito == true && (lista.reportes ?? []).isEmpty, lista);
  for (var i = 0; i < 55; i++) {
    servidor.reportes.add({
      ...servidor.reportes.first,
      'id': 1000 + i,
      'folio': 'CC-2026-00${1000 + i}',
      'creadoEn': '2026-10-01T10:00:00.000Z',
    });
  }
  lista = await listarMisReportes(url, token);
  comprobar('M5. Recorre varias páginas (59 reportes)', (lista.reportes ?? []).length == 59, lista);
  lista = await listarMisReportes(url, 'oat_falso');
  comprobar('M6. Token inválido (401)', lista.codigoHttp == 401 && (lista.mensaje ?? '').contains('sesión venció'), lista);
  lista = await listarMisReportes(caido, token);
  comprobar('M7. Servidor apagado', lista.codigoHttp == 0 && lista.exito == false, lista);

  print('\n== Detalle (GET /reports/:id)');
  var d = await obtenerDetalleReporte(url, token, '1');
  comprobar('D1. Detalle con foto e historial',
      d.exito == true && d.folio == 'CC-2026-000001' && d.estado == 'En proceso' &&
          (d.fotoUrl ?? '').contains('/fotos/1.png') && (d.historial ?? []).length == 2 && (d.historial ?? ['']).first.startsWith('Pendiente') && (d.historial ?? []).last.contains('Cuadrilla asignada'),
      d);
  final foto = await http.get(Uri.parse(d.fotoUrl ?? 'http://127.0.0.1:1'));
  comprobar('D2. La URL de la foto responde', foto.statusCode == 200 && foto.bodyBytes.isNotEmpty, foto.statusCode);
  d = await obtenerDetalleReporte(url, otra.token ?? '', '1');
  comprobar('D3. Reporte ajeno (404)', d.codigoHttp == 404 && (d.mensaje ?? '').contains('ya no está disponible'), d);
  d = await obtenerDetalleReporte(url, token, '');
  comprobar('D4. Sin id no llama al servidor', d.exito == false && d.codigoHttp == 0, d);
  d = await obtenerDetalleReporte(url, 'oat_falso', '1');
  comprobar('D5. Token inválido (401)', d.codigoHttp == 401, d);

  print('\n== Cierre de sesión (POST /account/logout)');
  var cerrado = await cerrarSesionApi(url, token);
  comprobar('O1. Cerrar sesión con token válido', cerrado, cerrado);
  p = await obtenerPerfil(url, token);
  comprobar('O2. El token ya no sirve para el perfil (401)', p.codigoHttp == 401, p);
  e = await reporte(url, token);
  comprobar('O3. El token ya no sirve para reportar (401)', e.codigoHttp == 401, e);
  cerrado = await cerrarSesionApi(url, '');
  comprobar('O4. Sin token no llama al servidor', cerrado, cerrado);
  cerrado = await cerrarSesionApi(caido, 'oat_x');
  comprobar('O5. Servidor apagado (la app cierra sesión de todos modos)', cerrado == false, cerrado);

  await servidor.detener();
  print(fallos == 0 ? '\nTODOS LOS CASOS PASARON' : '\n$fallos CASO(S) FALLARON');
  exit(fallos == 0 ? 0 : 1);
}
