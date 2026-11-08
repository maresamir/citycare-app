library;

import 'dart:io';

import 'package:flutterflow_ai/flutterflow_ai.dart';

Future<void> main(List<String> args) async {
  if (Platform.environment['_FF_AI_DSL_LAUNCHER'] != '1') {
    stdout.writeln(
      'Tip: run this through `flutterflow ai run` (validated, faster)',
    );
  }
  final options = _parseCliOptions(args);
  try {
    await flutterFlowAI(
      buildCityCare,
      apiKey: options.apiKey,
      baseUrl: options.baseUrl,
      projectName: options.projectName,
      projectId: options.projectId,
      findOrCreate: options.findOrCreate,
      allowNewProject: options.allowNewProject,
      dryRun: options.dryRun,
      commitMessage: options.commitMessage,
    );
  } catch (error, stackTrace) {
    stderr.writeln('Error: ${formatFlutterFlowAIError(error, stackTrace: stackTrace)}');
    exit(1);
  }
}

final class _CliOptions {
  const _CliOptions({
    this.apiKey,
    this.baseUrl,
    this.projectName,
    this.projectId,
    this.findOrCreate = false,
    this.allowNewProject = false,
    this.dryRun = false,
    this.commitMessage,
  });

  final String? apiKey;
  final String? baseUrl;
  final String? projectName;
  final String? projectId;
  final bool findOrCreate;
  final bool allowNewProject;
  final bool dryRun;
  final String? commitMessage;
}

_CliOptions _parseCliOptions(List<String> args) {
  String? apiKey;
  String? baseUrl;
  String? projectName;
  String? projectId;
  String? commitMessage;
  var findOrCreate = false;
  var allowNewProject = false;
  var dryRun = false;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    switch (arg) {
      case '--help':
      case '-h':
        _printUsage();
        exit(0);
      case '--api-key':
        apiKey = _requireValue(args, ++i, '--api-key');
      case '--base-url':
        baseUrl = _requireValue(args, ++i, '--base-url');
      case '--project-name':
        projectName = _requireValue(args, ++i, '--project-name');
      case '--project-id':
        projectId = _requireValue(args, ++i, '--project-id');
      case '--commit-message':
        commitMessage = _requireValue(args, ++i, '--commit-message');
      case '--find-or-create':
        findOrCreate = true;
      case '--allow-new-project':
        allowNewProject = true;
      case '--dry-run':
        dryRun = true;
      default:
        stderr.writeln('Unknown option: $arg');
        _printUsage();
        exit(64);
    }
  }

  return _CliOptions(
    apiKey: apiKey,
    baseUrl: baseUrl,
    projectName: projectName,
    projectId: projectId,
    findOrCreate: findOrCreate,
    allowNewProject: allowNewProject,
    dryRun: dryRun,
    commitMessage: commitMessage,
  );
}

String _requireValue(List<String> args, int index, String flag) {
  if (index >= args.length) {
    stderr.writeln('Missing value for $flag.');
    _printUsage();
    exit(64);
  }
  return args[index];
}

void _printUsage() {
  stdout.writeln('''
Run the starter FlutterFlow AI create flow.

Usage:
  flutterflow ai validate dsl/create.dart [options]
  flutterflow ai run dsl/create.dart [options]

Options:
  --api-key <key>           FlutterFlow API key. Defaults to FF_API_KEY.
  --base-url <url>          Override the FlutterFlow API base URL.
  --project-name <name>     Create a new project with this name.
  --project-id <id>         Push into an existing project by ID.
  --find-or-create          Retry by reusing a same-name project before creating.
  --allow-new-project       Bypass the workspace binding guard and create a different project.
  --commit-message <text>   Commit message for the push.
  --dry-run                 Compile and validate without pushing.
  --help, -h                Show this help.
''');
}


// ---------------------------------------------------------------------------
// CityCare — registro y seguimiento de incidencias urbanas (Guadalajara).
// Versión funcional sin backend: la sesión y los reportes viven en App State
// (persistido) hasta conectar el backend del equipo.
// ---------------------------------------------------------------------------

const _categorias = <(String, String)>[
  ('Bache', 'construction'),
  ('Alumbrado público', 'lightbulb'),
  ('Fuga de agua', 'water_drop'),
  ('Basura acumulada', 'delete'),
  ('Semáforo dañado', 'traffic'),
  ('Banqueta dañada', 'directions_walk'),
  ('Árbol caído', 'park'),
  ('Grafiti o vandalismo', 'format_paint'),
  ('Otro', 'report_problem'),
];

// (estado, color del texto, color de fondo)
const _estados = <(String, int, int)>[
  ('Pendiente', 0xFFEF4444, 0xFFFEE2E2),
  ('En proceso', 0xFFD97706, 0xFFFEF3C7),
  ('Resuelto', 0xFF059669, 0xFFD1FAE5),
];

final _blanco = Colors.secondaryBackground;
final _sombraTarjeta = Shadow(blur: 12, dy: 4, color: Colors.hex(0x0F000000));

/// Fondo naranja con solo las esquinas inferiores redondeadas: una franja
/// recta tapa las esquinas superiores del contenedor redondeado.
DslWidget _fondoNaranja(DslWidget contenido, {double radio = 28}) => Stack(
  alignment: Alignment.topCenter,
  children: [
    Container(width: double.infinity, height: radio * 2, color: Colors.primary),
    contenido,
  ],
);

/// Encabezado naranja con esquinas inferiores redondeadas.
DslWidget _encabezado(String titulo, String subtitulo, {DslWidget? accion}) =>
    _fondoNaranja(Container(
      width: double.infinity,
      color: Colors.primary,
      borderRadius: 28,
      padding: EdgeInsets.only(left: 24, right: 24, top: 28, bottom: 28),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            Column(
              crossAxis: CrossAxis.start,
              spacing: 4,
              children: [
                Text(titulo, style: Styles.headlineSmall, color: _blanco),
                Text(
                  subtitulo,
                  style: Styles.bodyMedium,
                  color: Colors.hex(0xE6FFFFFF),
                ),
              ],
            ),
          ),
          if (accion != null) accion,
        ],
      ),
    ));

/// Botón circular translúcido para los encabezados.
DslWidget _botonEncabezado(String icono, Object accion) => IconButton(
  icono,
  size: 24,
  color: _blanco,
  fillColor: Colors.hex(0x33FFFFFF),
  borderRadius: 999,
  onTap: accion,
);

/// Título numerado de sección del formulario de reporte.
DslWidget _tituloPaso(String titulo, String ayuda) => Column(
  crossAxis: CrossAxis.start,
  spacing: 2,
  children: [
    Text(titulo, style: Styles.titleMedium),
    Text(ayuda, style: Styles.bodySmall, color: Colors.secondaryText),
  ],
);

/// Chip de filtro (relleno si está activo, contorno si no).
DslWidget _chipFiltro(String valor) => Container(
  onTap: SetState('filtro', valor),
  child: Stack(
    children: [
      Container(
        visible: Equals(State('filtro'), valor),
        color: Colors.primary,
        borderRadius: 999,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(valor, style: Styles.titleSmall, color: _blanco),
      ),
      Container(
        visible: Not(Equals(State('filtro'), valor)),
        color: _blanco,
        borderColor: Colors.primary,
        borderWidth: 1,
        borderRadius: 999,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(valor, style: Styles.titleSmall, color: Colors.primary),
      ),
    ],
  ),
);

