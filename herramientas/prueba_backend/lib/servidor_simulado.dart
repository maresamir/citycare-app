// Servidor simulado de City Care que sigue city-care.v1.yaml:
// login, perfil, logout, categorías, creación de reportes (multipart), Mis
// reportes y detalle (guía de conexión de Miguel), con el formato
// de error {"error": {"code", "message", "details"}} y CORS para la web.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

const categorias = [
  'Bache', 'Alumbrado público', 'Fuga de agua', 'Basura acumulada',
  'Semáforo dañado', 'Banqueta dañada', 'Árbol caído', 'Grafiti o vandalismo', 'Otro',
];

class UsuarioSimulado {
  UsuarioSimulado(this.id, this.email, this.password, this.firstName, this.lastName,
      this.phone, this.rol, this.activo);
  final int id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phone;
  final String rol;
  final bool activo;

  Map<String, Object?> publico() => {
        'id': id,
        'dependencyId': 1,
        'roleId': rol == 'admin' ? 1 : 3,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phone,
        'jobTitle': null,
        'isActive': activo,
        'createdAt': '2026-10-31T18:00:00.000Z',
        'updatedAt': '2026-10-31T18:00:00.000Z',
        'initials': '${firstName[0]}${lastName[0]}',
        'role': {'id': rol == 'admin' ? 1 : 3, 'name': rol, 'slug': rol, 'permissions': <String>[]},
        'dependency': {'id': 1, 'name': 'Ciudadanía', 'isActive': true, 'managers': <Object>[]},
      };
}

class ServidorSimulado {
  final usuarios = [
    UsuarioSimulado(1, 'ciudadano@citycare.com', 'Ciudadano123!', 'Ana', 'López', '3312345678', 'user', true),
    UsuarioSimulado(2, 'inactivo@citycare.com', 'Inactivo123!', 'Luis', 'Pérez', null, 'user', false),
    UsuarioSimulado(3, 'admin@citycare.com', 'Admin123!', 'Carla', 'Ruiz', null, 'admin', true),
  ];
  final tokens = <String, UsuarioSimulado>{};
  final intentos = <String, List<DateTime>>{};
  var siguienteReporte = 1;
  final reportes = <Map<String, Object?>>[];
  var registro = true;
  Map<String, String> ultimosCampos = {};
  String ultimoArchivo = '';
  late HttpServer _http;

  int get puerto => _http.port;

  Future<void> iniciar({int puerto = 0}) async {
    _http = await HttpServer.bind(InternetAddress.loopbackIPv4, puerto);
    _http.listen(_atender);
  }

  Future<void> detener() => _http.close(force: true);

  Future<void> _responder(HttpRequest req, int codigo, [Object? cuerpo]) async {
    req.response.statusCode = codigo;
    if (cuerpo != null) {
      req.response.headers.contentType = ContentType.json;
      req.response.write(jsonEncode(cuerpo));
    }
    if (registro) {
      stdout.writeln('[servidor] ${req.method} ${req.uri.path} -> $codigo');
    }
    await req.response.close();
  }

  Map<String, Object> _error(String code, String message, [List<Map<String, String>>? detalles]) => {
        'error': {
          'code': code,
          'message': message,
          if (detalles != null) 'details': detalles,
        },
      };

  UsuarioSimulado? _usuarioDelToken(HttpRequest req) {
    final h = req.headers.value('authorization') ?? '';
    if (!h.startsWith('Bearer ')) return null;
    return tokens[h.substring(7)];
  }

