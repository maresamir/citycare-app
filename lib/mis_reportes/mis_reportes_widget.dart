import '/backend/schema/structs/index.dart';
import '/components/tarjeta_reporte_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'mis_reportes_model.dart';
export 'mis_reportes_model.dart';

/// Seguimiento de los reportes del usuario con filtro por estado.
class MisReportesWidget extends StatefulWidget {
  const MisReportesWidget({super.key});

  static String routeName = 'MisReportes';
  static String routePath = '/mis-reportes';

  @override
  State<MisReportesWidget> createState() => _MisReportesWidgetState();
}

class _MisReportesWidgetState extends State<MisReportesWidget> {
  late MisReportesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MisReportesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.urlMisReportes = await actions.urlServidor();
      if (!(_model.urlMisReportes == '')) {
        _model.conServidor = true;
        safeSetState(() {});
        if (!(FFAppState().tokenSesion == '')) {
          _model.actualizando = true;
          safeSetState(() {});
          _model.reportesServidor = await actions.listarMisReportes(
            (String? u) {
              return u ?? "";
            }(_model.urlMisReportes),
            FFAppState().tokenSesion,
          );
          _model.actualizando = false;
          safeSetState(() {});
          if (_model.reportesServidor!.exito) {
            FFAppState().reportes = _model.reportesServidor!.reportes
                .toList()
                .cast<ReporteStruct>();
            safeSetState(() {});
          } else {
            if ((_model.reportesServidor?.codigoHttp == 401 ||
                _model.reportesServidor?.codigoHttp == 403)!) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _model.reportesServidor!.mensaje,
                    style: TextStyle(),
                  ),
                  duration: Duration(milliseconds: 4000),
                ),
              );
              FFAppState().reportes = [];
              safeSetState(() {});
              await actions.guardarTokenSeguro(
                '',
              );
              FFAppState().tokenSesion = '';
              safeSetState(() {});
              FFAppState().sesionIniciada = false;
              safeSetState(() {});