/// Tarjeta de estadística (número + etiqueta).
DslWidget _estadistica(Object valor, String etiqueta, ColorToken color) =>
    Expanded(
      Container(
        color: _blanco,
        borderRadius: 16,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        shadow: _sombraTarjeta,
        child: Column(
          spacing: 2,
          children: [
            Text(valor, style: Styles.headlineSmall, color: color),
            Text(
              etiqueta,
              style: Styles.labelMedium,
              color: Colors.secondaryText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

/// Icono con fondo naranja claro.
DslWidget _iconoSuave(String icono, {double tamano = 48}) => Container(
  width: tamano,
  height: tamano,
  borderRadius: 14,
  color: Colors.accent1,
  alignment: Alignment.center,
  child: Icon(icono, size: 24, color: Colors.primary),
);

/// Fila de menú con icono, título, subtítulo y flecha.
DslWidget _opcionMenu(String icono, String titulo, String subtitulo, Object accion) =>
    Container(
      onTap: accion,
      color: _blanco,
      borderRadius: 18,
      padding: 14,
      shadow: _sombraTarjeta,
      child: Row(
        spacing: 14,
        children: [
          _iconoSuave(icono),
          Expanded(
            Column(
              crossAxis: CrossAxis.start,
              spacing: 2,
              children: [
                Text(titulo, style: Styles.titleSmall),
                Text(
                  subtitulo,
                  style: Styles.bodySmall,
                  color: Colors.secondaryText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon('chevron_right', size: 22, color: Colors.secondaryText),
        ],
      ),
    );

void buildCityCare(App app) {
  // -------------------------------------------------------------------------
  // Tema (colores del PDF de referencia)
  // -------------------------------------------------------------------------
  app.themeColor('primary', 0xFFFF7900);
  app.themeColor('secondary', 0xFFFF9A3D);
  app.themeColor('tertiary', 0xFF1E293B);
  app.themeColor('alternate', 0xFFE2E8F0);
  app.themeColor('primaryBackground', 0xFFF8F9FA);
  app.themeColor('secondaryBackground', 0xFFFFFFFF);
  app.themeColor('primaryText', 0xFF1A1A1E);
  app.themeColor('secondaryText', 0xFF64748B);
  app.themeColor('accent1', 0xFFFFEFD6);
  app.themeColor('accent2', 0xFFFFF1E5);
  app.themeColor('success', 0xFF10B981);
  app.themeColor('warning', 0xFFF59E0B);
  app.themeColor('error', 0xFFEF4444);
  app.themeColor('info', 0xFF3B82F6);
  app.primaryFont('Plus Jakarta Sans');
  app.typography('headlineMedium', fontSize: 30, fontWeight: 800);
  app.typography('headlineSmall', fontSize: 24, fontWeight: 700);
  app.typography('titleLarge', fontSize: 20, fontWeight: 700);
  app.typography('titleMedium', fontSize: 17, fontWeight: 600);
  app.typography('titleSmall', fontSize: 15, fontWeight: 600);
  app.typography('bodyMedium', fontSize: 14, fontWeight: 400, lineHeight: 1.43);

  // -------------------------------------------------------------------------
  // Tipos de datos
  // -------------------------------------------------------------------------
  final reporte = app.struct('Reporte', {
    'categoria': string,
    'descripcion': string,
    'direccion': string,
    'latitud': double_,
    'longitud': double_,
    'estado': string,
    'fecha': dateTime,
    'tieneFoto': bool_,
  });
  final direccionOsm = app.struct('DireccionOSM', {'display_name': string});
  final noticia = app.struct('Noticia', {
    'title': string,
    'pubDate': string,
    'link': string,
    'author': string,
    'description': string,
  });
  final respuestaNoticias = app.struct('RespuestaNoticias', {
    'status': string,
    'items': listOf(noticia),
  });

  // -------------------------------------------------------------------------
  // App State (persistido en el dispositivo hasta conectar el backend)
  // -------------------------------------------------------------------------
  app.state('sesionIniciada', bool_, persisted: true);
  app.state('usuarioNombre', string, persisted: true);
  app.state('usuarioCorreo', string, persisted: true);
  app.state('usuarioTelefono', string, persisted: true);
  app.state(
    'usuarioColonia',
    string.withDefault('Guadalajara'),
    persisted: true,
  );
  app.state('notificaciones', bool_.withDefault(true), persisted: true);
  app.state('reportes', listOf(reporte), persisted: true);

  // -------------------------------------------------------------------------
  // APIs gratuitas (sin llave)
  // -------------------------------------------------------------------------
  // A4 · Geolocalización: OpenStreetMap Nominatim convierte lat/lon en
  // dirección. La posición la da el GPS del dispositivo.
  final geocodificar = Endpoint.get(
    'DireccionDesdeCoordenadas',
    'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=[lat]&lon=[lon]&zoom=18&accept-language=es',
    variables: {'lat': double_, 'lon': double_},
    response: direccionOsm,
  );
  app.api(geocodificar);

  // Noticias de Guadalajara: RSS de El Informador convertido a JSON con
  // rss2json (plan gratuito, sin llave).
  final obtenerNoticias = Endpoint.get(
    'NoticiasGuadalajara',
    'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.informador.mx%2Frss%2Fjalisco.xml',
    response: respuestaNoticias,
  );
  app.api(obtenerNoticias);

  // -------------------------------------------------------------------------
  // Funciones personalizadas
  // -------------------------------------------------------------------------
  final latitudDe = app.customFunction(
    'latitudDe',
    args: {'ubicacion': latLng},
    returns: double_,
    code: r'return ubicacion?.latitude ?? 0.0;',
    description: 'Latitud de una coordenada.',
  );
  final longitudDe = app.customFunction(
    'longitudDe',
    args: {'ubicacion': latLng},
    returns: double_,
    code: r'return ubicacion?.longitude ?? 0.0;',
    description: 'Longitud de una coordenada.',
  );
  final textoCoordenadas = app.customFunction(
    'textoCoordenadas',
    args: {'lat': double_, 'lon': double_},
    returns: string,
    code: r'''
final la = lat ?? 0.0;
final lo = lon ?? 0.0;
return '${la.toStringAsFixed(5)}, ${lo.toStringAsFixed(5)}';
''',
    description: 'Formatea latitud y longitud para mostrarlas.',
  );
  final urlMapa = app.customFunction(
    'urlMapa',
    args: {'lat': double_, 'lon': double_},
    returns: string,
    code: r'''
final la = lat ?? 0.0;
final lo = lon ?? 0.0;
return 'https://www.openstreetmap.org/?mlat=$la&mlon=$lo#map=18/$la/$lo';
''',
    description: 'Enlace a OpenStreetMap centrado en el reporte.',
  );
  final formatearFecha = app.customFunction(
    'formatearFecha',
    args: {'fecha': dateTime},
    returns: string,
    code: r'''
if (fecha == null) return '';
const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
final h = fecha.hour.toString().padLeft(2, '0');
final m = fecha.minute.toString().padLeft(2, '0');
return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}, $h:$m';
''',
    description: 'Fecha legible en español (31 oct 2026, 10:30).',
  );
  final fechaNoticia = app.customFunction(
    'fechaNoticia',
    args: {'pubDate': string},
    returns: string,
    code: r'''
final fecha = DateTime.tryParse(pubDate ?? '');
if (fecha == null) return pubDate ?? '';
const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
final h = fecha.hour.toString().padLeft(2, '0');
final m = fecha.minute.toString().padLeft(2, '0');
return '${fecha.day} ${meses[fecha.month - 1]} · $h:$m';
''',
    description: 'Fecha corta para las noticias.',
  );
  final iniciales = app.customFunction(
    'iniciales',
    args: {'nombre': string},
    returns: string,
    code: r'''
final partes = (nombre ?? '').trim().split(' ').where((p) => p.isNotEmpty).toList();
if (partes.isEmpty) return 'CC';
if (partes.length == 1) return partes.first[0].toUpperCase();
return (partes[0][0] + partes[1][0]).toUpperCase();
''',
    description: 'Iniciales para el avatar.',
  );
  final saludo = app.customFunction(
    'saludo',
    args: {'nombre': string},
    returns: string,
    code: r'''
final partes = (nombre ?? '').trim().split(' ');
final primero = partes.isEmpty || partes.first.isEmpty ? 'vecino' : partes.first;
return 'Hola, $primero';
''',
    description: 'Saludo con el primer nombre del usuario.',
  );
  final contarPorEstado = app.customFunction(
    'contarPorEstado',
    args: {'reportes': listOf(reporte), 'estado': string},
    returns: string,
    code: r'''
final lista = reportes ?? [];
if (estado == null || estado == 'Todos') return lista.length.toString();
return lista.where((r) => r.estado == estado).length.toString();
''',
    description: 'Cuenta los reportes con un estado (o todos).',
  );
  final ultimosReportes = app.customFunction(
    'ultimosReportes',
    args: {'reportes': listOf(reporte), 'cantidad': int_},
    returns: listOf(reporte),
    code: r'''
final lista = reportes ?? [];
return lista.take(cantidad ?? 3).toList();
''',
    description: 'Los reportes más recientes para el inicio.',
  );
  final filtrarReportes = app.customFunction(
    'filtrarReportes',
    args: {'reportes': listOf(reporte), 'estado': string},
    returns: listOf(reporte),
    code: r'''
final lista = reportes ?? [];
if (estado == null || estado == 'Todos') return lista;
return lista.where((r) => r.estado == estado).toList();
''',
    description: 'Reportes filtrados por estado (Todos devuelve la lista completa).',
  );

  // -------------------------------------------------------------------------
  // Componentes
  // -------------------------------------------------------------------------
  final dynamic tarjetaReporte = app.component(
    'TarjetaReporte',
    description: 'Resumen de un reporte con icono de categoría y estado.',
    params: {
      'categoria': string.withDefault('Otro'),
      'direccion': string.withDefault(''),
      'fecha': string.withDefault(''),
      'estado': string.withDefault('Pendiente'),
      'alTocar': action,
    },
    body: Container(
      onTap: ParamAction('alTocar'),
      color: _blanco,
      borderRadius: 18,
      padding: 14,
      shadow: _sombraTarjeta,
      child: Row(
        spacing: 14,
        children: [
          Container(
            width: 52,
            height: 52,
            borderRadius: 14,
            color: Colors.accent1,
            alignment: Alignment.center,
            child: Stack(
              children: [
                for (final (nombre, icono) in _categorias)
                  Icon(
                    icono,
                    size: 26,
                    color: Colors.primary,
                    visible: Equals(Param('categoria'), nombre),
                  ),
              ],
            ),
          ),
          Expanded(
            Column(
              crossAxis: CrossAxis.start,
              spacing: 3,
              children: [
                Text(
                  Param('categoria'),
                  style: Styles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Param('direccion'),
                  style: Styles.bodySmall,
                  color: Colors.secondaryText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Param('fecha'),
                  style: Styles.labelSmall,
                  color: Colors.secondaryText,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              for (final (estado, texto, fondo) in _estados)
                Container(
                  visible: Equals(Param('estado'), estado),
                  color: Colors.hex(fondo),
                  borderRadius: 999,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    estado,
                    style: Styles.labelSmall,
                    color: Colors.hex(texto),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );

  final dynamic tarjetaNoticia = app.component(
    'TarjetaNoticia',
    description: 'Noticia de Guadalajara; al tocarla abre la nota completa.',
    params: {
      'titulo': string.withDefault(''),
      'resumen': string.withDefault(''),
      'autor': string.withDefault(''),
      'fecha': string.withDefault(''),
      'enlace': string.withDefault('https://www.informador.mx/jalisco'),
    },
    body: Container(
      onTap: LaunchUrl(Param('enlace')),
      color: _blanco,
      borderRadius: 18,
      padding: 16,
      shadow: _sombraTarjeta,
      child: Column(
        crossAxis: CrossAxis.start,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                color: Colors.accent1,
                borderRadius: 999,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  'Jalisco',
                  style: Styles.labelSmall,
                  color: Colors.primary,
                ),
              ),
              Text(
                Param('fecha'),
                style: Styles.labelSmall,
                color: Colors.secondaryText,
              ),
            ],
          ),
          Text(
            Param('titulo'),
            style: Styles.titleSmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            Param('resumen'),
            style: Styles.bodySmall,
            color: Colors.secondaryText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            spacing: 4,
            children: [
              Expanded(
                Text(
                  Param('autor'),
                  style: Styles.labelSmall,
                  color: Colors.secondaryText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('Leer nota', style: Styles.titleSmall, color: Colors.primary),
              Icon('arrow_forward', size: 16, color: Colors.primary),
            ],
          ),
        ],
      ),
    ),
  );

  // -------------------------------------------------------------------------
  // Páginas (se refieren entre sí por nombre)
  // -------------------------------------------------------------------------
  const inicio = 'Inicio';
  const login = 'IniciarSesion';
  const registro = 'Registro';
  const recuperar = 'RecuperarContrasena';
  const crearReporte = 'Reportar';
  const misReportes = 'MisReportes';
  const detalle = 'DetalleReporte';
  const noticias = 'Noticias';
  const perfil = 'Perfil';

  // Navegación al detalle desde cualquier lista de reportes.
  DslAction verDetalle(dynamic item) => Navigate(
    detalle,
    params: {
      'categoria': item['categoria'],
      'descripcion': item['descripcion'],
      'direccion': item['direccion'],
      'estado': item['estado'],
      'fecha': CustomFunction(formatearFecha, args: {'fecha': item['fecha']}),
      'latitud': item['latitud'],
      'longitud': item['longitud'],
    },
  );

  // ---- 1. Login -----------------------------------------------------------
  app.page(
    login,
    route: '/iniciar-sesion',
    isInitial: true,
    description: 'Inicio de sesión (simulado hasta conectar el backend).',
    onLoad: [
      If(AppState('sesionIniciada'), then: [Navigate(inicio)]),
    ],
    body: Scaffold(
      body: Column(
        scrollable: true,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(width: double.infinity, height: 80, color: Colors.primary),
              Container(
                width: double.infinity,
                height: 330,
                color: Colors.primary,
                borderRadius: 40,
              ),
              Column(
                padding: EdgeInsets.only(left: 20, right: 20, top: 48),
                spacing: 12,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    borderRadius: 24,
                    color: _blanco,
                    alignment: Alignment.center,
                    shadow: _sombraTarjeta,
                    child: Icon('location_city', size: 44, color: Colors.primary),
                  ),
                  Text('CityCare', style: Styles.headlineMedium, color: _blanco),
                  Text(
                    'Cuidando nuestra ciudad juntos',
                    style: Styles.bodyMedium,
                    color: Colors.hex(0xE6FFFFFF),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 24),
                    color: _blanco,
                    borderRadius: 24,
                    padding: 24,
                    shadow: Shadow(blur: 24, dy: 8, color: Colors.hex(0x1A000000)),
                    child: Form(
                      name: 'formLogin',
                      child: Column(
                        crossAxis: CrossAxis.stretch,
                        spacing: 16,
                        children: [
                          Column(
                            crossAxis: CrossAxis.start,
                            spacing: 4,
                            children: [
                              Text('Bienvenido', style: Styles.headlineSmall),
                              Text(
                                'Inicia sesión para continuar',
                                style: Styles.bodyMedium,
                                color: Colors.secondaryText,
                              ),
                            ],
                          ),
                          TextField(
                            name: 'campoCorreo',
                            label: 'Correo electrónico',
                            hint: 'ejemplo@correo.com',
                            prefixIcon: 'mail_outline',
                            keyboard: Keyboard.email,
                            required: true,
                            requiredMessage: 'Escribe tu correo',
                            email: true,
                            emailMessage: 'Escribe un correo válido',
                          ),
                          TextField(
                            name: 'campoContrasena',
                            label: 'Contraseña',
                            hint: '••••••••',
                            prefixIcon: 'lock_outline',
                            obscureText: true,
                            required: true,
                            requiredMessage: 'Escribe tu contraseña',
                            minLength: 6,
                            minLengthMessage: 'Mínimo 6 caracteres',
                          ),
                          Row(
                            mainAxis: MainAxis.end,
                            children: [
                              Container(
                                onTap: Navigate(recuperar),
                                child: Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: Styles.titleSmall,
                                  color: Colors.primary,
                                ),
                              ),
                            ],
                          ),
                          Button(
                            'Iniciar sesión',
                            name: 'botonIniciarSesion',
                            width: double.infinity,
                            height: 52,
                            color: Colors.primary,
                            textColor: _blanco,
                            borderRadius: 14,
                            onTap: [
                              ValidateForm('formLogin'),
                              // TODO backend: reemplazar por la llamada de login.
                              UpdateAppState.set(
                                'usuarioCorreo',
                                WidgetState('campoCorreo', WidgetStateProperty.text),
                              ),
                              If(
                                Equals(AppState('usuarioNombre'), ''),
                                then: [UpdateAppState.set('usuarioNombre', 'Ciudadano')],
                              ),
                              UpdateAppState.set('sesionIniciada', true),
                              Navigate(inicio),
                            ],
                          ),
                          Row(
                            spacing: 12,
                            children: [
                              Expanded(Divider()),
                              Text('o', style: Styles.bodySmall, color: Colors.secondaryText),
                              Expanded(Divider()),
                            ],
                          ),
                          Button(
                            'Continuar con Google',
                            variant: ButtonVariant.outlined,
                            icon: 'account_circle',
                            width: double.infinity,
                            height: 50,
                            borderRadius: 14,
                            onTap: Snackbar(
                              'El acceso con Google se activará al conectar el backend.',
                            ),
                          ),
                          Row(
                            mainAxis: MainAxis.center,
                            spacing: 6,
                            children: [
                              Text(
                                '¿No tienes una cuenta?',
                                style: Styles.bodyMedium,
                                color: Colors.secondaryText,
                              ),
                              Container(
                                onTap: Navigate(registro),
                                child: Text(
                                  'Regístrate',
                                  style: Styles.titleSmall,
                                  color: Colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Al continuar, aceptas nuestros Términos y Condiciones',
                      style: Styles.bodySmall,
                      color: Colors.secondaryText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );

  // ---- 2. Crear cuenta ----------------------------------------------------
  app.page(
    registro,
    route: '/registro',
    description: 'Registro de nuevo ciudadano (simulado hasta conectar el backend).',
    state: {'aceptaTerminos': bool_.withDefault(false)},
    body: Scaffold(
      body: Column(
        children: [
          _encabezado(
            'Crear cuenta',
            'Únete y mejora tu colonia',
            accion: _botonEncabezado('arrow_back', NavigateBack()),
          ),
          Expanded(
            Column(
              scrollable: true,
              padding: 20,
              children: [
                Container(
                  color: _blanco,
                  borderRadius: 24,
                  padding: 22,
                  shadow: _sombraTarjeta,
                  child: Form(
                    name: 'formRegistro',
                    child: Column(
                      crossAxis: CrossAxis.stretch,
                      spacing: 14,
                      children: [
                        TextField(
                          name: 'campoNombre',
                          label: 'Nombre completo',
                          hint: 'Ej. Juan Delgado',
                          prefixIcon: 'person_outline',
                          required: true,
                          requiredMessage: 'Escribe tu nombre',
                          minLength: 3,
                          minLengthMessage: 'Escribe tu nombre completo',
                        ),
                        TextField(
                          name: 'campoCorreoRegistro',
                          label: 'Correo electrónico',
                          hint: 'ejemplo@correo.com',
                          prefixIcon: 'mail_outline',
                          keyboard: Keyboard.email,
                          required: true,
                          requiredMessage: 'Escribe tu correo',
                          email: true,
                          emailMessage: 'Escribe un correo válido',
                        ),
                        TextField(
                          name: 'campoTelefono',
                          label: 'Teléfono',
                          hint: '33 1234 5678',
                          prefixIcon: 'phone',
                          keyboard: Keyboard.number,
                          minLength: 10,
                          minLengthMessage: 'El teléfono debe tener 10 dígitos',
                        ),
                        TextField(
                          name: 'campoContrasenaRegistro',
                          label: 'Contraseña',
                          hint: 'Mínimo 6 caracteres',
                          prefixIcon: 'lock_outline',
                          obscureText: true,
                          required: true,
                          requiredMessage: 'Crea una contraseña',
                          minLength: 6,
                          minLengthMessage: 'Mínimo 6 caracteres',
                        ),
                        TextField(
                          name: 'campoConfirmar',
                          label: 'Confirmar contraseña',
                          hint: 'Repite tu contraseña',
                          prefixIcon: 'lock_outline',
                          obscureText: true,
                          required: true,
                          requiredMessage: 'Confirma tu contraseña',
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            Checkbox(
                              value: State('aceptaTerminos'),
                              onChanged: SetState('aceptaTerminos', WidgetValue()),
                            ),
                            Expanded(
                              Text(
                                'Acepto los Términos y el Aviso de Privacidad',
                                style: Styles.bodySmall,
                                color: Colors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        Button(
                          'Crear cuenta',
                          name: 'botonCrearCuenta',
                          width: double.infinity,
                          height: 52,
                          color: Colors.primary,
                          textColor: _blanco,
                          borderRadius: 14,
                          onTap: [
                            ValidateForm('formRegistro'),
                            If(
                              Not(State('aceptaTerminos')),
                              then: [Snackbar('Debes aceptar los términos para continuar')],
                              orElse: [
                                If(
                                  Equals(
                                    WidgetState('campoContrasenaRegistro', WidgetStateProperty.text),
                                    WidgetState('campoConfirmar', WidgetStateProperty.text),
                                  ),
                                  then: [
                                    // TODO backend: reemplazar por la llamada de registro.
                                    UpdateAppState.set(
                                      'usuarioNombre',
                                      WidgetState('campoNombre', WidgetStateProperty.text),
                                    ),
                                    UpdateAppState.set(
                                      'usuarioCorreo',
                                      WidgetState('campoCorreoRegistro', WidgetStateProperty.text),
                                    ),
                                    UpdateAppState.set(
                                      'usuarioTelefono',
                                      WidgetState('campoTelefono', WidgetStateProperty.text),
                                    ),
                                    UpdateAppState.set('sesionIniciada', true),
                                    Snackbar('¡Bienvenido a CityCare!'),
                                    Navigate(inicio),
                                  ],
                                  orElse: [Snackbar('Las contraseñas no coinciden')],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxis: MainAxis.center,
                          spacing: 6,
                          children: [
                            Text(
                              '¿Ya tienes cuenta?',
                              style: Styles.bodyMedium,
                              color: Colors.secondaryText,
                            ),
                            Container(
                              onTap: NavigateBack(),
                              child: Text(
                                'Inicia sesión',
                                style: Styles.titleSmall,
                                color: Colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  // ---- Recuperar contraseña ----------------------------------------------
  app.page(
    recuperar,
    route: '/recuperar',
    description: 'Solicitud de enlace para restablecer la contraseña.',
    body: Scaffold(
      body: Column(
        children: [
          _encabezado(
            'Recuperar acceso',
            'Te enviaremos un enlace a tu correo',
            accion: _botonEncabezado('arrow_back', NavigateBack()),
          ),
          Container(
            padding: 20,
            child: Container(
              color: _blanco,
              borderRadius: 24,
              padding: 22,
              shadow: _sombraTarjeta,
              child: Form(
                name: 'formRecuperar',
                child: Column(
                  crossAxis: CrossAxis.stretch,
                  spacing: 16,
                  children: [
                    Text(
                      'Escribe el correo con el que te registraste.',
                      style: Styles.bodyMedium,
                      color: Colors.secondaryText,
                    ),
                    TextField(
                      name: 'campoCorreoRecuperar',
                      label: 'Correo electrónico',
                      hint: 'ejemplo@correo.com',
                      prefixIcon: 'mail_outline',
                      keyboard: Keyboard.email,
                      required: true,
                      requiredMessage: 'Escribe tu correo',
                      email: true,
                      emailMessage: 'Escribe un correo válido',
                    ),
                    Button(
                      'Enviar enlace',
                      width: double.infinity,
                      height: 52,
                      color: Colors.primary,
                      textColor: _blanco,
                      borderRadius: 14,
                      onTap: [
                        ValidateForm('formRecuperar'),
                        // TODO backend: llamar al endpoint de recuperación.
                        Snackbar('Si el correo está registrado, recibirás un enlace.'),
                        NavigateBack(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // ---- 3. Inicio ----------------------------------------------------------
  DslWidget accesoRapido(String titulo, String icono, String destino) => Expanded(
    Container(
      onTap: Navigate(destino),
      color: _blanco,
      borderRadius: 18,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      shadow: _sombraTarjeta,
      child: Column(
        spacing: 8,
        children: [
          _iconoSuave(icono, tamano: 46),
          Text(
            titulo,
            style: Styles.titleSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );

  final inicioPage = app.page(
    inicio,
    route: '/inicio',
    description: 'Inicio: resumen, crear reporte, noticias, perfil y emergencias.',
    body: Scaffold(
      body: Column(
        children: [
          _fondoNaranja(Container(
            width: double.infinity,
            color: Colors.primary,
            borderRadius: 28,
            padding: EdgeInsets.only(left: 24, right: 24, top: 28, bottom: 24),
            child: Column(
              spacing: 18,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      Column(
                        crossAxis: CrossAxis.start,
                        spacing: 4,
                        children: [
                          Text(
                            CustomFunction(saludo, args: {'nombre': AppState('usuarioNombre')}),
                            style: Styles.headlineSmall,
                            color: _blanco,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '¿Qué quieres mejorar hoy en tu ciudad?',
                            style: Styles.bodyMedium,
                            color: Colors.hex(0xE6FFFFFF),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      onTap: Navigate(perfil),
                      child: Avatar(
                        text: CustomFunction(iniciales, args: {'nombre': AppState('usuarioNombre')}),
                        size: 48,
                        backgroundColor: _blanco,
                        textColor: Colors.primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    _estadistica(
                      CustomFunction(contarPorEstado, args: {'reportes': AppState('reportes'), 'estado': 'Todos'}),
                      'Reportes',
                      Colors.primary,
                    ),
                    _estadistica(
                      CustomFunction(contarPorEstado, args: {'reportes': AppState('reportes'), 'estado': 'En proceso'}),
                      'En proceso',
                      Colors.warning,
                    ),
                    _estadistica(
                      CustomFunction(contarPorEstado, args: {'reportes': AppState('reportes'), 'estado': 'Resuelto'}),
                      'Resueltos',
                      Colors.success,
                    ),
                  ],
                ),
              ],
            ),
          )),
          Expanded(
            Column(
              scrollable: true,
              padding: 20,
              spacing: 18,
              crossAxis: CrossAxis.stretch,
              children: [
                // A) Crear reporte
                Container(
                  onTap: Navigate(crearReporte),
                  color: Colors.primary,
                  borderRadius: 22,
                  padding: 20,
                  shadow: Shadow(blur: 16, dy: 6, color: Colors.hex(0x40FF7900)),
                  child: Row(
                    spacing: 16,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        borderRadius: 16,
                        color: Colors.hex(0x33FFFFFF),
                        alignment: Alignment.center,
                        child: Icon('add_a_photo', size: 28, color: _blanco),
                      ),
                      Expanded(
                        Column(
                          crossAxis: CrossAxis.start,
                          spacing: 4,
                          children: [
                            Text('Crear reporte', style: Styles.titleLarge, color: _blanco),
                            Text(
                              'Baches, fugas, basura, alumbrado y más',
                              style: Styles.bodySmall,
                              color: Colors.hex(0xE6FFFFFF),
                            ),
                          ],
                        ),
                      ),
                      Icon('arrow_forward_ios', size: 18, color: _blanco),
                    ],
                  ),
                ),
                Text('Accesos rápidos', style: Styles.titleMedium),
                Row(
                  spacing: 12,
                  children: [
                    accesoRapido('Mis reportes', 'assignment', misReportes),
                    accesoRapido('Noticias GDL', 'newspaper', noticias), // B
                    accesoRapido('Mi perfil', 'person', perfil), // C
                  ],
                ),
                // Emergencias
                Container(
                  color: Colors.hex(0xFFFEF2F2),
                  borderColor: Colors.hex(0xFFFECACA),
                  borderWidth: 1,
                  borderRadius: 18,
                  padding: 16,
                  child: Row(
                    spacing: 12,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        borderRadius: 14,
                        color: Colors.hex(0xFFFEE2E2),
                        alignment: Alignment.center,
                        child: Icon('emergency', size: 24, color: Colors.error),
                      ),
                      Expanded(
                        Column(
                          crossAxis: CrossAxis.start,
                          spacing: 2,
                          children: [
                            Text('¿Es una emergencia?', style: Styles.titleSmall),
                            Text(
                              'Llama al 911. Denuncia anónima: 089',
                              style: Styles.bodySmall,
                              color: Colors.secondaryText,
                            ),
                          ],
                        ),
                      ),
                      Button(
                        '911',
                        icon: 'call',
                        color: Colors.error,
                        textColor: _blanco,
                        borderRadius: 12,
                        onTap: LaunchUrl('tel:911'),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxis: MainAxis.spaceBetween,
                  children: [
                    Text('Reportes recientes', style: Styles.titleMedium),
                    Container(
                      onTap: Navigate(misReportes),
                      child: Text('Ver todos', style: Styles.titleSmall, color: Colors.primary),
                    ),
                  ],
                ),
                ListView(
                  source: CustomFunction(
                    ultimosReportes,
                    args: {'reportes': AppState('reportes'), 'cantidad': 3},
                  ),
                  shrinkWrap: true,
                  spacing: 12,
                  itemBuilder: (item) => tarjetaReporte(
                    categoria: item['categoria'],
                    direccion: item['direccion'],
                    fecha: CustomFunction(formatearFecha, args: {'fecha': item['fecha']}),
                    estado: item['estado'],
                    alTocar: verDetalle(item),
                  ),
                ),
                Container(
                  visible: Equals(
                    CustomFunction(contarPorEstado, args: {'reportes': AppState('reportes'), 'estado': 'Todos'}),
                    '0',
                  ),
                  color: _blanco,
                  borderRadius: 18,
                  padding: 20,
                  child: Column(
                    spacing: 8,
                    children: [
                      Icon('inbox', size: 36, color: Colors.secondaryText),
                      Text('Aún no tienes reportes', style: Styles.titleSmall),
                      Text(
                        'Cuando reportes una incidencia aparecerá aquí.',
                        style: Styles.bodySmall,
                        color: Colors.secondaryText,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  // ---- 4. Crear reporte ---------------------------------------------------
  // A4 · Detecta la ubicación del dispositivo y la convierte en dirección.
  List<DslAction> detectarUbicacion(String salida) => [
    SetState('buscandoUbicacion', true),
    SetState(
      'latitud',
      CustomFunction(latitudDe, args: {'ubicacion': Global(GlobalProperty.currentDeviceLocation)}),
    ),
    SetState(
      'longitud',
      CustomFunction(longitudDe, args: {'ubicacion': Global(GlobalProperty.currentDeviceLocation)}),
    ),
    If(
      Equals(State('latitud'), 0.0),
      then: [
        SetState('direccion', 'Activa el permiso de ubicación y toca actualizar.'),
        SetState('buscandoUbicacion', false),
      ],
      orElse: [
        ApiCall(
          geocodificar,
          outputAs: salida,
          params: {'lat': State('latitud'), 'lon': State('longitud')},
          onSuccess: (res) => [
            SetState('direccion', res['display_name']),
            SetState('ubicacionLista', true),
            SetState('buscandoUbicacion', false),
          ],
          onFailure: [
            SetState('direccion', 'No pudimos obtener la dirección. Toca actualizar.'),
            SetState('buscandoUbicacion', false),
          ],
        ),
      ],
    ),
  ];

  final crearReportePage = app.page(
    crearReporte,
    route: '/reportar',
    description: 'Formulario de reporte: categoría, foto (B4), ubicación (A4) y descripción.',
    state: {
      'categoria': string.withDefault(''),
      'direccion': string.withDefault('Detectando tu ubicación...'),
      'latitud': double_.withDefault(0.0),
      'longitud': double_.withDefault(0.0),
      'ubicacionLista': bool_.withDefault(false),
      'buscandoUbicacion': bool_.withDefault(true),
      'fotoCargada': bool_.withDefault(false),
    },
    onLoad: detectarUbicacion('direccionInicial'),
    body: Scaffold(
      body: Column(
        children: [
          _encabezado(
            'Crear reporte',
            'Mejora tu comunidad hoy',
            accion: _botonEncabezado('close', Navigate(inicio)),
          ),
          Expanded(
            Form(
              name: 'formReporte',
              child: Column(
                scrollable: true,
                padding: 20,
                spacing: 22,
                crossAxis: CrossAxis.stretch,
                children: [
                  // 1. Categoría
                  Column(
                    crossAxis: CrossAxis.stretch,
                    spacing: 10,
                    children: [
                      _tituloPaso('1. Categoría', '¿Qué tipo de problema quieres reportar?'),
                      Dropdown(
                        name: 'campoCategoria',
                        options: [for (final (nombre, _) in _categorias) nombre],
                        hint: 'Selecciona una opción',
                        required: true,
                        requiredMessage: 'Elige una categoría',
                        onChanged: SetState('categoria', WidgetValue()),
                      ),
                    ],
                  ),
                  // 2. Evidencia (B4)
                  Column(
                    crossAxis: CrossAxis.stretch,
                    spacing: 10,
                    children: [
                      _tituloPaso('2. Evidencia', 'Sube una foto clara del desperfecto'),
                      Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.accent1,
                        borderColor: Colors.hex(0xFFFFD7AB),
                        borderWidth: 2,
                        borderRadius: 18,
                        alignment: Alignment.center,
                        onTap: [
                          UploadData(
                            key: 'subirFoto',
                            source: UploadSource.galleryOrCamera,
                            allowPhoto: true,
                            destination: UploadDestination.localFile,
                            actionName: 'fotoReporte',
                          ),
                          SetState('fotoCargada', true),
                        ],
                        child: Column(
                          mainAxis: MainAxis.center,
                          spacing: 10,
                          children: [
                            Icon(
                              'add_a_photo',
                              size: 44,
                              color: Colors.primary,
                              visible: Not(State('fotoCargada')),
                            ),
                            Text(
                              'Toca para capturar o subir',
                              style: Styles.titleSmall,
                              color: Colors.primary,
                              visible: Not(State('fotoCargada')),
                            ),
                            Icon(
                              'check_circle',
                              size: 44,
                              color: Colors.success,
                              visible: State('fotoCargada'),
                            ),
                            Text(
                              'Foto agregada · toca para cambiarla',
                              style: Styles.titleSmall,
                              color: Colors.success,
                              visible: State('fotoCargada'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 3. Ubicación (A4)
                  Column(
                    crossAxis: CrossAxis.stretch,
                    spacing: 10,
                    children: [
                      _tituloPaso('3. Ubicación', 'Detectamos tu posición automáticamente'),
                      Container(
                        color: _blanco,
                        borderColor: Colors.alternate,
                        borderWidth: 1,
                        borderRadius: 18,
                        padding: 14,
                        child: Column(
                          crossAxis: CrossAxis.stretch,
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 12,
                              children: [
                                _iconoSuave('my_location'),
                                Expanded(
                                  Column(
                                    crossAxis: CrossAxis.start,
                                    spacing: 2,
                                    children: [
                                      Text(
                                        'Dirección detectada',
                                        style: Styles.labelMedium,
                                        color: Colors.secondaryText,
                                      ),
                                      Text(
                                        State('direccion'),
                                        style: Styles.titleSmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                ProgressBar.circular(
                                  size: 22,
                                  thickness: 3,
                                  visible: State('buscandoUbicacion'),
                                ),
                                IconButton(
                                  'refresh',
                                  size: 24,
                                  color: Colors.primary,
                                  visible: Not(State('buscandoUbicacion')),
                                  onTap: detectarUbicacion('direccionActualizada'),
                                ),
                              ],
                            ),
                            Row(
                              mainAxis: MainAxis.spaceBetween,
                              visible: State('ubicacionLista'),
                              children: [
                                Text(
                                  CustomFunction(
                                    textoCoordenadas,
                                    args: {'lat': State('latitud'), 'lon': State('longitud')},
                                  ),
                                  style: Styles.labelSmall,
                                  color: Colors.secondaryText,
                                ),
                                Container(
                                  onTap: LaunchUrl(
                                    CustomFunction(
                                      urlMapa,
                                      args: {'lat': State('latitud'), 'lon': State('longitud')},
                                    ),
                                  ),
                                  child: Text(
                                    'Ver en mapa',
                                    style: Styles.titleSmall,
                                    color: Colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 4. Descripción
                  Column(
                    crossAxis: CrossAxis.stretch,
                    spacing: 10,
                    children: [
                      _tituloPaso('4. Descripción', 'Agrega detalles adicionales si es necesario'),
                      TextField(
                        name: 'campoDescripcion',
                        hint: 'Ej: El bache es profundo y está frente al número 120',
                        maxLines: 4,
                        maxLength: 300,
                        maxLengthMessage: 'Máximo 300 caracteres',
                      ),
                    ],
                  ),
                  Button(
                    'Enviar reporte',
                    name: 'botonEnviarReporte',
                    icon: 'send',
                    width: double.infinity,
                    height: 54,
                    color: Colors.primary,
                    textColor: _blanco,
                    borderRadius: 16,
                    onTap: [
                      ValidateForm('formReporte'),
                      If(
                        Not(State('fotoCargada')),
                        then: [Snackbar('Agrega una foto como evidencia')],
                        orElse: [
                          // TODO backend: enviar el reporte y subir la foto.
                          UpdateAppState.insertAtIndex(
                            'reportes',
                            0,
                            Struct(reporte, {
                              'categoria': State('categoria'),
                              'descripcion': WidgetState('campoDescripcion', WidgetStateProperty.text),
                              'direccion': State('direccion'),
                              'latitud': State('latitud'),
                              'longitud': State('longitud'),
                              'estado': 'Pendiente',
                              'fecha': Global(GlobalProperty.currentTimestamp),
                              'tieneFoto': true,
                            }),
                          ),
                          Snackbar('¡Reporte enviado! Gracias por cuidar tu ciudad.'),
                          Navigate(misReportes),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // ---- Mis reportes -------------------------------------------------------
  final misReportesPage = app.page(
    misReportes,
    route: '/mis-reportes',
    description: 'Seguimiento de los reportes del usuario con filtro por estado.',
    state: {'filtro': string.withDefault('Todos')},
    body: Scaffold(
      body: Column(
        children: [
          _encabezado(
            'Mis reportes',
            'Seguimiento de tus incidencias',
            accion: Avatar(
              text: CustomFunction(iniciales, args: {'nombre': AppState('usuarioNombre')}),
              size: 48,
              backgroundColor: _blanco,
              textColor: Colors.primary,
            ),
          ),
          Row(
            scrollable: true,
            spacing: 8,
            padding: EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 6),
            children: [
              _chipFiltro('Todos'),
              _chipFiltro('Pendiente'),
              _chipFiltro('En proceso'),
              _chipFiltro('Resuelto'),
            ],
          ),
          Column(
            visible: Equals(
              CustomFunction(contarPorEstado, args: {'reportes': AppState('reportes'), 'estado': State('filtro')}),
              '0',
            ),
            spacing: 10,
            padding: 32,
            children: [
              Icon('assignment', size: 56, color: Colors.secondaryText),
              Text('No hay reportes aquí', style: Styles.titleMedium),
              Text(
                'Crea un reporte y dale seguimiento desde esta pantalla.',
                style: Styles.bodyMedium,
                color: Colors.secondaryText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Expanded(
            ListView(
              source: CustomFunction(
                filtrarReportes,
                args: {'reportes': AppState('reportes'), 'estado': State('filtro')},
              ),
              spacing: 12,
              padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 20),
              itemBuilder: (item) => tarjetaReporte(
                categoria: item['categoria'],
                direccion: item['direccion'],
                fecha: CustomFunction(formatearFecha, args: {'fecha': item['fecha']}),
                estado: item['estado'],
                alTocar: verDetalle(item),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 4),
            child: Button(
              'Nuevo reporte',
              icon: 'add',
              variant: ButtonVariant.outlined,
              width: double.infinity,
              height: 50,
              borderRadius: 14,
              onTap: Navigate(crearReporte),
            ),
          ),
        ],
      ),
    ),
  );

  // ---- Detalle de reporte -------------------------------------------------
  // Sin condición, el paso se muestra siempre como completado.
  DslWidget pasoSeguimiento(String titulo, String ayuda, [DslExpression? completado]) => Row(
    spacing: 12,
    children: [
      Icon('check_circle', size: 26, color: Colors.success, visible: completado),
      if (completado != null)
        Icon('radio_button_unchecked', size: 26, color: Colors.alternate, visible: Not(completado)),
      Expanded(
        Column(
          crossAxis: CrossAxis.start,
          spacing: 2,
          children: [
            Text(titulo, style: Styles.titleSmall),
            Text(ayuda, style: Styles.bodySmall, color: Colors.secondaryText),
          ],
        ),
      ),
    ],
  );

  app.page(
    detalle,
    route: '/reporte',
    description: 'Detalle y seguimiento de un reporte.',
    params: {
      'categoria': string.withDefault('Otro'),
      'descripcion': string.withDefault(''),
      'direccion': string.withDefault(''),
      'estado': string.withDefault('Pendiente'),
      'fecha': string.withDefault(''),
      'latitud': double_.withDefault(0.0),
      'longitud': double_.withDefault(0.0),
    },
    body: Scaffold(
      body: Column(
        children: [
          _encabezado(
            'Detalle del reporte',
            'Estado y seguimiento',
            accion: _botonEncabezado('arrow_back', NavigateBack()),
          ),
          Expanded(
            Column(
              scrollable: true,
              padding: 20,
              spacing: 16,
              crossAxis: CrossAxis.stretch,
              children: [
                tarjetaReporte(
                  categoria: PageParam('categoria'),
                  direccion: PageParam('direccion'),
                  fecha: PageParam('fecha'),
                  estado: PageParam('estado'),
                  alTocar: Snackbar('Estado actual del reporte'),
                ),
                Container(
                  color: _blanco,
                  borderRadius: 18,
                  padding: 18,
                  shadow: _sombraTarjeta,
                  child: Column(
                    crossAxis: CrossAxis.stretch,
                    spacing: 8,
                    children: [
                      Text('Descripción', style: Styles.titleSmall),
                      Text(
                        PageParam('descripcion'),
                        style: Styles.bodyMedium,
                        color: Colors.secondaryText,
                      ),
                      Divider(),
                      Text('Ubicación', style: Styles.titleSmall),
                      Text(PageParam('direccion'), style: Styles.bodyMedium, color: Colors.secondaryText),
                      Button(
                        'Ver en mapa',
                        icon: 'map',
                        variant: ButtonVariant.outlined,
                        width: double.infinity,
                        borderRadius: 12,
                        onTap: LaunchUrl(
                          CustomFunction(
                            urlMapa,
                            args: {'lat': PageParam('latitud'), 'lon': PageParam('longitud')},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: _blanco,
                  borderRadius: 18,
                  padding: 18,
                  shadow: _sombraTarjeta,
                  child: Column(
                    crossAxis: CrossAxis.stretch,
                    spacing: 14,
                    children: [
                      Text('Seguimiento', style: Styles.titleSmall),
                      pasoSeguimiento('Reporte recibido', 'Tu reporte fue registrado'),
                      pasoSeguimiento(
                        'En proceso',
                        'Una cuadrilla atiende la incidencia',
                        Not(Equals(PageParam('estado'), 'Pendiente')),
                      ),
                      pasoSeguimiento(
                        'Resuelto',
                        'La incidencia fue atendida',
                        Equals(PageParam('estado'), 'Resuelto'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  // ---- 5. Noticias de Guadalajara ----------------------------------------
  List<DslAction> cargarNoticias(String salida) => [
    SetState('cargando', true),
    SetState('error', false),
    ApiCall(
      obtenerNoticias,
      outputAs: salida,
      onSuccess: (res) => [
        SetState('noticias', res['items']),
        SetState('cargando', false),
      ],
      onFailure: [SetState('cargando', false), SetState('error', true)],
    ),
  ];

  final noticiasPage = app.page(
    noticias,
    route: '/noticias',
    description: 'Noticias recientes de Guadalajara y Jalisco (El Informador vía rss2json).',
    state: {
      'noticias': listOf(noticia),
      'cargando': bool_.withDefault(true),
      'error': bool_.withDefault(false),
    },
    onLoad: cargarNoticias('noticiasIniciales'),
    body: Scaffold(
      body: Column(
        children: [
          _encabezado(
            'Noticias GDL',
            'Lo último en Guadalajara y Jalisco',
            accion: _botonEncabezado('refresh', cargarNoticias('noticiasActualizadas')),
          ),
          Container(
            visible: State('cargando'),
            padding: 40,
            alignment: Alignment.center,
            child: ProgressBar.circular(size: 40, thickness: 4),
          ),
          Container(
            visible: State('error'),
            padding: 32,
            child: Column(
              spacing: 10,
              children: [
                Icon('wifi_off', size: 48, color: Colors.secondaryText),
                Text('No pudimos cargar las noticias', style: Styles.titleMedium),
                Button(
                  'Reintentar',
                  color: Colors.primary,
                  textColor: _blanco,
                  borderRadius: 12,
                  onTap: cargarNoticias('noticiasReintento'),
                ),
              ],
            ),
          ),
          Expanded(
            ListView(
              source: State('noticias'),
              visible: Not(State('cargando')),
              spacing: 12,
              padding: EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 20),
              itemBuilder: (item) => tarjetaNoticia(
                titulo: item['title'],
                resumen: item['description'],
                autor: item['author'],
                fecha: CustomFunction(fechaNoticia, args: {'pubDate': item['pubDate']}),
                enlace: item['link'],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Fuente: El Informador',
              style: Styles.labelSmall,
              color: Colors.secondaryText,
            ),
          ),
        ],
      ),
    ),
  );

  // ---- 6. Perfil ----------------------------------------------------------
  final perfilPage = app.page(
    perfil,
    route: '/perfil',
    description: 'Perfil del ciudadano: datos, estadísticas, ajustes y cierre de sesión.',
    state: {'editando': bool_.withDefault(false)},
    body: Scaffold(
      body: Column(
        scrollable: true,
        crossAxis: CrossAxis.stretch,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(width: double.infinity, height: 64, color: Colors.primary),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.primary,
                borderRadius: 32,
              ),
              Column(
                padding: EdgeInsets.only(top: 86),
                spacing: 6,
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    borderRadius: 999,
                    color: _blanco,
                    alignment: Alignment.center,
                    shadow: _sombraTarjeta,
                    child: Avatar(
                      text: CustomFunction(iniciales, args: {'nombre': AppState('usuarioNombre')}),
                      size: 100,
                      backgroundColor: Colors.accent1,
                      textColor: Colors.primary,
                    ),
                  ),
                  Text(AppState('usuarioNombre'), style: Styles.headlineSmall),
                  Text(AppState('usuarioCorreo'), style: Styles.bodyMedium, color: Colors.secondaryText),
                  Container(
                    color: Colors.accent1,
                    borderRadius: 999,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Text(
                      'Ciudadano activo · Guadalajara',
                      style: Styles.labelMedium,
                      color: Colors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            padding: 20,
            spacing: 14,
            crossAxis: CrossAxis.stretch,
            children: [
              Row(
                spacing: 10,
                children: [
                  _estadistica(
                    CustomFunction(contarPorEstado, args: {'reportes': AppState('reportes'), 'estado': 'Todos'}),
                    'Reportes',
                    Colors.primary,
                  ),
                  _estadistica(
                    CustomFunction(contarPorEstado, args: {'reportes': AppState('reportes'), 'estado': 'Resuelto'}),
                    'Resueltos',
                    Colors.success,
                  ),
                  _estadistica(
                    CustomFunction(contarPorEstado, args: {'reportes': AppState('reportes'), 'estado': 'Pendiente'}),
                    'Pendientes',
                    Colors.warning,
                  ),
                ],
              ),
              Text('Mi actividad', style: Styles.titleMedium),
              _opcionMenu(
                'history',
                'Historial de reportes',
                'Revisa el estado de tus denuncias',
                Navigate(misReportes),
              ),
              _opcionMenu(
                'newspaper',
                'Noticias de mi ciudad',
                'Lo último en Guadalajara',
                Navigate(noticias),
              ),
              Container(
                color: _blanco,
                borderRadius: 18,
                padding: 14,
                shadow: _sombraTarjeta,
                child: Row(
                  spacing: 14,
                  children: [
                    _iconoSuave('notifications_active'),
                    Expanded(
                      Column(
                        crossAxis: CrossAxis.start,
                        spacing: 2,
                        children: [
                          Text('Notificaciones', style: Styles.titleSmall),
                          Text(
                            'Avisos sobre tus reportes',
                            style: Styles.bodySmall,
                            color: Colors.secondaryText,
                          ),
                        ],
                      ),
                    ),
                    Toggle(
                      value: AppState('notificaciones'),
                      onChanged: UpdateAppState.set('notificaciones', WidgetValue()),
                    ),
                  ],
                ),
              ),
              Text('Configuración', style: Styles.titleMedium),
              _opcionMenu(
                'badge',
                'Información personal',
                'Nombre, teléfono y colonia',
                SetState('editando', Not(State('editando'))),
              ),
              Container(
                visible: State('editando'),
                color: _blanco,
                borderColor: Colors.primary,
                borderWidth: 1,
                borderRadius: 18,
                padding: 16,
                child: Column(
                  crossAxis: CrossAxis.stretch,
                  spacing: 12,
                  children: [
                    TextField(
                      name: 'editarNombre',
                      label: 'Nombre completo',
                      hint: AppState('usuarioNombre'),
                      prefixIcon: 'person_outline',
                    ),
                    TextField(
                      name: 'editarTelefono',
                      label: 'Teléfono',
                      hint: AppState('usuarioTelefono'),
                      prefixIcon: 'phone',
                      keyboard: Keyboard.number,
                    ),
                    TextField(
                      name: 'editarColonia',
                      label: 'Colonia',
                      hint: AppState('usuarioColonia'),
                      prefixIcon: 'home_work',
                    ),
                    Button(
                      'Guardar cambios',
                      width: double.infinity,
                      height: 48,
                      color: Colors.primary,
                      textColor: _blanco,
                      borderRadius: 12,
                      onTap: [
                        for (final (campo, estado) in [
                          ('editarNombre', 'usuarioNombre'),
                          ('editarTelefono', 'usuarioTelefono'),
                          ('editarColonia', 'usuarioColonia'),
                        ])
                          If(
                            Not(Equals(WidgetState(campo, WidgetStateProperty.text), '')),
                            then: [
                              UpdateAppState.set(
                                estado,
                                WidgetState(campo, WidgetStateProperty.text),
                              ),
                            ],
                          ),
                        SetState('editando', false),
                        Snackbar('Datos actualizados'),
                      ],
                    ),
                  ],
                ),
              ),
              _opcionMenu(
                'info_outline',
                'Acerca de CityCare',
                'Versión 1.0 · Proyecto escolar',
                Snackbar('CityCare: reporta y da seguimiento a incidencias urbanas.'),
              ),
              Button(
                'Cerrar sesión',
                icon: 'logout',
                variant: ButtonVariant.outlined,
                width: double.infinity,
                height: 50,
                borderRadius: 14,
                onTap: [
                  ConfirmDialog(
                    title: '¿Cerrar sesión?',
                    message: 'Tendrás que volver a iniciar sesión para reportar.',
                    onConfirm: [
                      // TODO backend: invalidar el token de sesión.
                      UpdateAppState.set('sesionIniciada', false),
                      Navigate(login),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );

  // -------------------------------------------------------------------------
  // Barra de navegación inferior
  // -------------------------------------------------------------------------
  app.bottomNav(
    items: [
      BottomNavItem(inicioPage, icon: 'home'),
      BottomNavItem(crearReportePage, icon: 'add_circle'),
      BottomNavItem(misReportesPage, icon: 'assignment'),
      BottomNavItem(noticiasPage, icon: 'newspaper'),
      BottomNavItem(perfilPage, icon: 'person'),
    ],
    backgroundColor: Colors.secondaryBackground,
    selectedColor: Colors.primary,
    unselectedColor: Colors.secondaryText,
  );
}