  Future<void> _atender(HttpRequest req) async {
    req.response.headers
      ..set('Access-Control-Allow-Origin', '*')
      ..set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
      ..set('Access-Control-Allow-Headers', 'Authorization, Content-Type, Accept, ngrok-skip-browser-warning');
    if (req.method == 'OPTIONS') return _responder(req, 204);
    final cuerpo = await req.fold<List<int>>(<int>[], (a, b) => a..addAll(b));
    final ruta = req.uri.path;
    if (ruta.startsWith('/caido')) {
      return _responder(req, 500, _error('E_INTERNAL', 'Internal server error'));
    }
    if (req.method == 'POST' && ruta == '/api/v1/auth/login') return _login(req, cuerpo);
    if (req.method == 'GET' && ruta == '/api/v1/account/profile') {
      final u = _usuarioDelToken(req);
      if (u == null) return _responder(req, 401, _error('E_UNAUTHORIZED_ACCESS', 'Unauthorized access'));
      return _responder(req, 200, {'data': u.publico()});
    }
    if (req.method == 'POST' && ruta == '/api/v1/account/logout') {
      final u = _usuarioDelToken(req);
      if (u == null) return _responder(req, 401, _error('E_UNAUTHORIZED_ACCESS', 'Unauthorized access'));
      tokens.remove((req.headers.value('authorization') ?? '').substring(7));
      return _responder(req, 200, {'message': 'Sesión cerrada'});
    }
    if (req.method == 'POST' && ruta == '/api/v1/reports') return _reporte(req, cuerpo);
    if (req.method == 'GET' && ruta == '/api/v1/report-categories') {
      if (_usuarioDelToken(req) == null) {
        return _responder(req, 401, _error('E_UNAUTHORIZED_ACCESS', 'Unauthorized access'));
      }
      return _responder(req, 200, {
        'data': [
          for (var i = 0; i < categorias.length; i++)
            {
              'id': i + 1,
              'codigo': categorias[i].toLowerCase().replaceAll(' ', '_'),
              'nombre': categorias[i],
              'requiereDescripcion': categorias[i] == 'Otro',
            },
        ],
      });
    }
    if (req.method == 'GET' && ruta == '/api/v1/reports') {
      final u = _usuarioDelToken(req);
      if (u == null) return _responder(req, 401, _error('E_UNAUTHORIZED_ACCESS', 'Unauthorized access'));
      final propios = reportes.where((r) => r['userId'] == u.id).toList().reversed.toList();
      final porPagina = int.tryParse(req.uri.queryParameters['perPage'] ?? '') ?? 20;
      final pagina = int.tryParse(req.uri.queryParameters['page'] ?? '') ?? 1;
      final ultima = propios.isEmpty ? 1 : ((propios.length - 1) ~/ porPagina) + 1;
      final trozo = propios.skip((pagina - 1) * porPagina).take(porPagina);
      return _responder(req, 200, {
        'data': [for (final r in trozo) _publicoReporte(r)],
        'meta': {
          'total': propios.length,
          'perPage': porPagina,
          'currentPage': pagina,
          'lastPage': ultima,
        },
      });
    }
    final detalle = RegExp(r'^/api/v1/reports/(\d+)$').firstMatch(ruta);
    if (req.method == 'GET' && detalle != null) {
      final u = _usuarioDelToken(req);
      if (u == null) return _responder(req, 401, _error('E_UNAUTHORIZED_ACCESS', 'Unauthorized access'));
      final id = int.parse(detalle.group(1)!);
      final r = reportes.where((r) => r['id'] == id && r['userId'] == u.id).firstOrNull;
      if (r == null) return _responder(req, 404, _error('E_ROW_NOT_FOUND', 'Row not found'));
      // Contrato (ReportDetailApiResponse): sin envoltura "data"; historial
      // con estadoNuevoCodigo/estadoNuevo/observacion, el más reciente primero.
      return _responder(req, 200, {
        ..._publicoReporte(r),
        'dependencia': {'id': 1, 'nombre': 'Obras Públicas'},
        'ciudadano': {'id': u.id, 'nombre': '${u.firstName} ${u.lastName}', 'email': u.email},
        'historial': [
          if (r['estadoCodigo'] != 'pending')
            {
              'id': 2,
              'estadoAnteriorCodigo': 'pending',
              'estadoAnterior': 'Pendiente',
              'estadoNuevoCodigo': r['estadoCodigo'],
              'estadoNuevo': r['estado'],
              'origen': 'admin',
              'observacion': 'Cuadrilla asignada',
              'creadoEn': DateTime.parse('${r['creadoEn']}')
                  .add(const Duration(hours: 5))
                  .toIso8601String(),
            },
          {
            'id': 1,
            'estadoAnteriorCodigo': null,
            'estadoAnterior': null,
            'estadoNuevoCodigo': 'pending',
            'estadoNuevo': 'Pendiente',
            'origen': 'ciudadano',
            'observacion': 'Reporte recibido',
            'creadoEn': r['creadoEn'],
          },
        ],
      });
    }
    if (ruta.startsWith('/fotos/')) {
      // Imagen PNG (degradado naranja) que hace de "URL firmada" de MinIO.
      req.response.headers.contentType = ContentType('image', 'png');
      req.response.add(_pngDeEjemplo());
      if (registro) stdout.writeln('[servidor] GET $ruta -> 200');
      return req.response.close();
    }
    return _responder(req, 404, _error('E_ROUTE_NOT_FOUND', 'Cannot ${req.method}:$ruta'));
  }