              context.pushNamed(IniciarSesionWidget.routeName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'No pudimos actualizar tus reportes. Te mostramos los últimos guardados.',
                    style: TextStyle(),
                  ),
                  duration: Duration(milliseconds: 4000),
                ),
              );
            }
          }

          _model.actualizarReportes = InstantTimer.periodic(
            duration: Duration(milliseconds: 20000),
            callback: (timer) async {
              _model.reportesPeriodico = await actions.listarMisReportes(
                (String? u) {
                  return u ?? "";
                }(_model.urlMisReportes),
                FFAppState().tokenSesion,
              );
              if (_model.reportesPeriodico!.exito) {
                FFAppState().reportes = _model.reportesPeriodico!.reportes
                    .toList()
                    .cast<ReporteStruct>();
                safeSetState(() {});
              } else {
                if ((_model.reportesPeriodico?.codigoHttp == 401 ||
                    _model.reportesPeriodico?.codigoHttp == 403)!) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _model.reportesPeriodico!.mensaje,
                        style: TextStyle(),
                      ),
                      duration: Duration(milliseconds: 4000),
                    ),
                  );
                  FFAppState().reportes = [];
                  safeSetState(() {});
                  await actions.guardarTokenSeguro(
                    '',
                  );
                  FFAppState().tokenSesion = '';
                  safeSetState(() {});
                  FFAppState().sesionIniciada = false;
                  safeSetState(() {});

                  context.pushNamed(IniciarSesionWidget.routeName);
                }
              }
            },
            startImmediately: false,
          );
        }
      }
    });

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
                                  'Mis reportes',
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
                                  'Seguimiento de tus incidencias',
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
                          if (_model.conServidor ?? true)
                            FlutterFlowIconButton(
                              borderRadius: 20.0,
                              buttonSize: 56.0,
                              fillColor: Color(0x33FFFFFF),
                              icon: Icon(
                                Icons.refresh,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 40.0,
                              ),
                              onPressed: _model.actualizando!
                                  ? null
                                  : () async {
                                      _model.urlBotonReportes =
                                          await actions.urlServidor();
                                      _model.actualizando = true;
                                      safeSetState(() {});
                                      _model.reportesBoton =
                                          await actions.listarMisReportes(
                                        (String? u) {
                                          return u ?? "";
                                        }(_model.urlBotonReportes),
                                        FFAppState().tokenSesion,
                                      );
                                      _model.actualizando = false;
                                      safeSetState(() {});
                                      if (_model.reportesBoton!.exito) {
                                        FFAppState().reportes = _model
                                            .reportesBoton!.reportes
                                            .toList()
                                            .cast<ReporteStruct>();
                                        safeSetState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Reportes actualizados',
                                              style: TextStyle(),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                          ),
                                        );
                                      } else {
                                        if ((_model.reportesBoton?.codigoHttp ==
                                                401 ||
                                            _model.reportesBoton?.codigoHttp ==
                                                403)!) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                _model.reportesBoton!.mensaje,
                                                style: TextStyle(),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                            ),
                                          );
                                          FFAppState().reportes = [];
                                          safeSetState(() {});
                                          await actions.guardarTokenSeguro(
                                            '',
                                          );
                                          FFAppState().tokenSesion = '';
                                          safeSetState(() {});
                                          FFAppState().sesionIniciada = false;
                                          safeSetState(() {});

                                          context.pushNamed(
                                              IniciarSesionWidget.routeName);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                _model.reportesBoton!.mensaje,
                                                style: TextStyle(),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                            ),
                                          );
                                        }
                                      }

                                      safeSetState(() {});
                                    },
                            ),
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              shape: BoxShape.circle,
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              functions.iniciales(FFAppState().usuarioNombre)!,
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 19.2,
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 18.0, 20.0, 6.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                    crossAxisAlignment:
                        (FFCrossAxisAlignment.center).flutterValue,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.filtro = 'Todos';
                          safeSetState(() {});
                        },
                        child: Container(
                          child: Stack(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            children: [
                              if (_model.filtro == 'Todos')
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(999.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'Todos',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
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
                                  ),
                                ),
                              if (!(_model.filtro == 'Todos'))
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(999.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'Todos',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
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
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.filtro = 'Pendiente';
                          safeSetState(() {});
                        },
                        child: Container(
                          child: Stack(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            children: [
                              if (_model.filtro == 'Pendiente')
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(999.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'Pendiente',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
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
                                  ),
                                ),
                              if (!(_model.filtro == 'Pendiente'))
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(999.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'Pendiente',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
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
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.filtro = 'En proceso';
                          safeSetState(() {});
                        },
                        child: Container(
                          child: Stack(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            children: [
                              if (_model.filtro == 'En proceso')
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(999.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'En proceso',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
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
                                  ),
                                ),
                              if (!(_model.filtro == 'En proceso'))
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(999.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'En proceso',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
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
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.filtro = 'Resuelto';
                          safeSetState(() {});
                        },
                        child: Container(
                          child: Stack(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            children: [
                              if (_model.filtro == 'Resuelto')
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(999.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'Resuelto',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
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
                                  ),
                                ),
                              if (!(_model.filtro == 'Resuelto'))
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(999.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      'Resuelto',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
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
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                ),
              ),
              if (_model.actualizando ?? true)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: (FFMainAxisAlignment.center).flutterValue,
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
                      'Actualizando...',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
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
              if (!_model.actualizando!)
                Container(
                  child: Visibility(
                    visible: functions.contarPorEstado(
                            FFAppState().reportes.toList(), _model.filtro) ==
                        '0',
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                            (FFMainAxisAlignment.start).flutterValue,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.center).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Icon(
                            Icons.assignment,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 56.0,
                          ),
                          Text(
                            'No hay reportes aquí',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            'Crea un reporte y dale seguimiento desde esta pantalla.',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
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
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 20.0),
                  child: Builder(
                    builder: (context) {
                      final item = functions
                              .filtrarReportes(
                                  FFAppState().reportes.toList(), _model.filtro)
                              ?.toList() ??
                          [];

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemCount: item.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.0),
                        itemBuilder: (context, itemIndex) {
                          final itemItem = item[itemIndex];
                          return wrapWithModel(
                            model: _model.tarjetaReporteModels.getModel(
                              itemIndex.toString(),
                              itemIndex,
                            ),
                            updateCallback: () => safeSetState(() {}),
                            child: TarjetaReporteWidget(
                              key: Key(
                                'Keyi9s_${itemIndex.toString()}',
                              ),
                              categoria: itemItem.categoria,
                              direccion: itemItem.direccion,
                              estado: itemItem.estado,
                              fecha: functions.formatearFecha(itemItem.fecha),
                              alTocar: () async {
                                context.pushNamed(
                                  DetalleReporteWidget.routeName,
                                  queryParameters: {
                                    'categoria': serializeParam(
                                      itemItem.categoria,
                                      ParamType.String,
                                    ),
                                    'descripcion': serializeParam(
                                      itemItem.descripcion,
                                      ParamType.String,
                                    ),
                                    'direccion': serializeParam(
                                      itemItem.direccion,
                                      ParamType.String,
                                    ),
                                    'estado': serializeParam(
                                      itemItem.estado,
                                      ParamType.String,
                                    ),
                                    'fecha': serializeParam(
                                      functions.formatearFecha(itemItem.fecha),
                                      ParamType.String,
                                    ),
                                    'latitud': serializeParam(
                                      itemItem.latitud,
                                      ParamType.double,
                                    ),
                                    'longitud': serializeParam(
                                      itemItem.longitud,
                                      ParamType.double,
                                    ),
                                    'idServidor': serializeParam(
                                      itemItem.idServidor,
                                      ParamType.String,
                                    ),
                                    'folio': serializeParam(
                                      itemItem.folio,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 4.0, 20.0, 16.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(ReportarWidget.routeName);
                    },
                    text: 'Nuevo reporte',
                    icon: Icon(
                      Icons.add,
                      size: 20.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconColor: FlutterFlowTheme.of(context).primary,
                      color: Colors.transparent,
                      textStyle: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(14.0),
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
