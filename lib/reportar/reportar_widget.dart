import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/permissions_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'reportar_model.dart';
export 'reportar_model.dart';

/// Formulario de reporte: categoría, foto (B4), ubicación (A4) y descripción.
class ReportarWidget extends StatefulWidget {
  const ReportarWidget({super.key});

  static String routeName = 'Reportar';
  static String routePath = '/reportar';

  @override
  State<ReportarWidget> createState() => _ReportarWidgetState();
}

class _ReportarWidgetState extends State<ReportarWidget> {
  late ReportarModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportarModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.buscandoUbicacion = true;
      safeSetState(() {});
      _model.ubicacionLista = false;
      safeSetState(() {});
      _model.estadoUbicacion = 'buscando';
      safeSetState(() {});
      _model.textoUbicacion = 'Detectando tu ubicación...';
      safeSetState(() {});
      _model.direccion = '';
      safeSetState(() {});
      _model.origenUbicacion = '';
      safeSetState(() {});
      _model.latitud = null;
      safeSetState(() {});
      _model.longitud = null;
      safeSetState(() {});
      _model.precisionUbicacion = null;
      safeSetState(() {});
      _model.gpsInicial = await actions.obtenerUbicacionGps();
      _model.estadoUbicacion = _model.gpsInicial?.estado;
      safeSetState(() {});
      if (_model.estadoUbicacion == 'ok') {
        _model.latitud = _model.gpsInicial?.latitud;
        safeSetState(() {});
        _model.longitud = _model.gpsInicial?.longitud;
        safeSetState(() {});
        _model.precisionUbicacion = _model.gpsInicial?.precision;
        safeSetState(() {});
        _model.origenUbicacion = 'gps';
        safeSetState(() {});
        _model.ubicacionLista = true;
        safeSetState(() {});
        _model.direccionInicial = await DireccionDesdeCoordenadasCall.call(
          lat: _model.latitud,
          lon: _model.longitud,
        );

        if ((_model.direccionInicial?.succeeded ?? true)) {
          _model.direccion = DireccionOSMStruct.maybeFromMap(
                  (_model.direccionInicial?.jsonBody ?? ''))
              ?.displayName;
          safeSetState(() {});
          _model.textoUbicacion = DireccionOSMStruct.maybeFromMap(
                  (_model.direccionInicial?.jsonBody ?? ''))
              ?.displayName;
          safeSetState(() {});
          _model.buscandoUbicacion = false;
          safeSetState(() {});
        } else {
          _model.textoUbicacion =
              'Ubicación detectada. No pudimos obtener la dirección, pero puedes enviar el reporte.';
          safeSetState(() {});
          _model.buscandoUbicacion = false;
          safeSetState(() {});
        }
      } else {
        if (_model.estadoUbicacion == 'servicio_desactivado') {
          _model.textoUbicacion =
              'Activa la ubicación para poder enviar el reporte.';
          safeSetState(() {});
        } else {
          if (_model.estadoUbicacion == 'permiso_denegado') {
            _model.textoUbicacion =
                'Necesitamos permiso de ubicación para registrar dónde ocurrió la incidencia. Toca Reintentar y elige «Permitir».';
            safeSetState(() {});
          } else {
            if (_model.estadoUbicacion == 'permiso_denegado_siempre') {
              _model.textoUbicacion =
                  'Necesitamos permiso de ubicación para registrar dónde ocurrió la incidencia. Actívalo en la configuración de la app.';
              safeSetState(() {});
            } else {
              _model.textoUbicacion =
                  'No pudimos leer tu ubicación. Revisa que el GPS esté activo y toca Reintentar.';
              safeSetState(() {});
            }
          }
        }

        _model.buscandoUbicacion = false;
        safeSetState(() {});
      }
    });

    _model.campoDescripcionTextController ??= TextEditingController();
    _model.campoDescripcionFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
            crossAxisAlignment: (FFCrossAxisAlignment.center).flutterValue,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Stack(
                alignment: AlignmentDirectional(0.0, -1.0),
                children: [
                  Container(
                    width: double.infinity,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24.0, 28.0, 24.0, 28.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                            (FFMainAxisAlignment.start).flutterValue,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.center).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.start).flutterValue,
                              crossAxisAlignment:
                                  (FFCrossAxisAlignment.start).flutterValue,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  'Crear reporte',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Mejora tu comunidad hoy',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0xE6FFFFFF),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 999.0,
                            buttonSize: 40.0,
                            fillColor: Color(0x33FFFFFF),
                            icon: Icon(
                              Icons.close,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.pushNamed(InicioWidget.routeName);
                            },
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                            (FFMainAxisAlignment.start).flutterValue,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.stretch).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:
                                (FFMainAxisAlignment.start).flutterValue,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.stretch).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.start).flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.start).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '1. Categoría',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    '¿Qué tipo de problema quieres reportar?',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 2.0)),
                              ),
                              FlutterFlowDropDown<String>(
                                controller:
                                    _model.campoCategoriaValueController ??=
                                        FormFieldController<String>(null),
                                options: [
                                  'Bache',
                                  'Alumbrado público',
                                  'Fuga de agua',
                                  'Basura acumulada',
                                  'Semáforo dañado',
                                  'Banqueta dañada',
                                  'Árbol caído',
                                  'Grafiti o vandalismo',
                                  'Otro'
                                ],
                                onChanged: (val) async {
                                  safeSetState(
                                      () => _model.campoCategoriaValue = val);
                                  _model.categoria = _model.campoCategoriaValue;
                                  safeSetState(() {});
                                },
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                hintText: 'Selecciona una opción',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 1.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                                hidesUnderline: true,
                                isOverButton: false,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:
                                (FFMainAxisAlignment.start).flutterValue,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.stretch).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.start).flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.start).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '2. Evidencia',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    'Sube una foto clara del desperfecto',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 2.0)),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final selectedMedia =
                                      await selectMediaWithSourceBottomSheet(
                                    context: context,
                                    allowPhoto: true,
                                  );
                                  if (selectedMedia != null &&
                                      selectedMedia.every((m) =>
                                          validateFileFormat(
                                              m.storagePath, context))) {
                                    safeSetState(() => _model
                                        .isDataUploading_fotoReporte = true);
                                    var selectedUploadedFiles =
                                        <FFUploadedFile>[];

                                    try {
                                      showUploadMessage(
                                        context,
                                        'Uploading file...',
                                        showLoading: true,
                                      );
                                      selectedUploadedFiles = selectedMedia
                                          .map((m) => FFUploadedFile(
                                                name: m.storagePath
                                                    .split('/')
                                                    .last,
                                                bytes: m.bytes,
                                                height: m.dimensions?.height,
                                                width: m.dimensions?.width,
                                                blurHash: m.blurHash,
                                                originalFilename:
                                                    m.originalFilename,
                                              ))
                                          .toList();
                                    } finally {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      _model.isDataUploading_fotoReporte =
                                          false;
                                    }
                                    if (selectedUploadedFiles.length ==
                                        selectedMedia.length) {
                                      safeSetState(() {
                                        _model.uploadedLocalFile_fotoReporte =
                                            selectedUploadedFiles.first;
                                      });
                                      showUploadMessage(context, 'Success!');
                                    } else {
                                      safeSetState(() {});
                                      showUploadMessage(
                                          context, 'Failed to upload data');
                                      return;
                                    }
                                  }

                                  _model.errorFoto = functions.validarFoto(
                                      _model.uploadedLocalFile_fotoReporte);
                                  safeSetState(() {});
                                  if (_model.errorFoto == '') {
                                    _model.fotoCargada = true;
                                    safeSetState(() {});
                                  } else {
                                    _model.fotoCargada = false;
                                    safeSetState(() {});
                                    safeSetState(() {
                                      _model.isDataUploading_fotoReporte =
                                          false;
                                      _model.uploadedLocalFile_fotoReporte =
                                          FFUploadedFile(
                                              bytes: Uint8List.fromList([]),
                                              originalFilename: '');
                                    });
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 200.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    borderRadius: BorderRadius.circular(18.0),
                                    border: Border.all(
                                      color: Color(0xFFFFD7AB),
                                      width: 2.0,
                                    ),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        (FFMainAxisAlignment.center)
                                            .flutterValue,
                                    crossAxisAlignment:
                                        (FFCrossAxisAlignment.center)
                                            .flutterValue,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      if (!_model.fotoCargada!)
                                        Icon(
                                          Icons.add_a_photo,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 44.0,
                                        ),
                                      if (!_model.fotoCargada!)
                                        Text(
                                          'Toca para capturar o subir',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                      if (_model.fotoCargada ?? true)
                                        Icon(
                                          Icons.check_circle,
                                          color: FlutterFlowTheme.of(context)
                                              .success,
                                          size: 44.0,
                                        ),
                                      if (_model.fotoCargada ?? true)
                                        Text(
                                          'Foto agregada · toca para cambiarla',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                    ].divide(SizedBox(height: 10.0)),
                                  ),
                                ),
                              ),
                              if (!(_model.errorFoto == ''))
                                Text(
                                  _model.errorFoto!,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:
                                (FFMainAxisAlignment.start).flutterValue,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.stretch).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.start).flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.start).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '3. Ubicación',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    'Detectamos tu posición automáticamente',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 2.0)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(18.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(14.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        (FFMainAxisAlignment.start)
                                            .flutterValue,
                                    crossAxisAlignment:
                                        (FFCrossAxisAlignment.stretch)
                                            .flutterValue,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            (FFMainAxisAlignment.start)
                                                .flutterValue,
                                        crossAxisAlignment:
                                            (FFCrossAxisAlignment.center)
                                                .flutterValue,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Container(
                                            width: 48.0,
                                            height: 48.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Icon(
                                              Icons.my_location,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 24.0,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  (FFMainAxisAlignment.start)
                                                      .flutterValue,
                                              crossAxisAlignment:
                                                  (FFCrossAxisAlignment.start)
                                                      .flutterValue,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  'Ubicación del reporte',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Text(
                                                  _model.textoUbicacion!,
                                                  maxLines: 3,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ].divide(SizedBox(height: 2.0)),
                                            ),
                                          ),
                                          if (_model.buscandoUbicacion ?? true)
                                            CircularPercentIndicator(
                                              percent: 0.0,
                                              radius: 11.0,
                                              lineWidth: 3.0,
                                              animation: false,
                                              animateFromLastPercent: true,
                                            ),
                                          if (!_model.buscandoUbicacion!)
                                            Container(
                                              child: Visibility(
                                                visible:
                                                    _model.ubicacionLista ??
                                                        true,
                                                child: FlutterFlowIconButton(
                                                  buttonSize: 40.0,
                                                  icon: Icon(
                                                    Icons.refresh,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () async {
                                                    _model.buscandoUbicacion =
                                                        true;
                                                    safeSetState(() {});
                                                    _model.ubicacionLista =
                                                        false;
                                                    safeSetState(() {});
                                                    _model.estadoUbicacion =
                                                        'buscando';
                                                    safeSetState(() {});
                                                    _model.textoUbicacion =
                                                        'Detectando tu ubicación...';
                                                    safeSetState(() {});
                                                    _model.direccion = '';
                                                    safeSetState(() {});
                                                    _model.origenUbicacion = '';
                                                    safeSetState(() {});
                                                    _model.latitud = null;
                                                    safeSetState(() {});
                                                    _model.longitud = null;
                                                    safeSetState(() {});
                                                    _model.precisionUbicacion =
                                                        null;
                                                    safeSetState(() {});
                                                    _model.gpsActualizada =
                                                        await actions
                                                            .obtenerUbicacionGps();
                                                    _model.estadoUbicacion =
                                                        _model.gpsActualizada
                                                            ?.estado;
                                                    safeSetState(() {});
                                                    if (_model
                                                            .estadoUbicacion ==
                                                        'ok') {
                                                      _model.latitud = _model
                                                          .gpsActualizada
                                                          ?.latitud;
                                                      safeSetState(() {});
                                                      _model.longitud = _model
                                                          .gpsActualizada
                                                          ?.longitud;
                                                      safeSetState(() {});
                                                      _model.precisionUbicacion =
                                                          _model.gpsActualizada
                                                              ?.precision;
                                                      safeSetState(() {});
                                                      _model.origenUbicacion =
                                                          'gps';
                                                      safeSetState(() {});
                                                      _model.ubicacionLista =
                                                          true;
                                                      safeSetState(() {});
                                                      _model.direccionActualizada =
                                                          await DireccionDesdeCoordenadasCall
                                                              .call(
                                                        lat: _model.latitud,
                                                        lon: _model.longitud,
                                                      );

                                                      if ((_model
                                                              .direccionActualizada
                                                              ?.succeeded ??
                                                          true)) {
                                                        _model
                                                            .direccion = DireccionOSMStruct
                                                                .maybeFromMap((_model
                                                                        .direccionActualizada
                                                                        ?.jsonBody ??
                                                                    ''))
                                                            ?.displayName;
                                                        safeSetState(() {});
                                                        _model.textoUbicacion =
                                                            DireccionOSMStruct
                                                                    .maybeFromMap(
                                                                        (_model.direccionActualizada?.jsonBody ??
                                                                            ''))
                                                                ?.displayName;
                                                        safeSetState(() {});
                                                        _model.buscandoUbicacion =
                                                            false;
                                                        safeSetState(() {});
                                                      } else {
                                                        _model.textoUbicacion =
                                                            'Ubicación detectada. No pudimos obtener la dirección, pero puedes enviar el reporte.';
                                                        safeSetState(() {});
                                                        _model.buscandoUbicacion =
                                                            false;
                                                        safeSetState(() {});
                                                      }
                                                    } else {
                                                      if (_model
                                                              .estadoUbicacion ==
                                                          'servicio_desactivado') {
                                                        _model.textoUbicacion =
                                                            'Activa la ubicación para poder enviar el reporte.';
                                                        safeSetState(() {});
                                                      } else {
                                                        if (_model
                                                                .estadoUbicacion ==
                                                            'permiso_denegado') {
                                                          _model.textoUbicacion =
                                                              'Necesitamos permiso de ubicación para registrar dónde ocurrió la incidencia. Toca Reintentar y elige «Permitir».';
                                                          safeSetState(() {});
                                                        } else {
                                                          if (_model
                                                                  .estadoUbicacion ==
                                                              'permiso_denegado_siempre') {
                                                            _model.textoUbicacion =
                                                                'Necesitamos permiso de ubicación para registrar dónde ocurrió la incidencia. Actívalo en la configuración de la app.';
                                                            safeSetState(() {});
                                                          } else {
                                                            _model.textoUbicacion =
                                                                'No pudimos leer tu ubicación. Revisa que el GPS esté activo y toca Reintentar.';
                                                            safeSetState(() {});
                                                          }
                                                        }
                                                      }

                                                      _model.buscandoUbicacion =
                                                          false;
                                                      safeSetState(() {});
                                                    }

                                                    safeSetState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                        ].divide(SizedBox(width: 12.0)),
                                      ),
                                      if (_model.ubicacionLista ?? true)
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              (FFMainAxisAlignment.start)
                                                  .flutterValue,
                                          crossAxisAlignment:
                                              (FFCrossAxisAlignment.center)
                                                  .flutterValue,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    (FFMainAxisAlignment.start)
                                                        .flutterValue,
                                                crossAxisAlignment:
                                                    (FFCrossAxisAlignment.start)
                                                        .flutterValue,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    functions.textoCoordenadas(
                                                        _model.latitud,
                                                        _model.longitud)!,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .plusJakartaSans(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    ((double? p) {
                                                      return "Precisión aproximada: ±${(p ?? 0).round()} m";
                                                    }(_model
                                                        .precisionUbicacion))!,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .plusJakartaSans(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(height: 2.0)),
                                              ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await launchURL(
                                                    functions.urlMapa(
                                                        _model.latitud,
                                                        _model.longitud)!);
                                              },
                                              child: Container(
                                                child: Text(
                                                  'Ver en mapa',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                      if (!_model.buscandoUbicacion!)
                                        Container(
                                          child: Visibility(
                                            visible: !_model.ubicacionLista!,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  (FFMainAxisAlignment.start)
                                                      .flutterValue,
                                              crossAxisAlignment:
                                                  (FFCrossAxisAlignment.stretch)
                                                      .flutterValue,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                FFButtonWidget(
                                                  onPressed: () async {
                                                    _model.buscandoUbicacion =
                                                        true;
                                                    safeSetState(() {});
                                                    _model.ubicacionLista =
                                                        false;
                                                    safeSetState(() {});
                                                    _model.estadoUbicacion =
                                                        'buscando';
                                                    safeSetState(() {});
                                                    _model.textoUbicacion =
                                                        'Detectando tu ubicación...';
                                                    safeSetState(() {});
                                                    _model.direccion = '';
                                                    safeSetState(() {});
                                                    _model.origenUbicacion = '';
                                                    safeSetState(() {});
                                                    _model.latitud = null;
                                                    safeSetState(() {});
                                                    _model.longitud = null;
                                                    safeSetState(() {});
                                                    _model.precisionUbicacion =
                                                        null;
                                                    safeSetState(() {});
                                                    _model.gpsReintento =
                                                        await actions
                                                            .obtenerUbicacionGps();
                                                    _model.estadoUbicacion =
                                                        _model.gpsReintento
                                                            ?.estado;
                                                    safeSetState(() {});
                                                    if (_model
                                                            .estadoUbicacion ==
                                                        'ok') {
                                                      _model.latitud = _model
                                                          .gpsReintento
                                                          ?.latitud;
                                                      safeSetState(() {});
                                                      _model.longitud = _model
                                                          .gpsReintento
                                                          ?.longitud;
                                                      safeSetState(() {});
                                                      _model.precisionUbicacion =
                                                          _model.gpsReintento
                                                              ?.precision;
                                                      safeSetState(() {});
                                                      _model.origenUbicacion =
                                                          'gps';
                                                      safeSetState(() {});
                                                      _model.ubicacionLista =
                                                          true;
                                                      safeSetState(() {});
                                                      _model.direccionReintento =
                                                          await DireccionDesdeCoordenadasCall
                                                              .call(
                                                        lat: _model.latitud,
                                                        lon: _model.longitud,
                                                      );

                                                      if ((_model
                                                              .direccionReintento
                                                              ?.succeeded ??
                                                          true)) {
                                                        _model
                                                            .direccion = DireccionOSMStruct
                                                                .maybeFromMap((_model
                                                                        .direccionReintento
                                                                        ?.jsonBody ??
                                                                    ''))
                                                            ?.displayName;
                                                        safeSetState(() {});
                                                        _model.textoUbicacion =
                                                            DireccionOSMStruct
                                                                    .maybeFromMap(
                                                                        (_model.direccionReintento?.jsonBody ??
                                                                            ''))
                                                                ?.displayName;
                                                        safeSetState(() {});
                                                        _model.buscandoUbicacion =
                                                            false;
                                                        safeSetState(() {});
                                                      } else {
                                                        _model.textoUbicacion =
                                                            'Ubicación detectada. No pudimos obtener la dirección, pero puedes enviar el reporte.';
                                                        safeSetState(() {});
                                                        _model.buscandoUbicacion =
                                                            false;
                                                        safeSetState(() {});
                                                      }
                                                    } else {
                                                      if (_model
                                                              .estadoUbicacion ==
                                                          'servicio_desactivado') {
                                                        _model.textoUbicacion =
                                                            'Activa la ubicación para poder enviar el reporte.';
                                                        safeSetState(() {});
                                                      } else {
                                                        if (_model
                                                                .estadoUbicacion ==
                                                            'permiso_denegado') {
                                                          _model.textoUbicacion =
                                                              'Necesitamos permiso de ubicación para registrar dónde ocurrió la incidencia. Toca Reintentar y elige «Permitir».';
                                                          safeSetState(() {});
                                                        } else {
                                                          if (_model
                                                                  .estadoUbicacion ==
                                                              'permiso_denegado_siempre') {
                                                            _model.textoUbicacion =
                                                                'Necesitamos permiso de ubicación para registrar dónde ocurrió la incidencia. Actívalo en la configuración de la app.';
                                                            safeSetState(() {});
                                                          } else {
                                                            _model.textoUbicacion =
                                                                'No pudimos leer tu ubicación. Revisa que el GPS esté activo y toca Reintentar.';
                                                            safeSetState(() {});
                                                          }
                                                        }
                                                      }

                                                      _model.buscandoUbicacion =
                                                          false;
                                                      safeSetState(() {});
                                                    }

                                                    safeSetState(() {});
                                                  },
                                                  text: 'Reintentar',
                                                  icon: Icon(
                                                    Icons.refresh,
                                                    size: 20.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: double.infinity,
                                                    height: 44.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    iconColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent1,
                                                    textStyle: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                                if (_model.estadoUbicacion ==
                                                    'servicio_desactivado')
                                                  FFButtonWidget(
                                                    onPressed: () async {
                                                      await actions
                                                          .abrirAjustesUbicacion(
                                                        'servicio_desactivado',
                                                      );
                                                    },
                                                    text: 'Activar ubicación',
                                                    icon: Icon(
                                                      Icons.location_on,
                                                      size: 20.0,
                                                    ),
                                                    options: FFButtonOptions(
                                                      width: double.infinity,
                                                      height: 44.0,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      iconColor: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      textStyle: TextStyle(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                  ),
                                                if (_model.estadoUbicacion ==
                                                    'permiso_denegado_siempre')
                                                  FFButtonWidget(
                                                    onPressed: () async {
                                                      await requestPermission(
                                                          locationPermission);
                                                      await actions
                                                          .abrirAjustesUbicacion(
                                                        'permiso_denegado_siempre',
                                                      );
                                                    },
                                                    text: 'Abrir configuración',
                                                    icon: Icon(
                                                      Icons.settings,
                                                      size: 20.0,
                                                    ),
                                                    options: FFButtonOptions(
                                                      width: double.infinity,
                                                      height: 44.0,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      iconColor: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      textStyle: TextStyle(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                  ),
                                              ].divide(SizedBox(height: 8.0)),
                                            ),
                                          ),
                                        ),
                                    ].divide(SizedBox(height: 10.0)),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:
                                (FFMainAxisAlignment.start).flutterValue,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.stretch).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.start).flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.start).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '4. Descripción',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    'Obligatoria si eliges «Otro»; en las demás categorías es opcional.',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 2.0)),
                              ),
                              TextFormField(
                                controller:
                                    _model.campoDescripcionTextController,
                                focusNode: _model.campoDescripcionFocusNode,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText:
                                      'Ej: El bache es profundo y está frente al número 120',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  filled: true,
                                ),
                                style: TextStyle(),
                                maxLines: 4,
                                validator: _model
                                    .campoDescripcionTextControllerValidator
                                    .asValidator(context),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                          FFButtonWidget(
                            onPressed: (!(_model.ubicacionLista ?? false) ||
                                    (_model.enviando ?? false))!
                                ? null
                                : () async {
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    if (_model.campoCategoriaValue == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Elige una categoría',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                      return;
                                    }
                                    if (!_model.fotoCargada!) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Agrega una fotografía clara del problema.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                    } else {
                                      if (((String? c, String? t) {
                                        return c == 'Otro' &&
                                            (t ?? '').trim().isEmpty;
                                      }(
                                          _model.categoria,
                                          _model.campoDescripcionTextController
                                              .text))!) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Describe brevemente el problema que deseas reportar.',
                                              style: TextStyle(),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                          ),
                                        );
                                      } else {
                                        if (!functions.coordenadasValidas(
                                            _model.latitud, _model.longitud)!) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Activa la ubicación para poder enviar el reporte.',
                                                style: TextStyle(),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                            ),
                                          );
                                        } else {
                                          _model.urlServidor =
                                              await actions.urlServidor();
                                          if (_model.urlServidor == '') {
                                            _model.folio =
                                                functions.generarFolio(
                                                    (List<ReporteStruct>? r) {
                                                      return (r ?? []).length +
                                                          1;
                                                    }(FFAppState()
                                                        .reportes
                                                        .toList()),
                                                    getCurrentTimestamp);
                                            safeSetState(() {});
                                            FFAppState()
                                                .insertAtIndexInReportes(
                                                    0,
                                                    ReporteStruct(
                                                      folio: _model.folio,
                                                      categoria:
                                                          _model.categoria,
                                                      descripcion: _model
                                                          .campoDescripcionTextController
                                                          .text,
                                                      direccion:
                                                          _model.direccion,
                                                      latitud: _model.latitud,
                                                      longitud: _model.longitud,
                                                      precisionUbicacion: _model
                                                          .precisionUbicacion,
                                                      origenUbicacion: _model
                                                          .origenUbicacion,
                                                      estado: 'Pendiente',
                                                      fecha:
                                                          getCurrentTimestamp,
                                                      tieneFoto: true,
                                                    ));
                                            safeSetState(() {});
                                            safeSetState(() {
                                              _model
                                                  .campoDescripcionTextController
                                                  ?.clear();
                                            });
                                            safeSetState(() {
                                              _model
                                                  .campoCategoriaValueController
                                                  ?.reset();
                                              _model.campoCategoriaValue = null;
                                            });
                                            _model.categoria = '';
                                            safeSetState(() {});
                                            safeSetState(() {
                                              _model.isDataUploading_fotoReporte =
                                                  false;
                                              _model.uploadedLocalFile_fotoReporte =
                                                  FFUploadedFile(
                                                      bytes: Uint8List.fromList(
                                                          []),
                                                      originalFilename: '');
                                            });

                                            _model.fotoCargada = false;
                                            safeSetState(() {});
                                            _model.errorFoto = '';
                                            safeSetState(() {});
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title:
                                                      Text('¡Reporte enviado!'),
                                                  content: Text(((String? f) {
                                                    return "Tu folio es $f. Puedes darle seguimiento en Mis reportes.";
                                                  }(_model.folio))!),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text(
                                                          'Ver mis reportes'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            context.pushNamed(
                                                MisReportesWidget.routeName);
                                          } else {
                                            _model.enviando = true;
                                            safeSetState(() {});
                                            _model.envio =
                                                await actions.enviarReporte(
                                              (String? u) {
                                                return u ?? "";
                                              }(_model.urlServidor),
                                              FFAppState().tokenSesion,
                                              (String? c) {
                                                return c ?? "";
                                              }(_model.categoria),
                                              _model
                                                  .campoDescripcionTextController
                                                  .text,
                                              (String? d) {
                                                return d ?? "";
                                              }(_model.direccion),
                                              _model.latitud ?? 0.0,
                                              _model.longitud ?? 0.0,
                                              _model.precisionUbicacion ?? -1.0,
                                              (String? o) {
                                                return (o == null || o.isEmpty)
                                                    ? "gps"
                                                    : o;
                                              }(_model.origenUbicacion),
                                              _model
                                                  .uploadedLocalFile_fotoReporte,
                                            );
                                            _model.enviando = false;
                                            safeSetState(() {});
                                            if (_model.envio!.exito) {
                                              _model.folio =
                                                  _model.envio?.folio;
                                              safeSetState(() {});
                                              FFAppState()
                                                  .insertAtIndexInReportes(
                                                      0,
                                                      ReporteStruct(
                                                        folio: _model.folio,
                                                        categoria:
                                                            _model.categoria,
                                                        descripcion: _model
                                                            .campoDescripcionTextController
                                                            .text,
                                                        direccion:
                                                            _model.direccion,
                                                        latitud: _model.latitud,
                                                        longitud:
                                                            _model.longitud,
                                                        precisionUbicacion: _model
                                                            .precisionUbicacion,
                                                        origenUbicacion: _model
                                                            .origenUbicacion,
                                                        estado: _model
                                                            .envio?.estado,
                                                        fecha: functions
                                                            .fechaDesdeIso(
                                                                _model.envio
                                                                    ?.creadoEn),
                                                        tieneFoto: true,
                                                      ));
                                              safeSetState(() {});
                                              safeSetState(() {
                                                _model
                                                    .campoDescripcionTextController
                                                    ?.clear();
                                              });
                                              safeSetState(() {
                                                _model
                                                    .campoCategoriaValueController
                                                    ?.reset();
                                                _model.campoCategoriaValue =
                                                    null;
                                              });
                                              _model.categoria = '';
                                              safeSetState(() {});
                                              safeSetState(() {
                                                _model.isDataUploading_fotoReporte =
                                                    false;
                                                _model.uploadedLocalFile_fotoReporte =
                                                    FFUploadedFile(
                                                        bytes:
                                                            Uint8List.fromList(
                                                                []),
                                                        originalFilename: '');
                                              });

                                              _model.fotoCargada = false;
                                              safeSetState(() {});
                                              _model.errorFoto = '';
                                              safeSetState(() {});
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        '¡Reporte enviado!'),
                                                    content: Text(((String? f) {
                                                      return "Tu folio es $f. Puedes darle seguimiento en Mis reportes.";
                                                    }(_model.folio))!),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text(
                                                            'Ver mis reportes'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              context.pushNamed(
                                                  MisReportesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model.envio!.mensaje,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                              if (_model.envio?.codigoHttp ==
                                                  401) {
                                                FFAppState().sesionIniciada =
                                                    false;
                                                safeSetState(() {});
                                                FFAppState().tokenSesion = '';
                                                safeSetState(() {});

                                                context.pushNamed(
                                                    IniciarSesionWidget
                                                        .routeName);
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }

                                    safeSetState(() {});
                                  },
                            text: 'Enviar reporte',
                            icon: Icon(
                              Icons.send,
                              size: 20.0,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 54.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          if (!_model.ubicacionLista!)
                            Text(
                              'Para enviar el reporte necesitamos la ubicación del GPS.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                            ),
                          if (_model.enviando ?? true)
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.center).flutterValue,
                              crossAxisAlignment:
                                  (FFCrossAxisAlignment.center).flutterValue,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                CircularPercentIndicator(
                                  percent: 0.0,
                                  radius: 8.0,
                                  lineWidth: 2.0,
                                  animation: false,
                                  animateFromLastPercent: true,
                                ),
                                Text(
                                  'Enviando reporte... no cierres la app.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                        ].divide(SizedBox(height: 22.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