  Future<void> _login(HttpRequest req, List<int> cuerpo) async {
    Map<String, dynamic> datos = {};
    try {
      datos = jsonDecode(utf8.decode(cuerpo)) as Map<String, dynamic>;
    } catch (_) {}
    final email = '${datos['email'] ?? ''}';
    final password = '${datos['password'] ?? ''}';
    if (email.isEmpty || password.isEmpty) {
      return _responder(req, 422, _error('E_VALIDATION_ERROR', 'Validation failure', [
        if (email.isEmpty) {'field': 'email', 'message': 'The email field must be defined', 'rule': 'required'},
        if (password.isEmpty) {'field': 'password', 'message': 'The password field must be defined', 'rule': 'required'},
      ]));
    }
    // Limitado a 5 intentos por minuto.
    final ahora = DateTime.now();
    final lista = intentos.putIfAbsent(email, () => [])
      ..removeWhere((t) => ahora.difference(t).inSeconds > 60)
      ..add(ahora);
    if (lista.length > 5) {
      return _responder(req, 429, _error('E_TOO_MANY_REQUESTS', 'Too many requests'));
    }
    final u = usuarios.where((u) => u.email == email && u.password == password).firstOrNull;
    if (u == null) {
      return _responder(req, 400, _error('E_INVALID_CREDENTIALS', 'Invalid user credentials'));
    }
    if (!u.activo) {
      return _responder(req, 403, _error('E_ACCOUNT_DISABLED', 'La cuenta está desactivada'));
    }
    final token = 'oat_${Random().nextInt(1 << 32).toRadixString(16)}${Random().nextInt(1 << 32).toRadixString(16)}';
    tokens[token] = u;
    return _responder(req, 200, {
      'data': {'user': u.publico(), 'token': token},
    });
  }

  Future<void> _reporte(HttpRequest req, List<int> cuerpo) async {
    final u = _usuarioDelToken(req);
    if (u == null) return _responder(req, 401, _error('E_UNAUTHORIZED_ACCESS', 'Unauthorized access'));
    if (u.rol == 'admin') return _responder(req, 403);
    final tipo = req.headers.contentType;
    final limite = tipo?.parameters['boundary'];
    if (tipo?.mimeType != 'multipart/form-data' || limite == null) {
      return _responder(req, 422, _error('E_VALIDATION_ERROR', 'Validation failure', [
        {'field': 'foto', 'message': 'Expected multipart/form-data', 'rule': 'file'},
      ]));
    }
    final partes = _partir(cuerpo, limite);
    final campos = <String, String>{
      for (final p in partes.where((p) => p.archivo == null)) p.nombre: utf8.decode(p.datos),
    };
    final archivos = partes.where((p) => p.archivo != null).toList();
    ultimosCampos = campos;
    ultimoArchivo = archivos.isEmpty
        ? '(sin archivo)'
        : '${archivos.first.nombre}: ${archivos.first.archivo} (${archivos.first.tipo}, ${archivos.first.datos.length} bytes)';

    Future<void> invalido(String campo, String mensaje) => _responder(req, 422,
        _error('E_VALIDATION_ERROR', 'Validation failure', [
          {'field': campo, 'message': mensaje, 'rule': 'vine'},
        ]));
    final categoria = campos['categoria'] ?? '';
    if (categoria.length < 2 || categoria.length > 100) return invalido('categoria', 'The categoria field must have at least 2 characters');
    final descripcion = campos['descripcion'];
    if (descripcion != null && descripcion.length > 2000) return invalido('descripcion', 'Too long');
    final direccion = campos['direccion'];
    if (direccion != null && direccion.length > 500) return invalido('direccion', 'Too long');
    final lat = double.tryParse(campos['latitud'] ?? '');
    final lon = double.tryParse(campos['longitud'] ?? '');
    if (lat == null || lat < -90 || lat > 90) return invalido('latitud', 'Out of range');
    if (lon == null || lon < -180 || lon > 180) return invalido('longitud', 'Out of range');
    final precisionTexto = campos['precisionUbicacion'];
    if (precisionTexto != null) {
      final p = double.tryParse(precisionTexto);
      if (p == null || p < 0 || p > 100000) return invalido('precisionUbicacion', 'Out of range');
    }
    final archivo = archivos.where((a) => a.nombre == 'foto').toList();
    if (archivo.isEmpty) return invalido('foto', 'The foto field must be defined');
    final b = archivo.first.datos;
    final esJpg = b.length > 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF;
    final esPng = b.length > 8 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47;
    final extension = (archivo.first.archivo ?? '').split('.').last.toLowerCase();
    if (!(esJpg || esPng) || !['jpg', 'jpeg', 'png'].contains(extension) || b.length > 10 * 1024 * 1024) {
      return invalido('foto', 'Invalid file extension or size');
    }
    if (!categorias.contains(categoria)) {
      return _responder(req, 422, _error('E_REPORT_CATEGORY_INVALID', 'La categoría no existe o está inactiva'));
    }
    if (categoria == 'Otro' && (descripcion ?? '').trim().isEmpty) {
      return _responder(req, 422, _error('E_REPORT_DESCRIPTION_REQUIRED', 'La descripción es obligatoria para Otro'));
    }
    if (lat == 0 && lon == 0) {
      return _responder(req, 422, _error('E_REPORT_LOCATION_INVALID', 'Ubicación 0,0 no permitida'));
    }
    final origen = campos['origenUbicacion'];
    if (origen != 'gps' && origen != 'manual') {
      return _responder(req, 422, _error('E_REPORT_LOCATION_SOURCE_INVALID', 'Origen inválido'));
    }
    final id = siguienteReporte++;
    final nuevo = <String, Object?>{
      'id': id,
      'userId': u.id,
      'folio': 'CC-2026-${id.toString().padLeft(6, '0')}',
      'categoria': categoria,
      'descripcion': descripcion,
      'direccion': direccion,
      // Como MySQL: los decimales viajan como texto.
      'latitud': lat.toStringAsFixed(6),
      'longitud': lon.toStringAsFixed(6),
      'precisionUbicacion': precisionTexto == null ? null : double.parse(precisionTexto),
      'origenUbicacion': origen,
      'estadoCodigo': 'pending',
      'estado': 'Pendiente',
      'estadoEvidencia': 'Pendiente',
      'creadoEn': DateTime.now().toUtc().toIso8601String(),
    };
    reportes.add(nuevo);
    // Contrato (ReportPublic): el reporte creado viene sin envoltura "data".
    return _responder(req, 201, _publicoReporte(nuevo));
  }

