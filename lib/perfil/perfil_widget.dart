import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'perfil_model.dart';
export 'perfil_model.dart';

/// Perfil del ciudadano: datos, estadísticas, ajustes y cierre de sesión.
class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  static String routeName = 'Perfil';
  static String routePath = '/perfil';

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.urlPerfil = await actions.urlServidor();
      if (!(_model.urlPerfil == '')) {
        _model.conServidor = true;
        safeSetState(() {});
        if (!(FFAppState().tokenSesion == '')) {
          _model.perfil = await actions.obtenerPerfil(
            (String? u) {
              return u ?? "";
            }(_model.urlPerfil),
            FFAppState().tokenSesion,
          );
          if (_model.perfil!.exito) {
            FFAppState().usuarioNombre = _model.perfil!.nombre;
            safeSetState(() {});
            FFAppState().usuarioCorreo = _model.perfil!.correo;
            safeSetState(() {});
            FFAppState().usuarioTelefono = _model.perfil!.telefono;
            safeSetState(() {});
          } else {
            if ((_model.perfil?.codigoHttp == 401 ||
                _model.perfil?.codigoHttp == 403)!) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _model.perfil!.mensaje,
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
        }
      }
    });

    _model.toggleValue = FFAppState().notificaciones;
    _model.editarNombreTextController ??= TextEditingController();
    _model.editarNombreFocusNode ??= FocusNode();

    _model.editarTelefonoTextController ??= TextEditingController();
    _model.editarTelefonoFocusNode ??= FocusNode();

    _model.editarColoniaTextController ??= TextEditingController();
    _model.editarColoniaFocusNode ??= FocusNode();

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
              crossAxisAlignment: (FFCrossAxisAlignment.stretch).flutterValue,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Stack(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  children: [
                    Container(
                      width: double.infinity,
                      height: 64.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 86.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                            (FFMainAxisAlignment.start).flutterValue,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.center).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Container(
                            width: 112.0,
                            height: 112.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 12.0,
                                  color: Color(0x0F000000),
                                  offset: Offset(
                                    0.0,
                                    4.0,
                                  ),
                                  spreadRadius: 0.0,
                                )
                              ],
                              borderRadius: BorderRadius.circular(999.0),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent1,
                                shape: BoxShape.circle,
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                functions
                                    .iniciales(FFAppState().usuarioNombre)!,
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40.0,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            FFAppState().usuarioNombre,
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
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
                            FFAppState().usuarioCorreo,
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
                          Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(999.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 5.0, 12.0, 5.0),
                              child: Text(
                                'Ciudadano activo · Guadalajara',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 6.0)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                    crossAxisAlignment:
                        (FFCrossAxisAlignment.stretch).flutterValue,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                            (FFMainAxisAlignment.start).flutterValue,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.center).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 12.0,
                                    color: Color(0x0F000000),
                                    offset: Offset(
                                      0.0,
                                      4.0,
                                    ),
                                    spreadRadius: 0.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 14.0, 8.0, 14.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      (FFMainAxisAlignment.start).flutterValue,
                                  crossAxisAlignment:
                                      (FFCrossAxisAlignment.center)
                                          .flutterValue,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      functions.contarPorEstado(
                                          FFAppState().reportes.toList(),
                                          'Todos')!,
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
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                    ),
                                    Text(
                                      'Reportes',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 2.0)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 12.0,
                                    color: Color(0x0F000000),
                                    offset: Offset(
                                      0.0,
                                      4.0,
                                    ),
                                    spreadRadius: 0.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 14.0, 8.0, 14.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      (FFMainAxisAlignment.start).flutterValue,
                                  crossAxisAlignment:
                                      (FFCrossAxisAlignment.center)
                                          .flutterValue,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      functions.contarPorEstado(
                                          FFAppState().reportes.toList(),
                                          'Resuelto')!,
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
                                                .success,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                    ),
                                    Text(
                                      'Resueltos',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 2.0)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 12.0,
                                    color: Color(0x0F000000),
                                    offset: Offset(
                                      0.0,
                                      4.0,
                                    ),
                                    spreadRadius: 0.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 14.0, 8.0, 14.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      (FFMainAxisAlignment.start).flutterValue,
                                  crossAxisAlignment:
                                      (FFCrossAxisAlignment.center)
                                          .flutterValue,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      functions.contarPorEstado(
                                          FFAppState().reportes.toList(),
                                          'Pendiente')!,
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
                                                .warning,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                    ),
                                    Text(
                                      'Pendientes',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 2.0)),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 10.0)),
                      ),
                      Text(
                        'Mi actividad',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
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
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(MisReportesWidget.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12.0,
                                color: Color(0x0F000000),
                                offset: Offset(
                                  0.0,
                                  4.0,
                                ),
                                spreadRadius: 0.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.start).flutterValue,
                              crossAxisAlignment:
                                  (FFCrossAxisAlignment.center).flutterValue,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.history,
                                    color: FlutterFlowTheme.of(context).primary,
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
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        'Historial de reportes',
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
                                      Text(
                                        'Revisa el estado de tus denuncias',
                                        maxLines: 1,
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
                                                  FlutterFlowTheme.of(context)
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
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 2.0)),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 22.0,
                                ),
                              ].divide(SizedBox(width: 14.0)),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(NoticiasWidget.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12.0,
                                color: Color(0x0F000000),
                                offset: Offset(
                                  0.0,
                                  4.0,
                                ),
                                spreadRadius: 0.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.start).flutterValue,
                              crossAxisAlignment:
                                  (FFCrossAxisAlignment.center).flutterValue,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.newspaper,
                                    color: FlutterFlowTheme.of(context).primary,
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
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        'Noticias de mi ciudad',
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
                                      Text(
                                        'Lo último en Guadalajara',
                                        maxLines: 1,
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
                                                  FlutterFlowTheme.of(context)
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
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 2.0)),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 22.0,
                                ),
                              ].divide(SizedBox(width: 14.0)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12.0,
                              color: Color(0x0F000000),
                              offset: Offset(
                                0.0,
                                4.0,
                              ),
                              spreadRadius: 0.0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                                (FFMainAxisAlignment.start).flutterValue,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.center).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Container(
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).accent1,
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Icon(
                                  Icons.notifications_active,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                              ),
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
                                      'Notificaciones',
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
                                    Text(
                                      'Avisos sobre tus reportes',
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
                              ),
                              Switch(
                                value: _model.toggleValue!,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _model.toggleValue = newValue!);
                                  if (newValue!) {
                                    FFAppState().notificaciones =
                                        _model.toggleValue!;
                                    safeSetState(() {});
                                  } else {
                                    FFAppState().notificaciones =
                                        _model.toggleValue!;
                                    safeSetState(() {});
                                  }
                                },
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                activeTrackColor:
                                    FlutterFlowTheme.of(context).accent1,
                                inactiveTrackColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                inactiveThumbColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ].divide(SizedBox(width: 14.0)),
                          ),
                        ),
                      ),
                      Text(
                        'Configuración',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
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
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.editando = !_model.editando!;
                          safeSetState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12.0,
                                color: Color(0x0F000000),
                                offset: Offset(
                                  0.0,
                                  4.0,
                                ),
                                spreadRadius: 0.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.start).flutterValue,
                              crossAxisAlignment:
                                  (FFCrossAxisAlignment.center).flutterValue,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.badge,
                                    color: FlutterFlowTheme.of(context).primary,
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
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        'Información personal',
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
                                      Text(
                                        'Nombre, teléfono y colonia',
                                        maxLines: 1,
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
                                                  FlutterFlowTheme.of(context)
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
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 2.0)),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 22.0,
                                ),
                              ].divide(SizedBox(width: 14.0)),
                            ),
                          ),
                        ),
                      ),
                      if (_model.editando ?? true)
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.start).flutterValue,
                              crossAxisAlignment:
                                  (FFCrossAxisAlignment.stretch).flutterValue,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                if (!_model.conServidor!)
                                  Container(
                                    child: TextFormField(
                                      controller:
                                          _model.editarNombreTextController,
                                      focusNode: _model.editarNombreFocusNode,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Nombre completo',
                                        hintText: FFAppState().usuarioNombre,
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
                                        prefixIcon: Icon(
                                          Icons.person_outline,
                                        ),
                                      ),
                                      style: TextStyle(),
                                      maxLines: null,
                                      validator: _model
                                          .editarNombreTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                if (!_model.conServidor!)
                                  Container(
                                    child: TextFormField(
                                      controller:
                                          _model.editarTelefonoTextController,
                                      focusNode: _model.editarTelefonoFocusNode,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Teléfono',
                                        hintText: FFAppState().usuarioTelefono,
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
                                        prefixIcon: Icon(
                                          Icons.phone,
                                        ),
                                      ),
                                      style: TextStyle(),
                                      maxLines: null,
                                      keyboardType:
                                          (FFKeyboardType.number).flutterValue,
                                      validator: _model
                                          .editarTelefonoTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                if (_model.conServidor ?? true)
                                  Text(
                                    'Tu nombre y teléfono los administra City Care. Aquí puedes cambiar tu colonia.',
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
                                TextFormField(
                                  controller:
                                      _model.editarColoniaTextController,
                                  focusNode: _model.editarColoniaFocusNode,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Colonia',
                                    hintText: FFAppState().usuarioColonia,
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
                                    prefixIcon: Icon(
                                      Icons.home_work,
                                    ),
                                  ),
                                  style: TextStyle(),
                                  maxLines: null,
                                  validator: _model
                                      .editarColoniaTextControllerValidator
                                      .asValidator(context),
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    if (!_model.conServidor!) {
                                      if (_model.editarNombreTextController
                                                  .text !=
                                              null &&
                                          _model.editarNombreTextController
                                                  .text !=
                                              '') {
                                        FFAppState().usuarioNombre = _model
                                            .editarNombreTextController.text;
                                        safeSetState(() {});
                                      }
                                      if (_model.editarTelefonoTextController
                                                  .text !=
                                              null &&
                                          _model.editarTelefonoTextController
                                                  .text !=
                                              '') {
                                        FFAppState().usuarioTelefono = _model
                                            .editarTelefonoTextController.text;
                                        safeSetState(() {});
                                      }
                                    }
                                    if (_model.editarColoniaTextController
                                                .text !=
                                            null &&
                                        _model.editarColoniaTextController
                                                .text !=
                                            '') {
                                      FFAppState().usuarioColonia = _model
                                          .editarColoniaTextController.text;
                                      safeSetState(() {});
                                    }
                                    _model.editando = false;
                                    safeSetState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Datos actualizados',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  },
                                  text: 'Guardar cambios',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                          ),
                        ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'CityCare: reporta y da seguimiento a incidencias urbanas.',
                                style: TextStyle(),
                              ),
                              duration: Duration(milliseconds: 4000),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12.0,
                                color: Color(0x0F000000),
                                offset: Offset(
                                  0.0,
                                  4.0,
                                ),
                                spreadRadius: 0.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.start).flutterValue,
                              crossAxisAlignment:
                                  (FFCrossAxisAlignment.center).flutterValue,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: FlutterFlowTheme.of(context).primary,
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
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        'Acerca de CityCare',
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
                                      Text(
                                        'Versión 1.0 · Proyecto escolar',
                                        maxLines: 1,
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
                                                  FlutterFlowTheme.of(context)
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
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ].divide(SizedBox(height: 2.0)),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 22.0,
                                ),
                              ].divide(SizedBox(width: 14.0)),
                            ),
                          ),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          var confirmDialogResponse = await showDialog<bool>(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('¿Cerrar sesión?'),
                                    content: Text(
                                        'Tendrás que volver a iniciar sesión para reportar.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                            alertDialogContext, false),
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                            alertDialogContext, true),
                                        child: Text('Cerrar sesión'),
                                      ),
                                    ],
                                  );
                                },
                              ) ??
                              false;
                          if (confirmDialogResponse) {
                            _model.urlSalir = await actions.urlServidor();
                            if (!(_model.urlSalir == '')) {
                              _model.result = await actions.cerrarSesionApi(
                                (String? u) {
                                  return u ?? "";
                                }(_model.urlSalir),
                                FFAppState().tokenSesion,
                              );
                              FFAppState().reportes = [];
                              safeSetState(() {});
                            }
                            await actions.guardarTokenSeguro(
                              '',
                            );
                            FFAppState().tokenSesion = '';
                            safeSetState(() {});
                            FFAppState().sesionIniciada = false;
                            safeSetState(() {});

                            context.pushNamed(IniciarSesionWidget.routeName);
                          }

                          safeSetState(() {});
                        },
                        text: 'Cerrar sesión',
                        icon: Icon(
                          Icons.logout,
                          size: 20.0,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
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
                    ].divide(SizedBox(height: 14.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
