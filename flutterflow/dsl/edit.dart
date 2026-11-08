library;

import 'dart:io';
import 'dart:math';

import 'package:flutterflow_ai/flutterflow_ai.dart';
import 'package:citicare/flutterflow_project.dart' as ff;

import 'codigo_acciones.dart';

Future<void> main(List<String> args) async {
  if (Platform.environment['_FF_AI_DSL_LAUNCHER'] != '1') {
    stdout.writeln(
      'Tip: run this through `flutterflow ai run` (validated, faster)',
    );
  }
  final options = _parseCliOptions(args);
  try {
    await flutterFlowAI(
      buildStarterEditFlow,
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
Run the starter FlutterFlow AI edit flow.

Usage:
  flutterflow ai validate dsl/edit.dart [options]
  flutterflow ai run dsl/edit.dart [options]

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

/// Clave aleatoria de 8 caracteres, como las que usa FlutterFlow.
String _claveNueva() {
  const letras = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final azar = Random.secure();
  return List.generate(8, (_) => letras[azar.nextInt(letras.length)]).join();
}

void buildStarterEditFlow(App app) {
  // Ya aplicado el 31 oct 2026 (tipografía, noticias con miniatura, etiquetas
  // de la barra inferior); no se vuelve a ejecutar.
  // _noticiasConMiniaturas(app);

  // Correcciones del documento "Correcciones de la app móvil" (GPS, foto,
  // descripción y envío del reporte). Fase 1 (datos y código) ya aplicada;
  // fase 2: pantalla Reportar.
  // _reporteFase1(app);
  // _reporteFase2(app);
  // _reporteFase3(app);

  // Envío al backend (contrato 3.1, POST /api/v1/reports). Fase 4a (acción,
  // constante urlApi y token) ya aplicada; fase 4b: botón Enviar y sesión.
  // _envioFase4a(app);
  // _vaciarEnviar(app);
  // _envioFase4b(app);

  // Contrato completo city-care.v1.yaml: login, perfil y logout. Fase 5a
  // (acciones y estado) ya aplicada; fase 5b: pantallas.
  // _sesionFase5a(app);
  // _vaciarCerrarSesion(app);
  // _sesionFase5b(app);

  // URL del backend que pidió Miguel (solo funciona en su emulador Android).
  // app.raw((project) {
  //   final constante = project.appConstants.fields
  //       .firstWhere((c) => c.parameter.identifier.name == 'urlApi');
  //   constante.serializedValue
  //     ..clear()
  //     ..add('http://10.0.2.2:3333/api/v1');
  // });

  // Guía de conexión de Miguel: Mis reportes y detalle desde el servidor,
  // token cifrado, sesión restaurada con el perfil y HTTP local en Android.
  // Fase 6a (datos, acciones, token y manifest) ya aplicada; fase 6b:
  // pantallas.
  // _servidorFase6a(app);
  // _vaciarIniciarSesion(app);
  // _servidorFase6b(app);

  // Contrato city-care.v1 actualizado (1 nov 2026): el historial del detalle
  // trae estadoNuevo/observacion y puede venir del más reciente al más antiguo.
  // app.editCustomAction('obtenerDetalleReporte', (codigo) {
  //   codigo.replaceCode(codigoObtenerDetalleReporte);
  // });

  // Túnel de Miguel (cloudflared, cambia si lo reinicia). Antes: la IP de su PC
  // en su wifi (192.168.100.228), que solo respondía dentro de esa red.
  // app.raw((project) {
  //   final constante = project.appConstants.fields
  //       .firstWhere((c) => c.parameter.identifier.name == 'urlApi');
  //   constante.serializedValue
  //     ..clear()
  //     ..add('https://host-cost-plates-modify.trycloudflare.com/api/v1');
  // });

  // Arreglos finales para el APK. Fase 7a (GPS real otra vez, foto con aviso y
  // cadena de Mis reportes vacía) y fase 7b (Mis reportes siempre al día).
  // _finalFase7a(app);
  // _finalFase7b(app);

  // Pulido final. Para compilar solo falta cambiar la URL del túnel: ver
  // _ponerUrlServidor al final de este bloque.
  // _finalFase7c(app);
  // _finalFase7d(app);
  // _ponerUrlServidor(app, 'https://NUEVO-TUNEL.trycloudflare.com/api/v1');

  // Modo Run en navegador: reportar sin GPS. La APK sigue exigiendo GPS real.
  _navegadorSinGps(app);
  _ponerUrlServidor(app, 'https://lynn-likewise-training-vitamins.trycloudflare.com/api/v1');
}

/// En el navegador usa una ubicación fija y la envía con origen "manual".
void _navegadorSinGps(App app) {
  app.editCustomAction('obtenerUbicacionGps', (codigo) {
    codigo.replaceCode(codigoObtenerUbicacionGps);
  });
  app.editCustomAction('enviarReporte', (codigo) {
    codigo.replaceCode(codigoEnviarReporte);
  });
}

/// Fase 7d: los títulos de Accesos rápidos se cortaban en un celular.
// ignore: unused_element
void _finalFase7d(App app) {
  const claves = ['Text_5tvtghqq', 'Text_eziv4rfg', 'Text_hs7162vg'];
  app.editPage(ff.Pages.inicio, (page) {
    for (final clave in claves) {
      page.update(page.findByKey(clave), (patch) {
        patch.fontSize(13);
      });
    }
  });
  app.raw((project) {
    FFNode? buscar(FFNode n, String clave) {
      if (n.key == clave) return n;
      for (final hijo in n.children) {
        final r = buscar(hijo, clave);
        if (r != null) return r;
      }
      return null;
    }

    final inicio = project.widgetClasses.values.firstWhere((p) => p.name == 'Inicio');
    for (final clave in claves) {
      buscar(inicio.node, clave)!
          .props
          .text
          .ensureMaxLinesValue()
          .mergeFromProto3Json({'inputValue': 2});
    }
  });
}

/// Cambia la dirección del backend. Es lo único que falta antes del APK.
// ignore: unused_element
void _ponerUrlServidor(App app, String url) {
  app.raw((project) {
    final constante = project.appConstants.fields
        .firstWhere((c) => c.parameter.identifier.name == 'urlApi');
    constante.serializedValue
      ..clear()
      ..add(url);
  });
}

/// Fase 7c: botón Enviar gris mientras está bloqueado, mensaje de ubicación
/// completo, "Actualizando..." en Mis reportes y etiqueta corta en la barra.
// ignore: unused_element
void _finalFase7c(App app) {
  app.raw((project) {
    FFNode? buscar(FFNode n, String clave) {
      if (n.key == clave) return n;
      for (final hijo in n.children) {
        final r = buscar(hijo, clave);
        if (r != null) return r;
      }
      return null;
    }

    final reportar = project.widgetClasses.values.firstWhere((p) => p.name == 'Reportar');
    final enviar = buscar(reportar.node, 'Button_hqlzt1r5')!.props.button;
    enviar.ensureDisabledColorValue().mergeFromProto3Json({
      'inputValue': {'themeColor': 'ALTERNATE'},
    });
    enviar.ensureDisabledTextColorValue().mergeFromProto3Json({
      'inputValue': {'themeColor': 'SECONDARY_TEXT'},
    });
    // El mensaje de permiso de ubicación no cabía en 3 líneas.
    buscar(reportar.node, 'Text_y8f51l6o')!
        .props
        .text
        .ensureMaxLinesValue()
        .mergeFromProto3Json({'inputValue': 6});

    // "Mis reportes" se cortaba en la barra inferior de un celular.
    final mis = project.widgetClasses.values.firstWhere((p) => p.name == 'MisReportes');
    final etiqueta = mis.node.props.scaffold.ensureNavBarItem().ensureLabel().ensureTextValue();
    etiqueta.inputValue = 'Reportes';
    etiqueta.mostRecentInputValue = 'Reportes';
  });

  final actualizando = State(ff.Pages.misReportes.state.actualizando);
  app.editPage(ff.Pages.misReportes, (page) {
    page.ensureInsertedAfter(
      page.findByKey('Row_p4ugbawx'), // Filtros
      Row(
        name: 'FilaActualizando',
        mainAxis: MainAxis.center,
        spacing: 8,
        visible: actualizando,
        children: [
          ProgressBar.circular(size: 16, thickness: 2),
          Text('Actualizando...', style: Styles.bodySmall, color: Colors.secondaryText),
        ],
      ),
    );
    // Sin este aviso, al abrir se veía "No hay reportes" antes de que llegaran.
    page.ensureWrappedWith(
      page.findByKey('Column_taxhhjyr'),
      Container(name: 'EnvolturaSinReportes', visible: Not(actualizando)),
    );
  });
}

/// Fase 7a: quita la ubicación de prueba (el reporte vuelve a exigir GPS real),
/// agrega la foto con aviso de error y vacía la carga de Mis reportes.
// ignore: unused_element
void _finalFase7a(App app) {
  app.editCustomAction('obtenerUbicacionGps', (codigo) {
    codigo.replaceCode(codigoObtenerUbicacionGps);
  });
  app.editCustomAction('enviarReporte', (codigo) {
    codigo.replaceCode(codigoEnviarReporte);
  });
  app.customWidget(
    'FotoReporte',
    parameters: {'url': string},
    description: 'Foto del reporte con indicador de carga y aviso si no se puede cargar.',
    code: r'''
class FotoReporte extends StatelessWidget {
  const FotoReporte({
    super.key,
    this.width,
    this.height,
    required this.url,
  });

  final double? width;
  final double? height;
  final String url;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        url,
        width: width ?? double.infinity,
        height: height ?? 220,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progreso) => progreso == null
            ? child
            : Container(
                width: width ?? double.infinity,
                height: height ?? 220,
                color: tema.alternate,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
        errorBuilder: (context, error, stack) => Container(
          width: width ?? double.infinity,
          height: height ?? 220,
          color: tema.alternate,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_not_supported_outlined,
                  size: 36, color: tema.secondaryText),
              const SizedBox(height: 8),
              Text(
                'No pudimos cargar la foto. Regresa y abre el reporte de nuevo.',
                textAlign: TextAlign.center,
                style: tema.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''',
  );
  app.editPageState(ff.Pages.misReportes, (estado) {
    estado.ensureField('conServidor', bool_.withDefault(false));
    estado.ensureField('actualizando', bool_.withDefault(false));
  });
  app.editPageOnLoad(ff.Pages.misReportes, []);
}

/// Fase 7b: Mis reportes se actualiza al abrirse, con un botón y cada 20
/// segundos mientras está abierta; avisa si no se pudo actualizar. La foto del
/// detalle avisa si no carga.
// ignore: unused_element
void _finalFase7b(App app) {
  // dynamic: conServidor y actualizando se crean en la fase 7a.
  final dynamic estado = ff.Pages.misReportes.state;
  final token = AppState(ff.AppState.tokenSesion);
  Object url(String salida) =>
      CodeExpression(r'u ?? ""', args: {'u': ActionOutput(salida)}, returns: string);
  DslAction leerUrl(String salida) =>
      CallCustomAction.named('urlServidor', returnType: string, outputAs: salida);
  DslAction listar(String salidaUrl, String salida) => CallCustomAction.named(
        'listarMisReportes',
        args: {'urlApi': string, 'token': string},
        returnType: ff.Structs.resultadoReportes,
        arguments: {'urlApi': url(salidaUrl), 'token': token},
        outputAs: salida,
      );
  Object sesionRechazada(ActionOutput lista) => CodeExpression(
        r'c == 401 || c == 403',
        args: {'c': lista['codigoHttp']},
        returns: bool_,
      );
  List<DslAction> cerrarSesion(ActionOutput lista) => [
    Snackbar(lista['mensaje']),
    UpdateAppState.clear(ff.AppState.reportes),
    CallCustomAction.named(
      'guardarTokenSeguro',
      args: {'token': string},
      arguments: {'token': ''},
    ),
    UpdateAppState.set(ff.AppState.tokenSesion, ''),
    UpdateAppState.set(ff.AppState.sesionIniciada, false),
    Navigate(ff.Pages.iniciarSesion),
  ];
  // [avisos]: acciones cuando falla sin que la sesión sea el problema.
  List<DslAction> aplicar(String salida, List<DslAction> alTerminar, List<DslAction> avisos) {
    final lista = ActionOutput(salida);
    return [
      If(
        lista['exito'],
        then: [UpdateAppState.set(ff.AppState.reportes, lista['reportes']), ...alTerminar],
        orElse: [
          If(sesionRechazada(lista), then: cerrarSesion(lista), orElse: avisos),
        ],
      ),
    ];
  }

  final avisoSinActualizar =
      'No pudimos actualizar tus reportes. Te mostramos los últimos guardados.';

  app.editPageOnLoad(ff.Pages.misReportes, [
    leerUrl('urlMisReportes'),
    If(
      Not(Equals(ActionOutput('urlMisReportes'), '')),
      then: [
        SetState(estado.conServidor, true),
        If(
          Not(Equals(token, '')),
          then: [
            SetState(estado.actualizando, true),
            listar('urlMisReportes', 'reportesServidor'),
            SetState(estado.actualizando, false),
            ...aplicar('reportesServidor', [], [Snackbar(avisoSinActualizar)]),
            // Mientras la pantalla está abierta; sin avisos para no molestar.
            StartPeriodic('actualizarReportes', durationMillis: 20000),
            listar('urlMisReportes', 'reportesPeriodico'),
            ...aplicar('reportesPeriodico', [], []),
          ],
        ),
      ],
    ),
  ]);

  app.editPage(ff.Pages.misReportes, (page) {
    page.ensureInsertedBefore(
      page.findByKey('Container_l801pupf'), // Avatar
      IconButton(
        'refresh',
        name: 'BotonActualizarReportes',
        size: 40,
        color: Colors.secondaryBackground,
        fillColor: Colors.hex(0x33FFFFFF),
        borderRadius: 20,
        visible: State(estado.conServidor),
        disabled: State(estado.actualizando),
        onTap: [
          leerUrl('urlBotonReportes'),
          SetState(estado.actualizando, true),
          listar('urlBotonReportes', 'reportesBoton'),
          SetState(estado.actualizando, false),
          ...aplicar(
            'reportesBoton',
            [Snackbar('Reportes actualizados')],
            [Snackbar(ActionOutput('reportesBoton')['mensaje'])],
          ),
        ],
      ),
    );
  });

  app.editPage(ff.Pages.detalleReporte, (page) {
    final fotoUrl = State(ff.Pages.detalleReporte.state.fotoUrl);
    page.ensureReplaced(
      page.findByKey('Container_0tye8s0y'),
      Container(
        name: 'FotoDelReporte',
        height: 220,
        visible: Not(Equals(fotoUrl, '')),
        child: CustomWidget(
          'FotoReporte',
          arguments: {
            'url': CodeExpression(r'u ?? ""', args: {'u': fotoUrl}, returns: string),
          },
        ),
      ),
    );
  });
}

/// Vacía la cadena del botón Iniciar sesión para reescribirla (el script
/// conserva los argumentos de una cadena que ya existe).
// ignore: unused_element
void _vaciarIniciarSesion(App app) {
  app.editPage(ff.Pages.iniciarSesion, (page) {
    page.ensureActions(
      page.findByKey('Button_nqrvc46t'),
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [],
    );
  });
}

// ---------------------------------------------------------------------------
// Guía de conexión de Miguel (1 nov 2026)
// ---------------------------------------------------------------------------

/// Fase 6a: datos, acciones, token cifrado y HTTP local en Android. Vacía las
/// cadenas que la fase 6b reescribe completas.
// ignore: unused_element
void _servidorFase6a(App app) {
  app.raw((project) {
    // Reporte: id del servidor (para pedir el detalle) y URL de la foto.
    final reporte = project.backend.dataSchemaConfig.dataStructs
        .firstWhere((s) => s.identifier.name == 'Reporte');
    for (final nombre in ['idServidor', 'fotoUrl']) {
      if (reporte.fields.any((f) => f.identifier.name == nombre)) continue;
      final campo = reporte.fields
          .firstWhere((f) => f.identifier.name == 'direccion')
          .deepCopy();
      campo.identifier.name = nombre;
      campo.identifier.key = _claveNueva();
      campo.description = 'Reporte.$nombre';
      reporte.fields.add(campo);
    }

    if (findPubDependency(project, name: 'flutter_secure_storage') == null) {
      addPubDependency(project, name: 'flutter_secure_storage', version: '9.2.4');
    }

    // El token deja de guardarse sin cifrar (SharedPreferences): ahora vive en
    // memoria y en el almacenamiento seguro (guardarTokenSeguro).
    project.appState.fields
        .firstWhere((f) => f.parameter.identifier.name == 'tokenSesion')
        .persisted = false;
  });

  final resultadoReportes = app.struct('ResultadoReportes', {
    'exito': bool_,
    'codigoHttp': int_,
    'mensaje': string,
    'reportes': listOf(ff.Structs.reporte),
  });
  final detalleServidor = app.struct('DetalleServidor', {
    'exito': bool_,
    'codigoHttp': int_,
    'mensaje': string,
    'folio': string,
    'estado': string,
    'fotoUrl': string,
    'historial': listOf(string),
  });

  app.customAction(
    'listarMisReportes',
    args: {'urlApi': string, 'token': string},
    returns: resultadoReportes,
    description: 'GET {urlApi}/reports: reportes propios del ciudadano, convertidos al tipo Reporte.',
    code: codigoListarMisReportes,
  );
  app.customAction(
    'obtenerDetalleReporte',
    args: {'urlApi': string, 'token': string, 'idServidor': string},
    returns: detalleServidor,
    description: 'GET {urlApi}/reports/{id}: folio, estado, foto (URL temporal) e historial.',
    code: codigoObtenerDetalleReporte,
  );
  app.customAction(
    'guardarTokenSeguro',
    args: {'token': string},
    description: 'Guarda el token en el almacenamiento cifrado del teléfono; vacío lo borra.',
    code: codigoGuardarTokenSeguro,
  );
  app.customAction(
    'leerTokenSeguro',
    returns: string,
    description: 'Lee el token del almacenamiento cifrado (y migra el de versiones anteriores).',
    code: codigoLeerTokenSeguro,
  );
  // El envío ajusta la categoría al catálogo del servidor y entiende el 503.
  app.editCustomAction('enviarReporte', (codigo) {
    codigo.replaceCode(codigoEnviarReporte);
  });

  app.editPageParams(ff.Pages.detalleReporte, (params) {
    params.ensureParam('idServidor', string.withDefault(''));
    params.ensureParam('folio', string.withDefault(''));
  });
  app.editPageState(ff.Pages.detalleReporte, (estado) {
    estado.ensureField('fotoUrl', string.withDefault(''));
    estado.ensureField('historial', listOf(string));
  });

  // Solo desarrollo: permite el backend local por HTTP (10.0.2.2 o la IP de
  // la PC). Con la URL HTTPS definitiva se puede quitar.
  app.nativeFile(NativeFile.androidManifest).hook(
    NativeFileHook.manifestApplicationTag,
    name: 'HTTP local',
    content: 'android:usesCleartextTraffic="true"',
  );

  // Cadenas que la fase 6b reescribe completas.
  _vaciarCerrarSesion(app);
  app.editPage(ff.Pages.iniciarSesion, (page) {
    page.ensureActions(
      page.findByKey('Button_nqrvc46t'),
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [],
    );
  });
  app.editPageOnLoad(ff.Pages.iniciarSesion, []);
  app.editPageOnLoad(ff.Pages.perfil, []);
}

/// Fase 6b: sesión restaurada con el perfil (token cifrado), Inicio y Mis
/// reportes desde GET /reports, detalle con foto e historial, y cierre de
/// sesión que borra el token y los reportes del teléfono.
// ignore: unused_element
void _servidorFase6b(App app) {
  final usuarioSesion = ff.Structs.usuarioSesion;
  final estadoLogin = ff.Pages.iniciarSesion.state;
  final estadoPerfil = ff.Pages.perfil.state;
  final estadoDetalle = ff.Pages.detalleReporte.state;

  // urlApi vacía = modo sin servidor.
  DslAction leerUrl(String salida) =>
      CallCustomAction.named('urlServidor', returnType: string, outputAs: salida);
  Object conServidor(String salida) => Not(Equals(ActionOutput(salida), ''));
  Object url(String salida) =>
      CodeExpression(r'u ?? ""', args: {'u': ActionOutput(salida)}, returns: string);
  Object sesionRechazada(ActionOutput resultado) => CodeExpression(
        r'c == 401 || c == 403',
        args: {'c': resultado['codigoHttp']},
        returns: bool_,
      );
  DslAction guardarToken(Object token) => CallCustomAction.named(
        'guardarTokenSeguro',
        args: {'token': string},
        arguments: {'token': token},
      );
  final token = AppState(ff.AppState.tokenSesion);

  List<DslAction> guardarUsuario(ActionOutput datos) => [
    UpdateAppState.set(ff.AppState.usuarioNombre, datos['nombre']),
    UpdateAppState.set(ff.AppState.usuarioCorreo, datos['correo']),
    UpdateAppState.set(ff.AppState.usuarioTelefono, datos['telefono']),
  ];
  // Sesión vencida o cerrada: token borrado de la memoria y del almacenamiento
  // seguro, y los reportes del servidor fuera del teléfono.
  List<DslAction> cerrarSesionLocal() => [
    guardarToken(''),
    UpdateAppState.set(ff.AppState.tokenSesion, ''),
    UpdateAppState.set(ff.AppState.sesionIniciada, false),
    Navigate(ff.Pages.iniciarSesion),
  ];
  List<DslAction> cargarReportes(String salidaUrl, String salida) {
    final lista = ActionOutput(salida);
    return [
      leerUrl(salidaUrl),
      If(
        conServidor(salidaUrl),
        then: [
          If(
            Not(Equals(token, '')),
            then: [
              CallCustomAction.named(
                'listarMisReportes',
                args: {'urlApi': string, 'token': string},
                returnType: ff.Structs.resultadoReportes,
                arguments: {'urlApi': url(salidaUrl), 'token': token},
                outputAs: salida,
              ),
              If(
                lista['exito'],
                then: [UpdateAppState.set(ff.AppState.reportes, lista['reportes'])],
                orElse: [
                  If(
                    sesionRechazada(lista),
                    then: [
                      Snackbar(lista['mensaje']),
                      UpdateAppState.clear(ff.AppState.reportes),
                      ...cerrarSesionLocal(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }

  // ---- Navegación al detalle: pasa el id del servidor y el folio ----------
  // Copia el paso del parámetro 'descripcion' (que ya lee el campo del
  // reporte de la lista) para 'idServidor' y 'folio'.
  app.raw((project) {
    final reporte = project.backend.dataSchemaConfig.dataStructs
        .firstWhere((s) => s.identifier.name == 'Reporte');
    final detalle = project.widgetClasses.values.firstWhere((p) => p.name == 'DetalleReporte');
    final parametrosDetalle = ff.Pages.detalleReporte.params;
    final parametros = {
      'descripcion': parametrosDetalle.descripcion.key,
      'idServidor': parametrosDetalle.idServidor.key,
      'folio': parametrosDetalle.folio.key,
    };
    void revisar(FFNode nodo) {
      for (final disparador in nodo.triggerActions) {
        final accion = disparador.rootAction.action;
        if (!accion.hasNavigate()) continue;
        final navegar = accion.navigate;
        if (navegar.pageNodeKeyRef.key != detalle.node.key) continue;
        final pasos = navegar.passedParameters.parameterPasses;
        final modelo = pasos[parametros['descripcion']];
        if (modelo == null) continue;
        for (final nombre in ['idServidor', 'folio']) {
          final clave = parametros[nombre]!;
          final campo = reporte.fields.firstWhere((f) => f.identifier.name == nombre);
          final paso = modelo.deepCopy();
          paso.paramIdentifier
            ..name = nombre
            ..key = clave;
          paso.variable.operations.first.accessDataStructField.fieldIdentifier
            ..name = nombre
            ..key = campo.identifier.key;
          pasos[clave] = paso;
        }
      }
      nodo.children.forEach(revisar);
    }

    for (final pagina in project.widgetClasses.values) {
      revisar(pagina.node);
    }
  });

  // ---- Iniciar sesión: restaura la sesión con GET /account/profile --------
  final perfilAlAbrir = ActionOutput('perfilAlAbrir');
  app.editPageOnLoad(ff.Pages.iniciarSesion, [
    If(
      AppState(ff.AppState.sesionIniciada),
      then: [
        leerUrl('urlAlAbrir'),
        If(
          conServidor('urlAlAbrir'),
          then: [
            CallCustomAction.named('leerTokenSeguro', returnType: string, outputAs: 'tokenGuardado'),
            UpdateAppState.set(
              ff.AppState.tokenSesion,
              CodeExpression(r't ?? ""', args: {'t': ActionOutput('tokenGuardado')}, returns: string),
            ),
            If(
              Equals(token, ''),
              then: [UpdateAppState.set(ff.AppState.sesionIniciada, false)],
              orElse: [
                SetState(estadoLogin.iniciando, true),
                CallCustomAction.named(
                  'obtenerPerfil',
                  args: {'urlApi': string, 'token': string},
                  returnType: usuarioSesion,
                  arguments: {'urlApi': url('urlAlAbrir'), 'token': token},
                  outputAs: 'perfilAlAbrir',
                ),
                SetState(estadoLogin.iniciando, false),
                If(
                  perfilAlAbrir['exito'],
                  then: [...guardarUsuario(perfilAlAbrir), Navigate(ff.Pages.inicio)],
                  orElse: [
                    If(
                      sesionRechazada(perfilAlAbrir),
                      then: [
                        guardarToken(''),
                        UpdateAppState.set(ff.AppState.tokenSesion, ''),
                        UpdateAppState.set(ff.AppState.sesionIniciada, false),
                        UpdateAppState.clear(ff.AppState.reportes),
                        Snackbar(perfilAlAbrir['mensaje']),
                      ],
                      // Sin red: entra con los datos guardados.
                      orElse: [Navigate(ff.Pages.inicio)],
                    ),
                  ],
                ),
              ],
            ),
          ],
          orElse: [Navigate(ff.Pages.inicio)],
        ),
      ],
    ),
  ]);

  app.editPage(ff.Pages.iniciarSesion, (page) {
    final sesion = ActionOutput('sesion');
    page.ensureActions(
      page.findByKey('Button_nqrvc46t'), // Iniciar sesión
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        ValidateForm('formLogin'),
        leerUrl('urlLogin'),
        If(
          conServidor('urlLogin'),
          then: [
            SetState(estadoLogin.iniciando, true),
            CallCustomAction.named(
              'iniciarSesionApi',
              args: {'urlApi': string, 'correo': string, 'contrasena': string},
              returnType: usuarioSesion,
              arguments: {
                'urlApi': url('urlLogin'),
                'correo': WidgetState('campoCorreo', WidgetStateProperty.text),
                'contrasena': WidgetState('campoContrasena', WidgetStateProperty.text),
              },
              outputAs: 'sesion',
            ),
            SetState(estadoLogin.iniciando, false),
            If(
              sesion['exito'],
              then: [
                guardarToken(
                  CodeExpression(r't ?? ""', args: {'t': sesion['token']}, returns: string),
                ),
                UpdateAppState.set(ff.AppState.tokenSesion, sesion['token']),
                ...guardarUsuario(sesion),
                // Los reportes de otra cuenta no se mezclan con los de esta.
                UpdateAppState.clear(ff.AppState.reportes),
                UpdateAppState.set(ff.AppState.sesionIniciada, true),
                ClearTextField('campoContrasena'),
                Navigate(ff.Pages.inicio),
              ],
              orElse: [Snackbar(sesion['mensaje'])],
            ),
          ],
          // Sin servidor: sesión simulada como antes.
          orElse: [
            UpdateAppState.set(
              ff.AppState.usuarioCorreo,
              WidgetState('campoCorreo', WidgetStateProperty.text),
            ),
            If(
              Equals(AppState(ff.AppState.usuarioNombre), ''),
              then: [UpdateAppState.set(ff.AppState.usuarioNombre, 'Ciudadano')],
            ),
            UpdateAppState.set(ff.AppState.sesionIniciada, true),
            Navigate(ff.Pages.inicio),
          ],
        ),
      ],
    );
  });

  // ---- Inicio y Mis reportes: lista del servidor ---------------------------
  app.editPageOnLoad(ff.Pages.inicio, cargarReportes('urlInicio', 'reportesInicio'));
  app.editPageOnLoad(ff.Pages.misReportes, cargarReportes('urlMisReportes', 'reportesServidor'));

  // ---- Detalle: foto (URL firmada temporal), folio e historial -------------
  final detalle = ActionOutput('detalle');
  app.editPageOnLoad(ff.Pages.detalleReporte, [
    leerUrl('urlDetalle'),
    If(
      conServidor('urlDetalle'),
      then: [
        If(
          Not(Equals(PageParam('idServidor'), '')),
          then: [
            CallCustomAction.named(
              'obtenerDetalleReporte',
              args: {'urlApi': string, 'token': string, 'idServidor': string},
              returnType: ff.Structs.detalleServidor,
              arguments: {
                'urlApi': url('urlDetalle'),
                'token': token,
                'idServidor': PageParam('idServidor'),
              },
              outputAs: 'detalle',
            ),
            If(
              detalle['exito'],
              then: [
                SetState(estadoDetalle.fotoUrl, detalle['fotoUrl']),
                SetState(estadoDetalle.historial, detalle['historial']),
              ],
              orElse: [
                If(
                  sesionRechazada(detalle),
                  then: [Snackbar(detalle['mensaje']), ...cerrarSesionLocal()],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ]);

  app.editPage(ff.Pages.detalleReporte, (page) {
    page.ensureInsertedAfter(
      page.findByKey('Container_zzqzsw14'), // TarjetaReporte
      Column(
        name: 'DatosDelServidor',
        crossAxis: CrossAxis.stretch,
        spacing: 12,
        children: [
          Text(
            CodeExpression(r'"Folio " + (f ?? "")', args: {'f': PageParam('folio')}, returns: string),
            name: 'TextoFolio',
            style: Styles.titleSmall,
            color: Colors.primary,
            visible: Not(Equals(PageParam('folio'), '')),
          ),
          Image(
            State(estadoDetalle.fotoUrl),
            name: 'FotoDelReporte',
            height: 220,
            fit: ImageFit.cover,
            borderRadius: 16,
            cached: false,
            visible: Not(Equals(State(estadoDetalle.fotoUrl), '')),
          ),
          Container(
            name: 'HistorialServidor',
            color: Colors.secondaryBackground,
            borderRadius: 16,
            padding: 16,
            visible: CodeExpression(
              r'(h ?? []).isNotEmpty',
              args: {'h': State(estadoDetalle.historial)},
              returns: bool_,
            ),
            child: Column(
              crossAxis: CrossAxis.start,
              spacing: 6,
              children: [
                Text('Historial', style: Styles.titleSmall),
                Text(
                  CodeExpression(
                    r'(h ?? []).map((l) => "• $l").join("\n")',
                    args: {'h': State(estadoDetalle.historial)},
                    returns: string,
                  ),
                  style: Styles.bodySmall,
                  color: Colors.secondaryText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });

  // ---- Perfil: 401 o 403 cierran la sesión; logout borra el token ---------
  final perfil = ActionOutput('perfil');
  app.editPageOnLoad(ff.Pages.perfil, [
    leerUrl('urlPerfil'),
    If(
      conServidor('urlPerfil'),
      then: [
        SetState(estadoPerfil.conServidor, true),
        If(
          Not(Equals(token, '')),
          then: [
            CallCustomAction.named(
              'obtenerPerfil',
              args: {'urlApi': string, 'token': string},
              returnType: usuarioSesion,
              arguments: {'urlApi': url('urlPerfil'), 'token': token},
              outputAs: 'perfil',
            ),
            If(
              perfil['exito'],
              then: guardarUsuario(perfil),
              orElse: [
                If(
                  sesionRechazada(perfil),
                  then: [
                    Snackbar(perfil['mensaje']),
                    UpdateAppState.clear(ff.AppState.reportes),
                    ...cerrarSesionLocal(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ]);

  app.editPage(ff.Pages.perfil, (page) {
    page.ensureActions(
      page.findByKey('Button_lnn3onsp'), // Cerrar sesión
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        ConfirmDialog(
          title: '¿Cerrar sesión?',
          message: 'Tendrás que volver a iniciar sesión para reportar.',
          confirmText: 'Cerrar sesión',
          dismissText: 'Cancelar',
          onConfirm: [
            leerUrl('urlSalir'),
            If(
              conServidor('urlSalir'),
              then: [
                // Primero el servidor; el token se borra aunque falle la red.
                CallCustomAction.named(
                  'cerrarSesionApi',
                  args: {'urlApi': string, 'token': string},
                  arguments: {'urlApi': url('urlSalir'), 'token': token},
                ),
                UpdateAppState.clear(ff.AppState.reportes),
              ],
            ),
            ...cerrarSesionLocal(),
          ],
        ),
      ],
    );
  });
}

/// Vacía la cadena de Cerrar sesión para reescribirla con los textos nuevos
/// del diálogo (el script conserva los argumentos de cadenas existentes).
// ignore: unused_element
void _vaciarCerrarSesion(App app) {
  app.editPage(ff.Pages.perfil, (page) {
    page.ensureActions(
      page.findByKey('Button_lnn3onsp'),
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [],
    );
  });
}

/// El script conserva los argumentos de una cadena que ya existe; para
/// reemplazarla se vacía primero en una subida y se reescribe en la siguiente.
// ignore: unused_element
void _vaciarEnviar(App app) {
  app.editPage(ff.Pages.reportar, (page) {
    page.ensureActions(
      page.findByKey('Button_hqlzt1r5'),
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [],
    );
  });
}

// ignore: unused_element
void _noticiasConMiniaturas(App app) {
  final blanco = Colors.secondaryBackground;

  // Los títulos heredaban el color 'info' (azul) del tema por defecto.
  app.typography('titleLarge', fontSize: 20, fontWeight: 700, color: 0xFF1A1A1E);
  app.typography('titleMedium', fontSize: 17, fontWeight: 600, color: 0xFF1A1A1E);
  app.typography('titleSmall', fontSize: 15, fontWeight: 600, color: 0xFF1A1A1E);

  app.raw((project) {
    final endpoints = project.backend.apiConfig.endpoints;

    // Nominatim responde 403 al User-Agent por defecto de Dart: la app se
    // identifica en cada consulta.
    const agente = 'User-Agent: CityCareMX/1.0 (mx.citycare.app; proyecto escolar)';
    final direccion = endpoints.firstWhere((e) => e.identifier.name == 'DireccionDesdeCoordenadas');
    if (!direccion.headers.any((h) => h.startsWith('User-Agent:'))) {
      direccion.headers.add(agente);
    }

    // Noticias con imagen: el RSS de UDG TV trae una foto en cada nota
    // (El Informador no incluye imágenes).
    endpoints.firstWhere((e) => e.identifier.name == 'NoticiasGuadalajara').url =
        'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fudgtv.com%2Ffeed%2F';

    // Noticia.content (HTML de la nota): de aquí sale la miniatura. El SDK no
    // expone un helper para agregar campos a un struct existente, así que se
    // copia el campo 'description' (texto) con nombre y clave nuevos.
    final noticia = project.backend.dataSchemaConfig.dataStructs
        .firstWhere((s) => s.identifier.name == 'Noticia');
    if (!noticia.fields.any((f) => f.identifier.name == 'content')) {
      final campo = noticia.fields
          .firstWhere((f) => f.identifier.name == 'description')
          .deepCopy();
      campo.identifier.name = 'content';
      campo.identifier.key = _claveNueva();
      campo.description = 'Noticia.content';
      noticia.fields.add(campo);
    }

    // Etiquetas visibles en la barra de navegación inferior.
    project.navBar.showSelectedLabels = true;
    project.navBar.showUnselectedLabels = true;
    const etiquetas = {
      'Inicio': 'Inicio',
      'Reportar': 'Reportar',
      'MisReportes': 'Mis reportes',
      'Noticias': 'Noticias',
      'Perfil': 'Perfil',
    };
    for (final pagina in project.widgetClasses.values) {
      final etiqueta = etiquetas[pagina.name];
      if (etiqueta == null) continue;
      final texto = pagina.node.props.scaffold.ensureNavBarItem().ensureLabel().ensureTextValue();
      texto.inputValue = etiqueta;
      texto.mostRecentInputValue = etiqueta;
    }
  });

  // Tarjeta de noticia con miniatura a la izquierda.
  app.editComponentParams(ff.Components.tarjetaNoticia, (params) {
    params.ensureParam('imagen', string.withDefault(''));
  });
  app.editComponent(ff.Components.tarjetaNoticia, (tarjeta) {
    tarjeta.ensureReplaced(
      tarjeta.findByKey('Container_7wsfoye3'),
      Container(
        name: 'TarjetaNoticiaFondo',
        onTap: LaunchUrl(Param('enlace')),
        color: blanco,
        borderRadius: 18,
        padding: 12,
        shadow: Shadow(blur: 12, dy: 4, color: Colors.hex(0x0F000000)),
        child: Row(
          spacing: 12,
          crossAxis: CrossAxis.start,
          children: [
            Image(
              Param('imagen'),
              width: 96,
              height: 96,
              fit: ImageFit.cover,
              borderRadius: 12,
              visible: Not(Equals(Param('imagen'), '')),
            ),
            Container(
              visible: Equals(Param('imagen'), ''),
              width: 96,
              height: 96,
              borderRadius: 12,
              color: Colors.accent1,
              alignment: Alignment.center,
              child: Icon('newspaper', size: 32, color: Colors.primary),
            ),
            Expanded(
              Column(
                crossAxis: CrossAxis.start,
                spacing: 6,
                children: [
                  Text(
                    Param('fecha'),
                    style: Styles.labelSmall,
                    color: Colors.secondaryText,
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
                    maxLines: 2,
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
          ],
        ),
      ),
    );
  });

  // Requiere que el parámetro 'imagen' ya exista en el proyecto (se agregó
  // en un push anterior con editComponentParams).
  _listaConMiniaturas(app);

  app.editPage(ff.Pages.noticias, (page) {
    page.update(page.findByKey('Text_868x3wgq'), (texto) {
      texto.text('Fuente: UDG TV');
    });
  });
}

/// Lista de noticias que pasa la primera imagen del HTML de cada nota.
void _listaConMiniaturas(App app) {
  final fechaNoticia = CustomFunctionHandle(
    name: 'fechaNoticia',
    args: {'pubDate': string},
    returnType: string,
  );
  app.editPage(ff.Pages.noticias, (page) {
    page.ensureReplaced(
      page.findByKey('ListView_gntp3pcw'),
      Expanded(
        name: 'ListaNoticias',
        ListView(
          source: State(ff.Pages.noticias.state.noticias),
          visible: Not(State(ff.Pages.noticias.state.cargando)),
          spacing: 12,
          padding: EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 20),
          itemBuilder: (item) => ff.Components.tarjetaNoticia(
            titulo: item['title'],
            resumen: item['description'],
            autor: item['author'],
            fecha: CustomFunction(fechaNoticia, args: {'pubDate': item['pubDate']}),
            enlace: item['link'],
            imagen: CodeExpression(
              r'''RegExp('<img[^>]+src="([^"]+)"').firstMatch(html ?? "")?.group(1) ?? ""''',
              args: {'html': item['content']},
              returns: string,
            ),
          ),
        ),
      ),
    );
  });
}

// ---------------------------------------------------------------------------
// Correcciones del reporte · fase 1: datos y código personalizado
// ---------------------------------------------------------------------------

/// Struct, funciones, acciones y estado de página que usa la fase 2.
// ignore: unused_element
void _reporteFase1(App app) {
  // Resultado de leer el GPS. estado: ok | servicio_desactivado |
  // permiso_denegado | permiso_denegado_siempre | error.
  final ubicacionGps = app.struct('UbicacionGps', {
    'estado': string,
    'latitud': double_,
    'longitud': double_,
    'precision': double_,
  });

  // Lee el GPS sin sustituir el error por una ubicación predeterminada.
  app.customAction(
    'obtenerUbicacionGps',
    returns: ubicacionGps,
    description: 'Lee el GPS y devuelve estado, coordenadas y precisión; nunca usa una ubicación predeterminada.',
    code: r'''
import 'package:geolocator/geolocator.dart';

Future<UbicacionGpsStruct> obtenerUbicacionGps() async {
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
''',
  );

  app.customAction(
    'abrirAjustesUbicacion',
    args: {'motivo': string},
    description: 'Abre los ajustes de ubicación del teléfono o los permisos de la app.',
    code: r'''
import 'package:geolocator/geolocator.dart';

Future<void> abrirAjustesUbicacion(String motivo) async {
  if (motivo == 'servicio_desactivado') {
    await Geolocator.openLocationSettings();
  } else {
    await Geolocator.openAppSettings();
  }
}
''',
  );

  app.customFunction(
    'coordenadasValidas',
    args: {'lat': double_, 'lon': double_},
    returns: bool_,
    description: 'true si las coordenadas existen, están en rango y no son 0,0.',
    code: r'''
if (lat == null || lon == null || lat.isNaN || lon.isNaN) return false;
if (lat < -90 || lat > 90 || lon < -180 || lon > 180) return false;
return !(lat == 0 && lon == 0);
''',
  );

  app.customFunction(
    'validarFoto',
    args: {'foto': uploadedFile},
    returns: string,
    description: 'Mensaje de error de la foto (vacía, más de 10 MB o no JPG/PNG); cadena vacía si es válida.',
    code: r'''
final bytes = foto?.bytes;
if (bytes == null || bytes.isEmpty) {
  return 'Agrega una fotografía clara del problema.';
}
if (bytes.length > 10 * 1024 * 1024) {
  return 'La fotografía pesa más de 10 MB. Toma otra o elige una más ligera.';
}
final esJpeg = bytes.length > 3 &&
    bytes[0] == 0xFF &&
    bytes[1] == 0xD8 &&
    bytes[2] == 0xFF;
final esPng = bytes.length > 8 &&
    bytes[0] == 0x89 &&
    bytes[1] == 0x50 &&
    bytes[2] == 0x4E &&
    bytes[3] == 0x47;
if (!esJpeg && !esPng) {
  return 'La fotografía debe ser JPG o PNG.';
}
return '';
''',
  );

  // Folio provisional mientras no hay backend (el definitivo lo asigna él).
  app.customFunction(
    'generarFolio',
    args: {'consecutivo': int_, 'fecha': dateTime},
    returns: string,
    description: 'Folio local CC-AAAA-000001 hasta que el backend devuelva el suyo.',
    code: r'''
final anio = (fecha ?? DateTime.now()).year;
final numero = (consecutivo ?? 1).toString().padLeft(6, '0');
return 'CC-$anio-$numero';
''',
  );

  // Una lectura fallida conserva null en lugar de convertirse en 0.0.
  app.editCustomFunction('latitudDe', (codigo) {
    codigo.replaceCode('return ubicacion?.latitude;');
  });
  app.editCustomFunction('longitudDe', (codigo) {
    codigo.replaceCode('return ubicacion?.longitude;');
  });

  // Reporte: folio, precisión y origen de la ubicación (los pide el backend).
  app.raw((project) {
    final reporte = project.backend.dataSchemaConfig.dataStructs
        .firstWhere((s) => s.identifier.name == 'Reporte');
    void agregarCampo(String modelo, String nombre) {
      if (reporte.fields.any((f) => f.identifier.name == nombre)) return;
      final campo = reporte.fields
          .firstWhere((f) => f.identifier.name == modelo)
          .deepCopy();
      campo.identifier.name = nombre;
      campo.identifier.key = _claveNueva();
      campo.description = 'Reporte.$nombre';
      reporte.fields.add(campo);
    }

    agregarCampo('direccion', 'folio');
    agregarCampo('direccion', 'origenUbicacion');
    agregarCampo('latitud', 'precisionUbicacion');
  });

  app.editPageState(ff.Pages.reportar, (estado) {
    estado.ensureField('estadoUbicacion', string.withDefault('buscando'));
    estado.ensureField('textoUbicacion', string.withDefault('Detectando tu ubicación...'));
    estado.ensureField('precisionUbicacion', double_);
    estado.ensureField('origenUbicacion', string.withDefault(''));
    estado.ensureField('errorFoto', string.withDefault(''));
    estado.ensureField('folio', string.withDefault(''));
  });
}

// ---------------------------------------------------------------------------
// Correcciones del reporte · fase 2: pantalla Reportar
// ---------------------------------------------------------------------------

const _avisoGpsDesactivado = 'Activa la ubicación para poder enviar el reporte.';
const _avisoPermiso =
    'Necesitamos permiso de ubicación para registrar dónde ocurrió la incidencia.';

/// GPS con errores específicos, foto validada, descripción obligatoria solo
/// para "Otro" y botón Enviar bloqueado sin coordenadas válidas.
// ignore: unused_element
void _reporteFase2(App app) {
  final pagina = ff.Pages.reportar;
  final estado = pagina.state;
  final blanco = Colors.secondaryBackground;

  final coordenadasValidas = CustomFunctionHandle(
    name: 'coordenadasValidas',
    args: {'lat': double_, 'lon': double_},
    returnType: bool_,
  );
  final validarFoto = CustomFunctionHandle(
    name: 'validarFoto',
    args: {'foto': uploadedFile},
    returnType: string,
  );
  final generarFolio = CustomFunctionHandle(
    name: 'generarFolio',
    args: {'consecutivo': int_, 'fecha': dateTime},
    returnType: string,
  );
  final textoCoordenadas = CustomFunctionHandle(
    name: 'textoCoordenadas',
    args: {'lat': double_, 'lon': double_},
    returnType: string,
  );
  final urlMapa = CustomFunctionHandle(
    name: 'urlMapa',
    args: {'lat': double_, 'lon': double_},
    returnType: string,
  );
  final geocodificar = Endpoint.get(
    'DireccionDesdeCoordenadas',
    'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=[lat]&lon=[lon]&zoom=18&accept-language=es',
    variables: {'lat': double_, 'lon': double_},
    response: ff.Structs.direccionOSM,
  );

  // Lee el GPS; solo con estado "ok" guarda coordenadas y busca la dirección.
  // Si OpenStreetMap falla, el reporte se puede enviar con dirección vacía.
  List<DslAction> detectarUbicacion(String sufijo) {
    final gps = ActionOutput('gps$sufijo');
    return [
      SetState(estado.buscandoUbicacion, true),
      SetState(estado.ubicacionLista, false),
      SetState(estado.estadoUbicacion, 'buscando'),
      SetState(estado.textoUbicacion, 'Detectando tu ubicación...'),
      SetState(estado.direccion, ''),
      SetState(estado.origenUbicacion, ''),
      SetState.clear(estado.latitud),
      SetState.clear(estado.longitud),
      SetState.clear(estado.precisionUbicacion),
      CallCustomAction.named(
        'obtenerUbicacionGps',
        returnType: ff.Structs.ubicacionGps,
        outputAs: 'gps$sufijo',
      ),
      SetState(estado.estadoUbicacion, gps['estado']),
      If(
        Equals(State(estado.estadoUbicacion), 'ok'),
        then: [
          SetState(estado.latitud, gps['latitud']),
          SetState(estado.longitud, gps['longitud']),
          SetState(estado.precisionUbicacion, gps['precision']),
          SetState(estado.origenUbicacion, 'gps'),
          SetState(estado.ubicacionLista, true),
          ApiCall(
            geocodificar,
            outputAs: 'direccion$sufijo',
            params: {'lat': State(estado.latitud), 'lon': State(estado.longitud)},
            onSuccess: (res) => [
              SetState(estado.direccion, res['display_name']),
              SetState(estado.textoUbicacion, res['display_name']),
              SetState(estado.buscandoUbicacion, false),
            ],
            onFailure: [
              SetState(estado.textoUbicacion,
                'Ubicación detectada. No pudimos obtener la dirección, pero puedes enviar el reporte.',
              ),
              SetState(estado.buscandoUbicacion, false),
            ],
          ),
        ],
        orElse: [
          If(
            Equals(State(estado.estadoUbicacion), 'servicio_desactivado'),
            then: [SetState(estado.textoUbicacion, _avisoGpsDesactivado)],
            orElse: [
              If(
                Equals(State(estado.estadoUbicacion), 'permiso_denegado'),
                then: [
                  SetState(estado.textoUbicacion, '$_avisoPermiso Toca Reintentar y elige «Permitir».'),
                ],
                orElse: [
                  If(
                    Equals(State(estado.estadoUbicacion), 'permiso_denegado_siempre'),
                    then: [
                      SetState(estado.textoUbicacion,
                        '$_avisoPermiso Actívalo en la configuración de la app.',
                      ),
                    ],
                    orElse: [
                      SetState(estado.textoUbicacion,
                        'No pudimos leer tu ubicación. Revisa que el GPS esté activo y toca Reintentar.',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SetState(estado.buscandoUbicacion, false),
        ],
      ),
    ];
  }

  DslWidget botonAjuste(String texto, String icono, String nombre, String motivo) => Button(
    texto,
    name: nombre,
    icon: icono,
    width: double.infinity,
    height: 44,
    color: Colors.primary,
    textColor: blanco,
    borderRadius: 12,
    visible: Equals(State(estado.estadoUbicacion), motivo),
    onTap: CallCustomAction.named(
      'abrirAjustesUbicacion',
      args: {'motivo': string},
      arguments: {'motivo': motivo},
    ),
  );

  app.editPageOnLoad(pagina, detectarUbicacion('Inicial'));

  app.editPage(pagina, (page) {
    // 3. Ubicación: estado del GPS, precisión y acciones para corregirlo.
    page.ensureReplaced(
      page.findByKey('Container_je5tsdb3'),
      Container(
        name: 'TarjetaUbicacion',
        color: blanco,
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
                Container(
                  width: 48,
                  height: 48,
                  borderRadius: 14,
                  color: Colors.accent1,
                  alignment: Alignment.center,
                  child: Icon('my_location', size: 24, color: Colors.primary),
                ),
                Expanded(
                  Column(
                    crossAxis: CrossAxis.start,
                    spacing: 2,
                    children: [
                      Text(
                        'Ubicación del reporte',
                        style: Styles.labelMedium,
                        color: Colors.secondaryText,
                      ),
                      Text(
                        State(estado.textoUbicacion),
                        style: Styles.titleSmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ProgressBar.circular(
                  size: 22,
                  thickness: 3,
                  visible: State(estado.buscandoUbicacion),
                ),
                Container(
                  visible: Not(State(estado.buscandoUbicacion)),
                  child: IconButton(
                    'refresh',
                    size: 24,
                    color: Colors.primary,
                    visible: State(estado.ubicacionLista),
                    onTap: detectarUbicacion('Actualizada'),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8,
              visible: State(estado.ubicacionLista),
              children: [
                Expanded(
                  Column(
                    crossAxis: CrossAxis.start,
                    spacing: 2,
                    children: [
                      Text(
                        CustomFunction(
                          textoCoordenadas,
                          args: {'lat': State(estado.latitud), 'lon': State(estado.longitud)},
                        ),
                        style: Styles.labelSmall,
                        color: Colors.secondaryText,
                      ),
                      Text(
                        CodeExpression(
                          r'"Precisión aproximada: ±${(p ?? 0).round()} m"',
                          args: {'p': State(estado.precisionUbicacion)},
                          returns: string,
                        ),
                        style: Styles.labelSmall,
                        color: Colors.secondaryText,
                      ),
                    ],
                  ),
                ),
                Container(
                  onTap: LaunchUrl(
                    CustomFunction(
                      urlMapa,
                      args: {'lat': State(estado.latitud), 'lon': State(estado.longitud)},
                    ),
                  ),
                  child: Text('Ver en mapa', style: Styles.titleSmall, color: Colors.primary),
                ),
              ],
            ),
            Container(
              visible: Not(State(estado.buscandoUbicacion)),
              child: Column(
                crossAxis: CrossAxis.stretch,
                spacing: 8,
                visible: Not(State(estado.ubicacionLista)),
                children: [
                  Button(
                    'Reintentar',
                    name: 'BotonReintentarUbicacion',
                    icon: 'refresh',
                    width: double.infinity,
                    height: 44,
                    color: Colors.accent1,
                    textColor: Colors.primary,
                    borderRadius: 12,
                    onTap: detectarUbicacion('Reintento'),
                  ),
                  botonAjuste(
                    'Activar ubicación',
                    'location_on',
                    'BotonActivarUbicacion',
                    'servicio_desactivado',
                  ),
                  botonAjuste(
                    'Abrir configuración',
                    'settings',
                    'BotonAbrirConfiguracion',
                    'permiso_denegado_siempre',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // 2. Evidencia: valida que exista, sea JPG/PNG y pese máximo 10 MB.
    // Cancelar la cámara ya no marca la foto como agregada.
    page.ensureActions(
      page.findByKey('Container_d462p7t6'),
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        UploadData(
          key: 'subirFoto',
          source: UploadSource.galleryOrCamera,
          allowPhoto: true,
          destination: UploadDestination.localFile,
          actionName: 'fotoReporte',
        ),
        SetState(estado.errorFoto,
          CustomFunction(validarFoto, args: {'foto': ActionResult.uploadedFile('subirFoto')}),
        ),
        If(
          Equals(State(estado.errorFoto), ''),
          then: [SetState(estado.fotoCargada, true)],
          orElse: [
            SetState(estado.fotoCargada, false),
            ClearUploadedData('fotoReporte'),
          ],
        ),
      ],
    );
    page.ensureInsertedAfter(
      page.findByKey('Container_d462p7t6'),
      Text(
        State(estado.errorFoto),
        name: 'TextoErrorFoto',
        style: Styles.bodySmall,
        color: Colors.error,
        visible: Not(Equals(State(estado.errorFoto), '')),
      ),
    );

    // 4. Descripción: obligatoria solo con la categoría "Otro".
    page.update(page.findByKey('Text_qb4riwc1'), (texto) {
      texto.text('Obligatoria si eliges «Otro»; en las demás categorías es opcional.');
    });

    // Enviar: bloqueado hasta tener coordenadas válidas del GPS.
    final enviar = page.findByKey('Button_hqlzt1r5');
    page.bindDisabled(enviar, Not(State(estado.ubicacionLista)));
    page.ensureInsertedAfter(
      enviar,
      Text(
        'Para enviar el reporte necesitamos la ubicación del GPS.',
        name: 'TextoEnviarSinUbicacion',
        style: Styles.bodySmall,
        color: Colors.secondaryText,
        textAlign: TextAlign.center,
        visible: Not(State(estado.ubicacionLista)),
      ),
    );
    page.ensureActions(
      enviar,
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        ValidateForm('formReporte'),
        If(
          Not(State(estado.fotoCargada)),
          then: [Snackbar('Agrega una fotografía clara del problema.')],
          orElse: [
            If(
              CodeExpression(
                r'''c == 'Otro' && (t ?? '').trim().isEmpty''',
                args: {
                  'c': State(estado.categoria),
                  't': WidgetState('campoDescripcion', WidgetStateProperty.text),
                },
                returns: bool_,
              ),
              then: [Snackbar('Describe brevemente el problema que deseas reportar.')],
              orElse: [
                If(
                  Not(CustomFunction(
                    coordenadasValidas,
                    args: {'lat': State(estado.latitud), 'lon': State(estado.longitud)},
                  )),
                  then: [Snackbar(_avisoGpsDesactivado)],
                  orElse: [
                    // TODO backend: POST /api/v1/reports (multipart) y usar
                    // el folio de la respuesta 201 en lugar del local.
                    SetState(estado.folio,
                      CustomFunction(generarFolio, args: {
                        'consecutivo': CodeExpression(
                          '(r ?? []).length + 1',
                          args: {'r': AppState(ff.AppState.reportes)},
                          returns: int_,
                        ),
                        'fecha': Global(GlobalProperty.currentTimestamp),
                      }),
                    ),
                    UpdateAppState.insertAtIndex(
                      ff.AppState.reportes,
                      0,
                      Struct(ff.Structs.reporte, {
                        'folio': State(estado.folio),
                        'categoria': State(estado.categoria),
                        'descripcion': WidgetState('campoDescripcion', WidgetStateProperty.text),
                        'direccion': State(estado.direccion),
                        'latitud': State(estado.latitud),
                        'longitud': State(estado.longitud),
                        'precisionUbicacion': State(estado.precisionUbicacion),
                        'origenUbicacion': State(estado.origenUbicacion),
                        'estado': 'Pendiente',
                        'fecha': Global(GlobalProperty.currentTimestamp),
                        'tieneFoto': true,
                      }),
                    ),
                    ClearTextField('campoDescripcion'),
                    ResetFormField('campoCategoria'),
                    SetState(estado.categoria, ''),
                    ClearUploadedData('fotoReporte'),
                    SetState(estado.fotoCargada, false),
                    SetState(estado.errorFoto, ''),
                    ShowDialog.message(
                      title: '¡Reporte enviado!',
                      message: CodeExpression(
                        r'"Tu folio es $f. Puedes darle seguimiento en Mis reportes."',
                        args: {'f': State(estado.folio)},
                        returns: string,
                      ),
                      dismissText: 'Ver mis reportes',
                    ),
                    Navigate(ff.Pages.misReportes),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  });
}


// ---------------------------------------------------------------------------
// Correcciones del reporte · fase 3: dependencias y valores iniciales
// ---------------------------------------------------------------------------

/// Al dejar de usar la ubicación integrada de FlutterFlow, el proyecto perdió
/// geolocator y el permiso de ubicación; aquí se declaran explícitamente.
// ignore: unused_element
void _reporteFase3(App app) {
  app.raw((project) {
    if (findPubDependency(project, name: 'geolocator') == null) {
      addPubDependency(project, name: 'geolocator', version: '14.0.1');
    }

    // Permiso de ubicación (Configuración › Permisos): agrega
    // ACCESS_FINE_LOCATION en Android y el mensaje de iOS.
    final permisos = project.ensureAppSettings().ensurePermissionsSettings();
    if (!permisos.permissionMessages
        .any((p) => p.permissionType == FFPermissionType.LOCATION)) {
      const mensaje =
          'CityCare usa tu ubicación para registrar dónde ocurrió la incidencia que reportas.';
      permisos.permissionMessages.add(
        FFPermissionsSettings_PermissionMessage()
          ..permissionType = FFPermissionType.LOCATION
          ..message = (FFText()
            ..textValue = (FFStringValue()
              ..inputValue = mensaje
              ..mostRecentInputValue = mensaje)),
      );
    }

    // FlutterFlow solo declara la ubicación en el AndroidManifest cuando se
    // usa su ubicación integrada; con código propio se agrega como permiso
    // personalizado (Android 12+ exige FINE y COARSE juntos).
    void permisoPropio(String android, String ios) {
      if (permisos.userDefinedPermissions.any((p) => p.names.androidName == android)) return;
      const mensaje =
          'CityCare usa tu ubicación para registrar dónde ocurrió la incidencia que reportas.';
      permisos.userDefinedPermissions.add(
        FFPermissionsSettings_UserDefinedPermission()
          ..type = FFPermissionType.CUSTOM
          ..names = (FFPermissionsSettings_UserDefinedPermission_PermissionNames()
            ..androidName = android
            ..iosName = ios)
          ..message = (FFText()
            ..textValue = (FFStringValue()
              ..inputValue = mensaje
              ..mostRecentInputValue = mensaje)),
      );
    }

    permisoPropio('android.permission.ACCESS_FINE_LOCATION', 'NSLocationWhenInUseUsageDescription');
    permisoPropio('android.permission.ACCESS_COARSE_LOCATION', '');

    // Sin valor inicial: una lectura borrada queda en null, no en 0,0.
    final reportar = project.widgetClasses.values.firstWhere((c) => c.name == 'Reportar');
    for (final campo in reportar.classModel.stateFields) {
      switch (campo.parameter.identifier.name) {
        case 'latitud' || 'longitud':
          campo.serializedDefaultValue.clear();
        case 'direccion':
          campo.serializedDefaultValue
            ..clear()
            ..add('');
      }
    }
  });

  // Con el permiso negado para siempre no aparece ningún diálogo; la acción
  // hace que FlutterFlow declare el permiso de ubicación en Android e iOS.
  app.editPage(ff.Pages.reportar, (page) {
    page.ensureActions(
      page.findByKey('Button_fdg77om7'), // BotonAbrirConfiguracion
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        RequestPermissions(permission: PermissionKind.location),
        CallCustomAction.named(
          'abrirAjustesUbicacion',
          args: {'motivo': string},
          arguments: {'motivo': 'permiso_denegado_siempre'},
        ),
      ],
    );
  });
}


// ---------------------------------------------------------------------------
// Envío al backend · fase 4a: datos y código (contrato 3.1)
// ---------------------------------------------------------------------------

/// Acción que envía el reporte en multipart con token Bearer, constante con la
/// URL del backend (vacía = modo sin servidor) y token de sesión.
// ignore: unused_element
void _envioFase4a(App app) {
  final resultadoEnvio = app.struct('ResultadoEnvio', {
    'exito': bool_,
    'codigoHttp': int_,
    'id': int_,
    'folio': string,
    'estado': string,
    'estadoEvidencia': string,
    'creadoEn': string,
    'mensaje': string,
  });

  app.customAction(
    'enviarReporte',
    args: {
      'urlApi': string,
      'token': string,
      'categoria': string,
      'descripcion': string,
      'direccion': string,
      'latitud': double_,
      'longitud': double_,
      'precisionUbicacion': double_,
      'origenUbicacion': string,
      'foto': uploadedFile,
    },
    returns: resultadoEnvio,
    description: 'POST {urlApi}/reports (multipart + Bearer). Devuelve folio o un mensaje de error en español.',
    code: r'''
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// POST {urlApi}/reports en multipart/form-data con token Bearer
/// (contrato 3.1). Devuelve el folio o un mensaje de error en español.
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
  String mensajeDeError(int codigo, String cuerpo) {
    final campo = RegExp(r'"field"\s*:\s*"([A-Za-z]+)"').firstMatch(cuerpo)?.group(1);
    if (codigo == 401 || cuerpo.contains('E_UNAUTHORIZED_ACCESS')) {
      return 'Tu sesión venció. Inicia sesión nuevamente.';
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
    if (codigo == 422) {
      return 'Revisa los datos del reporte e inténtalo de nuevo.';
    }
    if (codigo >= 500) {
      return 'El servidor no pudo guardar el reporte. Inténtalo más tarde.';
    }
    return 'No se pudo enviar el reporte (error $codigo). Inténtalo otra vez.';
  }

  try {
    final base = urlApi.trim().replaceAll(RegExp(r'/+$'), '');
    final solicitud = http.MultipartRequest('POST', Uri.parse('$base/reports'))
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..fields['categoria'] = categoria
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
      estado: '${datos['estado'] ?? 'Pendiente'}',
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
''',
  );

  app.customFunction(
    'fechaDesdeIso',
    args: {'texto': string},
    returns: dateTime,
    description: 'Convierte la fecha ISO 8601 del backend a la hora local.',
    code: r'''return DateTime.tryParse(texto ?? '')?.toLocal() ?? DateTime.now();''',
  );

  // Vacía mientras no haya servidor: el reporte se guarda solo en el teléfono.
  app.constant(
    'urlApi',
    '',
    description: 'URL base del backend con /api/v1 (ej. https://xxxx.ngrok-free.app/api/v1). Vacía = modo sin servidor.',
  );
  app.state('tokenSesion', string.withDefault(''), persisted: true);

  app.editPageState(ff.Pages.reportar, (estado) {
    estado.ensureField('enviando', bool_.withDefault(false));
  });
}

// ---------------------------------------------------------------------------
// Envío al backend · fase 4b: botón Enviar y cierre de sesión
// ---------------------------------------------------------------------------

/// Enviar usa el backend cuando la constante urlApi tiene valor; si está
/// vacía conserva el guardado local. 401 cierra la sesión.
// ignore: unused_element
void _envioFase4b(App app) {
  final pagina = ff.Pages.reportar;
  final estado = pagina.state;

  // El script no resuelve constantes ya existentes; esta acción lee la
  // constante urlApi (Valores de la app › Constantes) en tiempo de ejecución.
  app.customAction(
    'urlServidor',
    returns: string,
    description: 'Devuelve la constante urlApi sin espacios; vacía = modo sin servidor.',
    code: r'''
Future<String> urlServidor() async {
  return FFAppConstants.urlApi.trim();
}
''',
  );

  final coordenadasValidas = CustomFunctionHandle(
    name: 'coordenadasValidas',
    args: {'lat': double_, 'lon': double_},
    returnType: bool_,
  );
  final generarFolio = CustomFunctionHandle(
    name: 'generarFolio',
    args: {'consecutivo': int_, 'fecha': dateTime},
    returnType: string,
  );
  final fechaDesdeIso = CustomFunctionHandle(
    name: 'fechaDesdeIso',
    args: {'texto': string},
    returnType: dateTime,
  );
  final descripcion = WidgetState('campoDescripcion', WidgetStateProperty.text);
  final envio = ActionOutput('envio');

  Struct reporteLocal({required Object folio, required Object estadoReporte, required Object fecha}) =>
      Struct(ff.Structs.reporte, {
        'folio': folio,
        'categoria': State(estado.categoria),
        'descripcion': descripcion,
        'direccion': State(estado.direccion),
        'latitud': State(estado.latitud),
        'longitud': State(estado.longitud),
        'precisionUbicacion': State(estado.precisionUbicacion),
        'origenUbicacion': State(estado.origenUbicacion),
        'estado': estadoReporte,
        'fecha': fecha,
        'tieneFoto': true,
      });

  // Limpia el formulario, muestra el folio y abre Mis reportes.
  List<DslAction> cerrarEnvio() => [
    ClearTextField('campoDescripcion'),
    ResetFormField('campoCategoria'),
    SetState(estado.categoria, ''),
    ClearUploadedData('fotoReporte'),
    SetState(estado.fotoCargada, false),
    SetState(estado.errorFoto, ''),
    ShowDialog.message(
      title: '¡Reporte enviado!',
      message: CodeExpression(
        r'"Tu folio es $f. Puedes darle seguimiento en Mis reportes."',
        args: {'f': State(estado.folio)},
        returns: string,
      ),
      dismissText: 'Ver mis reportes',
    ),
    Navigate(ff.Pages.misReportes),
  ];

  // Sin servidor: folio provisional y guardado solo en el teléfono.
  final guardarLocal = <DslAction>[
    SetState(
      estado.folio,
      CustomFunction(generarFolio, args: {
        'consecutivo': CodeExpression(
          '(r ?? []).length + 1',
          args: {'r': AppState(ff.AppState.reportes)},
          returns: int_,
        ),
        'fecha': Global(GlobalProperty.currentTimestamp),
      }),
    ),
    UpdateAppState.insertAtIndex(
      ff.AppState.reportes,
      0,
      reporteLocal(
        folio: State(estado.folio),
        estadoReporte: 'Pendiente',
        fecha: Global(GlobalProperty.currentTimestamp),
      ),
    ),
    ...cerrarEnvio(),
  ];

  // Con servidor: POST /reports; el folio, el estado y la fecha los da él.
  final enviarAlServidor = <DslAction>[
    SetState(estado.enviando, true),
    CallCustomAction.named(
      'enviarReporte',
      key: 'llamadaEnviarReporte',
      args: {
        'urlApi': string,
        'token': string,
        'categoria': string,
        'descripcion': string,
        'direccion': string,
        'latitud': double_,
        'longitud': double_,
        'precisionUbicacion': double_,
        'origenUbicacion': string,
        'foto': uploadedFile,
      },
      returnType: ff.Structs.resultadoEnvio,
      arguments: {
        'urlApi': CodeExpression(
          r'u ?? ""',
          args: {'u': ActionOutput('urlServidor')},
          returns: string,
        ),
        'token': AppState(ff.AppState.tokenSesion),
        'categoria': CodeExpression(r'c ?? ""', args: {'c': State(estado.categoria)}, returns: string),
        'descripcion': descripcion,
        'direccion': CodeExpression(r'd ?? ""', args: {'d': State(estado.direccion)}, returns: string),
        'latitud': CodeExpression('l ?? 0.0', args: {'l': State(estado.latitud)}, returns: double_),
        'longitud': CodeExpression('l ?? 0.0', args: {'l': State(estado.longitud)}, returns: double_),
        // -1 = sin dato: la acción no envía la precisión.
        'precisionUbicacion': CodeExpression(
          'p ?? -1.0',
          args: {'p': State(estado.precisionUbicacion)},
          returns: double_,
        ),
        'origenUbicacion': CodeExpression(
          r'(o == null || o.isEmpty) ? "gps" : o',
          args: {'o': State(estado.origenUbicacion)},
          returns: string,
        ),
        'foto': ActionResult.uploadedFile('subirFoto', nodeKey: 'Container_d462p7t6'),
      },
      outputAs: 'envio',
    ),
    SetState(estado.enviando, false),
    If(
      envio['exito'],
      then: [
        SetState(estado.folio, envio['folio']),
        UpdateAppState.insertAtIndex(
          ff.AppState.reportes,
          0,
          reporteLocal(
            folio: State(estado.folio),
            estadoReporte: envio['estado'],
            fecha: CustomFunction(fechaDesdeIso, args: {'texto': envio['creadoEn']}),
          ),
        ),
        ...cerrarEnvio(),
      ],
      orElse: [
        Snackbar(envio['mensaje']),
        If(
          Equals(envio['codigoHttp'], 401),
          then: [
            UpdateAppState.set(ff.AppState.sesionIniciada, false),
            UpdateAppState.set(ff.AppState.tokenSesion, ''),
            Navigate(ff.Pages.iniciarSesion),
          ],
        ),
      ],
    ),
  ];

  app.editPage(pagina, (page) {
    final enviar = page.findByKey('Button_hqlzt1r5');
    // Bloqueado sin ubicación válida y mientras se envía (evita duplicados).
    page.bindDisabled(
      enviar,
      CodeExpression(
        '!(lista ?? false) || (enviando ?? false)',
        args: {'lista': State(estado.ubicacionLista), 'enviando': State(estado.enviando)},
        returns: bool_,
      ),
    );
    page.ensureInsertedAfter(
      page.findByKey('Text_tqq6c752'), // TextoEnviarSinUbicacion
      Row(
        name: 'FilaEnviando',
        mainAxis: MainAxis.center,
        spacing: 8,
        visible: State(estado.enviando),
        children: [
          ProgressBar.circular(size: 16, thickness: 2),
          Text(
            'Enviando reporte... no cierres la app.',
            style: Styles.bodySmall,
            color: Colors.secondaryText,
          ),
        ],
      ),
    );
    page.ensureActions(
      enviar,
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        ValidateForm('formReporte'),
        If(
          Not(State(estado.fotoCargada)),
          then: [Snackbar('Agrega una fotografía clara del problema.')],
          orElse: [
            If(
              CodeExpression(
                r'''c == 'Otro' && (t ?? '').trim().isEmpty''',
                args: {'c': State(estado.categoria), 't': descripcion},
                returns: bool_,
              ),
              then: [Snackbar('Describe brevemente el problema que deseas reportar.')],
              orElse: [
                If(
                  Not(CustomFunction(
                    coordenadasValidas,
                    args: {'lat': State(estado.latitud), 'lon': State(estado.longitud)},
                  )),
                  then: [Snackbar(_avisoGpsDesactivado)],
                  orElse: [
                    CallCustomAction.named(
                      'urlServidor',
                      returnType: string,
                      outputAs: 'urlServidor',
                    ),
                    If(
                      Equals(ActionOutput('urlServidor'), ''),
                      then: guardarLocal,
                      orElse: enviarAlServidor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  });

  // Cerrar sesión también borra el token.
  app.editPage(ff.Pages.perfil, (page) {
    page.ensureActions(
      page.findByKey('Button_lnn3onsp'), // Cerrar sesión
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        ConfirmDialog(
          title: '¿Cerrar sesión?',
          message: 'Tendrás que volver a iniciar sesión para reportar.',
          onConfirm: [
            UpdateAppState.set(ff.AppState.sesionIniciada, false),
            UpdateAppState.set(ff.AppState.tokenSesion, ''),
            Navigate(ff.Pages.iniciarSesion),
          ],
        ),
      ],
    );
  });
}


// ---------------------------------------------------------------------------
// Sesión con el backend · fase 5a: acciones y estado (city-care.v1.yaml)
// ---------------------------------------------------------------------------

/// Acciones de login, perfil y logout; envío ajustado al formato de error
/// {"error": {...}}. Vacía las cadenas que la fase 5b reescribe completas.
// ignore: unused_element
void _sesionFase5a(App app) {
  final usuarioSesion = app.struct('UsuarioSesion', {
    'exito': bool_,
    'codigoHttp': int_,
    'mensaje': string,
    'token': string,
    'nombre': string,
    'correo': string,
    'telefono': string,
  });

  app.customAction(
    'iniciarSesionApi',
    args: {'urlApi': string, 'correo': string, 'contrasena': string},
    returns: usuarioSesion,
    description: 'POST {urlApi}/auth/login. Devuelve token y datos del usuario, o un mensaje de error.',
    code: r'''
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

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
''',
  );
  app.customAction(
    'obtenerPerfil',
    args: {'urlApi': string, 'token': string},
    returns: usuarioSesion,
    description: 'GET {urlApi}/account/profile con Bearer. codigoHttp 401 = sesión vencida.',
    code: r'''
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
''',
  );
  app.customAction(
    'cerrarSesionApi',
    args: {'urlApi': string, 'token': string},
    returns: bool_,
    description: 'POST {urlApi}/account/logout con Bearer: invalida el token en el servidor.',
    code: r'''
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
''',
  );
  app.editCustomAction('enviarReporte', (codigo) {
    codigo.replaceCode(r'''
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
    final solicitud = http.MultipartRequest('POST', Uri.parse('$base/reports'))
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..headers['ngrok-skip-browser-warning'] = 'true'
      ..fields['categoria'] = categoria
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
      estado: '${datos['estado'] ?? 'Pendiente'}',
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
''');
  });

  app.editPageState(ff.Pages.iniciarSesion, (estado) {
    estado.ensureField('iniciando', bool_.withDefault(false));
  });
  app.editPageState(ff.Pages.perfil, (estado) {
    estado.ensureField('conServidor', bool_.withDefault(false));
  });

  // El script conserva los argumentos de cadenas existentes: se vacían aquí
  // y la fase 5b las escribe completas.
  app.editPageOnLoad(ff.Pages.iniciarSesion, []);
  app.editPage(ff.Pages.iniciarSesion, (page) {
    page.ensureActions(
      page.findByKey('Button_nqrvc46t'), // Iniciar sesión
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [],
    );
  });
  app.editPage(ff.Pages.perfil, (page) {
    for (final boton in ['Button_lv5swo4j', 'Button_lnn3onsp']) {
      // Guardar cambios y Cerrar sesión.
      page.ensureActions(
        page.findByKey(boton),
        triggerType: FFActionTriggerType.ON_TAP,
        actions: [],
      );
    }
  });
}


// ---------------------------------------------------------------------------
// Sesión con el backend · fase 5b: pantallas (city-care.v1.yaml)
// ---------------------------------------------------------------------------

/// Login real con token, perfil desde el servidor, logout que invalida el
/// token y avisos de registro/recuperación (las cuentas las crea el admin).
/// Con la constante urlApi vacía todo sigue en modo sin servidor.
// ignore: unused_element
void _sesionFase5b(App app) {
  final usuarioSesion = ff.Structs.usuarioSesion;
  final estadoLogin = ff.Pages.iniciarSesion.state;
  final estadoPerfil = ff.Pages.perfil.state;

  // urlApi vacía = modo sin servidor (login y registro simulados).
  DslAction leerUrl(String salida) =>
      CallCustomAction.named('urlServidor', returnType: string, outputAs: salida);
  Object conServidor(String salida) => Not(Equals(ActionOutput(salida), ''));
  Object url(String salida) =>
      CodeExpression(r'u ?? ""', args: {'u': ActionOutput(salida)}, returns: string);

  List<DslAction> guardarUsuario(ActionOutput datos) => [
    UpdateAppState.set(ff.AppState.usuarioNombre, datos['nombre']),
    UpdateAppState.set(ff.AppState.usuarioCorreo, datos['correo']),
    UpdateAppState.set(ff.AppState.usuarioTelefono, datos['telefono']),
  ];
  List<DslAction> cerrarSesionLocal() => [
    UpdateAppState.set(ff.AppState.sesionIniciada, false),
    UpdateAppState.set(ff.AppState.tokenSesion, ''),
    Navigate(ff.Pages.iniciarSesion),
  ];

  // ---- Iniciar sesión ----------------------------------------------------
  // Una sesión simulada de antes (sin token) pide iniciar sesión de nuevo.
  app.editPageOnLoad(ff.Pages.iniciarSesion, [
    If(
      AppState(ff.AppState.sesionIniciada),
      then: [
        leerUrl('urlAlAbrir'),
        If(
          CodeExpression(
            r'(u ?? "").isNotEmpty && (t ?? "").isEmpty',
            args: {'u': ActionOutput('urlAlAbrir'), 't': AppState(ff.AppState.tokenSesion)},
            returns: bool_,
          ),
          then: [UpdateAppState.set(ff.AppState.sesionIniciada, false)],
          orElse: [Navigate(ff.Pages.inicio)],
        ),
      ],
    ),
  ]);

  app.editPage(ff.Pages.iniciarSesion, (page) {
    final boton = page.findByKey('Button_nqrvc46t'); // Iniciar sesión
    final sesion = ActionOutput('sesion');
    page.bindDisabled(boton, State(estadoLogin.iniciando));
    page.ensureInsertedAfter(
      boton,
      Row(
        name: 'FilaIniciando',
        mainAxis: MainAxis.center,
        spacing: 8,
        visible: State(estadoLogin.iniciando),
        children: [
          ProgressBar.circular(size: 16, thickness: 2),
          Text('Iniciando sesión...', style: Styles.bodySmall, color: Colors.secondaryText),
        ],
      ),
    );
    page.ensureActions(
      boton,
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        ValidateForm('formLogin'),
        leerUrl('urlLogin'),
        If(
          conServidor('urlLogin'),
          then: [
            SetState(estadoLogin.iniciando, true),
            CallCustomAction.named(
              'iniciarSesionApi',
              args: {'urlApi': string, 'correo': string, 'contrasena': string},
              returnType: usuarioSesion,
              arguments: {
                'urlApi': url('urlLogin'),
                'correo': WidgetState('campoCorreo', WidgetStateProperty.text),
                'contrasena': WidgetState('campoContrasena', WidgetStateProperty.text),
              },
              outputAs: 'sesion',
            ),
            SetState(estadoLogin.iniciando, false),
            If(
              sesion['exito'],
              then: [
                UpdateAppState.set(ff.AppState.tokenSesion, sesion['token']),
                ...guardarUsuario(sesion),
                UpdateAppState.set(ff.AppState.sesionIniciada, true),
                ClearTextField('campoContrasena'),
                Navigate(ff.Pages.inicio),
              ],
              orElse: [Snackbar(sesion['mensaje'])],
            ),
          ],
          // Sin servidor: sesión simulada como antes.
          orElse: [
            UpdateAppState.set(
              ff.AppState.usuarioCorreo,
              WidgetState('campoCorreo', WidgetStateProperty.text),
            ),
            If(
              Equals(AppState(ff.AppState.usuarioNombre), ''),
              then: [UpdateAppState.set(ff.AppState.usuarioNombre, 'Ciudadano')],
            ),
            UpdateAppState.set(ff.AppState.sesionIniciada, true),
            Navigate(ff.Pages.inicio),
          ],
        ),
      ],
    );
    // El contrato no tiene acceso con Google: se oculta (no se borra).
    for (final clave in ['Row_fcmd9lnz', 'Button_lcxlq2vc']) {
      page.bindVisible(page.findByKey(clave), CodeExpression('false', returns: bool_));
    }
  });

  // ---- Registro y recuperación: las cuentas las administra City Care ------
  app.editPageOnLoad(ff.Pages.registro, [
    leerUrl('urlRegistro'),
    If(
      conServidor('urlRegistro'),
      then: [
        ShowDialog.message(
          title: 'Cuentas de City Care',
          message:
              'Las cuentas las crea el administrador de City Care. Pídele tu correo y contraseña, y después inicia sesión.',
          dismissText: 'Entendido',
        ),
        NavigateBack(),
      ],
    ),
  ]);
  app.editPageOnLoad(ff.Pages.recuperarContrasena, [
    leerUrl('urlRecuperar'),
    If(
      conServidor('urlRecuperar'),
      then: [
        ShowDialog.message(
          title: 'Recuperar contraseña',
          message:
              'Para restablecer tu contraseña, pide al administrador de City Care que la cambie. Después inicia sesión con la nueva.',
          dismissText: 'Entendido',
        ),
        NavigateBack(),
      ],
    ),
  ]);

  // ---- Perfil --------------------------------------------------------------
  // Con servidor: datos desde GET /account/profile; 401 cierra la sesión.
  final perfil = ActionOutput('perfil');
  app.editPageOnLoad(ff.Pages.perfil, [
    leerUrl('urlPerfil'),
    If(
      conServidor('urlPerfil'),
      then: [
        SetState(estadoPerfil.conServidor, true),
        If(
          Not(Equals(AppState(ff.AppState.tokenSesion), '')),
          then: [
            CallCustomAction.named(
              'obtenerPerfil',
              args: {'urlApi': string, 'token': string},
              returnType: usuarioSesion,
              arguments: {
                'urlApi': url('urlPerfil'),
                'token': AppState(ff.AppState.tokenSesion),
              },
              outputAs: 'perfil',
            ),
            If(
              perfil['exito'],
              then: guardarUsuario(perfil),
              orElse: [
                If(
                  Equals(perfil['codigoHttp'], 401),
                  then: [Snackbar(perfil['mensaje']), ...cerrarSesionLocal()],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ]);

  app.editPage(ff.Pages.perfil, (page) {
    // Con servidor, nombre y teléfono los administra City Care; la colonia
    // sigue siendo local.
    for (final (campo, nombre) in [
      ('TextField_ur7xx8b0', 'EnvolturaEditarNombre'),
      ('TextField_lnd2stln', 'EnvolturaEditarTelefono'),
    ]) {
      page.ensureWrappedWith(
        page.findByKey(campo),
        Container(name: nombre, visible: Not(State(estadoPerfil.conServidor))),
      );
    }
    page.ensureInsertedBefore(
      page.findByKey('TextField_4h0feqo4'), // editarColonia
      Text(
        'Tu nombre y teléfono los administra City Care. Aquí puedes cambiar tu colonia.',
        name: 'TextoDatosAdministrados',
        style: Styles.bodySmall,
        color: Colors.secondaryText,
        visible: State(estadoPerfil.conServidor),
      ),
    );
    final campoTexto = (String nombre) => WidgetState(nombre, WidgetStateProperty.text);
    page.ensureActions(
      page.findByKey('Button_lv5swo4j'), // Guardar cambios
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        If(
          Not(State(estadoPerfil.conServidor)),
          then: [
            If(
              Not(Equals(campoTexto('editarNombre'), '')),
              then: [UpdateAppState.set(ff.AppState.usuarioNombre, campoTexto('editarNombre'))],
            ),
            If(
              Not(Equals(campoTexto('editarTelefono'), '')),
              then: [UpdateAppState.set(ff.AppState.usuarioTelefono, campoTexto('editarTelefono'))],
            ),
          ],
        ),
        If(
          Not(Equals(campoTexto('editarColonia'), '')),
          then: [UpdateAppState.set(ff.AppState.usuarioColonia, campoTexto('editarColonia'))],
        ),
        SetState(estadoPerfil.editando, false),
        Snackbar('Datos actualizados'),
      ],
    );
    page.ensureActions(
      page.findByKey('Button_lnn3onsp'), // Cerrar sesión
      triggerType: FFActionTriggerType.ON_TAP,
      actions: [
        ConfirmDialog(
          title: '¿Cerrar sesión?',
          message: 'Tendrás que volver a iniciar sesión para reportar.',
          confirmText: 'Cerrar sesión',
          dismissText: 'Cancelar',
          onConfirm: [
            leerUrl('urlSalir'),
            If(
              conServidor('urlSalir'),
              then: [
                CallCustomAction.named(
                  'cerrarSesionApi',
                  args: {'urlApi': string, 'token': string},
                  arguments: {
                    'urlApi': url('urlSalir'),
                    'token': AppState(ff.AppState.tokenSesion),
                  },
                ),
              ],
            ),
            ...cerrarSesionLocal(),
          ],
        ),
      ],
    );
  });
}