  Map<String, Object?> _publicoReporte(Map<String, Object?> r) => {
        for (final e in r.entries)
          if (e.key != 'userId') e.key: e.value,
        'categoriaId': categorias.indexOf('${r['categoria']}') + 1,
        'categoriaCodigo': '${r['categoria']}'.toLowerCase().replaceAll(' ', '_'),
        'fotoUrl': 'http://127.0.0.1:$puerto/fotos/${r['id']}.png?firma=temporal',
        'fotoUrlExpira': true,
        'actualizadoEn': r['creadoEn'],
      };

  /// Cambia el estado de un reporte, como lo haría un administrador.
  void cambiarEstado(int id, String codigo, String etiqueta) {
    final r = reportes.firstWhere((r) => r['id'] == id);
    r['estadoCodigo'] = codigo;
    r['estado'] = etiqueta;
  }
}

/// PNG de 160x100 con un degradado, armado a mano (sin dependencias).
List<int> _pngDeEjemplo() {
  const ancho = 160, alto = 100;
  final pixeles = <int>[];
  for (var y = 0; y < alto; y++) {
    pixeles.add(0);
    for (var x = 0; x < ancho; x++) {
      pixeles.addAll([255, 120 + 100 * x ~/ ancho, 40 + 150 * y ~/ alto]);
    }
  }
  int crc(List<int> datos) {
    var c = 0xFFFFFFFF;
    for (final b in datos) {
      c ^= b;
      for (var k = 0; k < 8; k++) {
        c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
      }
    }
    return c ^ 0xFFFFFFFF;
  }

  List<int> entero(int n) => [n >> 24 & 255, n >> 16 & 255, n >> 8 & 255, n & 255];
  List<int> bloque(String tipo, List<int> datos) {
    final cuerpo = [...ascii.encode(tipo), ...datos];
    return [...entero(datos.length), ...cuerpo, ...entero(crc(cuerpo))];
  }

  return [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    ...bloque('IHDR', [...entero(ancho), ...entero(alto), 8, 2, 0, 0, 0]),
    ...bloque('IDAT', ZLibCodec().encode(pixeles)),
    ...bloque('IEND', []),
  ];
}

class Parte {
  Parte(this.nombre, this.archivo, this.tipo, this.datos);
  final String nombre;
  final String? archivo;
  final String? tipo;
  final List<int> datos;
}

List<Parte> _partir(List<int> cuerpo, String limite) {
  final partes = <Parte>[];
  final texto = latin1.decode(cuerpo);
  for (final trozo in texto.split('--$limite')) {
    if (trozo.trim().isEmpty || trozo.trim() == '--') continue;
    final corte = trozo.indexOf('\r\n\r\n');
    if (corte < 0) continue;
    final cabeceras = trozo.substring(0, corte);
    var contenido = trozo.substring(corte + 4);
    if (contenido.endsWith('\r\n')) contenido = contenido.substring(0, contenido.length - 2);
    final nombre = RegExp(r'name="([^"]*)"').firstMatch(cabeceras)?.group(1) ?? '';
    final archivo = RegExp(r'filename="([^"]*)"').firstMatch(cabeceras)?.group(1);
    final tipo = RegExp(r'content-type:\s*([^\r\n]+)', caseSensitive: false).firstMatch(cabeceras)?.group(1);
    partes.add(Parte(nombre, archivo, tipo, latin1.encode(contenido)));
  }
  return partes;
}
