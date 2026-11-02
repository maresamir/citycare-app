import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'iniciar_sesion_model.dart';
export 'iniciar_sesion_model.dart';

/// Inicio de sesión (simulado hasta conectar el backend).
class IniciarSesionWidget extends StatefulWidget {
  const IniciarSesionWidget({super.key});

  static String routeName = 'IniciarSesion';
  static String routePath = '/iniciar-sesion';

  @override
  State<IniciarSesionWidget> createState() => _IniciarSesionWidgetState();
}

class _IniciarSesionWidgetState extends State<IniciarSesionWidget> {
  late IniciarSesionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IniciarSesionModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().sesionIniciada) {
        _model.urlAlAbrir = await actions.urlServidor();
        if (!(_model.urlAlAbrir == '')) {
          _model.tokenGuardado = await actions.leerTokenSeguro();
          FFAppState().tokenSesion = ((String? t) {
            return t ?? "";
          }(_model.tokenGuardado))!;
          safeSetState(() {});
          if (FFAppState().tokenSesion == '') {
            FFAppState().sesionIniciada = false;
            safeSetState(() {});
          } else {
            _model.iniciando = true;
            safeSetState(() {});
            _model.perfilAlAbrir = await actions.obtenerPerfil(
              (String? u) {
                return u ?? "";
              }(_model.urlAlAbrir),
              FFAppState().tokenSesion,
            );
            _model.iniciando = false;
            safeSetState(() {});
            if (_model.perfilAlAbrir!.exito) {
              FFAppState().usuarioNombre = _model.perfilAlAbrir!.nombre;
              safeSetState(() {});
              FFAppState().usuarioCorreo = _model.perfilAlAbrir!.correo;
              safeSetState(() {});
              FFAppState().usuarioTelefono = _model.perfilAlAbrir!.telefono;
              safeSetState(() {});

              context.pushNamed(InicioWidget.routeName);
            } else {
              if ((_model.perfilAlAbrir?.codigoHttp == 401 ||
                  _model.perfilAlAbrir?.codigoHttp == 403)!) {
                await actions.guardarTokenSeguro(
                  '',
                );
                FFAppState().tokenSesion = '';
                safeSetState(() {});
                FFAppState().sesionIniciada = false;
                safeSetState(() {});
                FFAppState().reportes = [];
                safeSetState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _model.perfilAlAbrir!.mensaje,
                      style: TextStyle(),
                    ),
                    duration: Duration(milliseconds: 4000),
                  ),
                );
              } else {
                context.pushNamed(InicioWidget.routeName);
              }
            }
          }
        } else {
          context.pushNamed(InicioWidget.routeName);
        }
      }
    });

    _model.campoCorreoTextController ??= TextEditingController();
    _model.campoCorreoFocusNode ??= FocusNode();

    _model.campoContrasenaTextController ??= TextEditingController();
    _model.campoContrasenaFocusNode ??= FocusNode();

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
              crossAxisAlignment: (FFCrossAxisAlignment.center).flutterValue,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Stack(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  children: [
                    Container(
                      width: double.infinity,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 330.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 48.0, 20.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                            (FFMainAxisAlignment.start).flutterValue,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.center).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Container(
                            width: 84.0,
                            height: 84.0,
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
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Icon(
                              Icons.location_city,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 44.0,
                            ),
                          ),
                          Text(
                            'CityCare',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            'Cuidando nuestra ciudad juntos',
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: Container(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 24.0,
                                      color: Color(0x1A000000),
                                      offset: Offset(
                                        0.0,
                                        8.0,
                                      ),
                                      spreadRadius: 0.0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Form(
                                    key: _model.formKey,
                                    autovalidateMode: AutovalidateMode.disabled,
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
                                        Column(
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
                                              'Bienvenido',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmall
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontStyle,
                                                      ),
                                            ),
                                            Text(
                                              'Inicia sesión para continuar',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
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
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ].divide(SizedBox(height: 4.0)),
                                        ),
                                        TextFormField(
                                          controller:
                                              _model.campoCorreoTextController,
                                          focusNode:
                                              _model.campoCorreoFocusNode,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Correo electrónico',
                                            hintText: 'ejemplo@correo.com',
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            filled: true,
                                            prefixIcon: Icon(
                                              Icons.mail_outline,
                                            ),
                                          ),
                                          style: TextStyle(),
                                          maxLines: null,
                                          keyboardType:
                                              (FFKeyboardType.emailAddress)
                                                  .flutterValue,
                                          validator: _model
                                              .campoCorreoTextControllerValidator
                                              .asValidator(context),
                                        ),
                                        TextFormField(
                                          controller: _model
                                              .campoContrasenaTextController,
                                          focusNode:
                                              _model.campoContrasenaFocusNode,
                                          obscureText:
                                              !_model.campoContrasenaVisibility,
                                          decoration: InputDecoration(
                                            labelText: 'Contraseña',
                                            hintText: '••••••••',
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            filled: true,
                                            prefixIcon: Icon(
                                              Icons.lock_outline,
                                            ),
                                            suffixIcon: InkWell(
                                              onTap: () async {
                                                safeSetState(() => _model
                                                        .campoContrasenaVisibility =
                                                    !_model
                                                        .campoContrasenaVisibility);
                                              },
                                              focusNode: _model
                                                  .campoContrasenaPasswordVisibilityFocusNode
                                                ..skipTraversal = !(false),
                                              child: Icon(
                                                _model.campoContrasenaVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(),
                                          validator: _model
                                              .campoContrasenaTextControllerValidator
                                              .asValidator(context),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              (FFMainAxisAlignment.end)
                                                  .flutterValue,
                                          crossAxisAlignment:
                                              (FFCrossAxisAlignment.center)
                                                  .flutterValue,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                    RecuperarContrasenaWidget
                                                        .routeName);
                                              },
                                              child: Container(
                                                child: Text(
                                                  '¿Olvidaste tu contraseña?',
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
                                          ],
                                        ),
                                        FFButtonWidget(
                                          onPressed: _model.iniciando!
                                              ? null
                                              : () async {
                                                  if (_model.formKey
                                                              .currentState ==
                                                          null ||
                                                      !_model
                                                          .formKey.currentState!
                                                          .validate()) {
                                                    return;
                                                  }
                                                  _model.urlLogin =
                                                      await actions
                                                          .urlServidor();
                                                  if (!(_model.urlLogin ==
                                                      '')) {
                                                    _model.iniciando = true;
                                                    safeSetState(() {});
                                                    _model.sesion =
                                                        await actions
                                                            .iniciarSesionApi(
                                                      (String? u) {
                                                        return u ?? "";
                                                      }(_model.urlLogin),
                                                      _model
                                                          .campoCorreoTextController
                                                          .text,
                                                      _model
                                                          .campoContrasenaTextController
                                                          .text,
                                                    );
                                                    _model.iniciando = false;
                                                    safeSetState(() {});
                                                    if (_model.sesion!.exito) {
                                                      await actions
                                                          .guardarTokenSeguro(
                                                        (String? t) {
                                                          return t ?? "";
                                                        }(_model.sesion?.token),
                                                      );
                                                      FFAppState().tokenSesion =
                                                          _model.sesion!.token;
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .usuarioNombre =
                                                          _model.sesion!.nombre;
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .usuarioCorreo =
                                                          _model.sesion!.correo;
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .usuarioTelefono =
                                                          _model
                                                              .sesion!.telefono;
                                                      safeSetState(() {});
                                                      FFAppState().reportes =
                                                          [];
                                                      safeSetState(() {});
                                                      FFAppState()
                                                              .sesionIniciada =
                                                          true;
                                                      safeSetState(() {});
                                                      safeSetState(() {
                                                        _model
                                                            .campoContrasenaTextController
                                                            ?.clear();
                                                      });

                                                      context.pushNamed(
                                                          InicioWidget
                                                              .routeName);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            _model.sesion!
                                                                .mensaje,
                                                            style: TextStyle(),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    FFAppState().usuarioCorreo =
                                                        _model
                                                            .campoCorreoTextController
                                                            .text;
                                                    safeSetState(() {});
                                                    if (FFAppState()
                                                            .usuarioNombre ==
                                                        '') {
                                                      FFAppState()
                                                              .usuarioNombre =
                                                          'Ciudadano';
                                                      safeSetState(() {});
                                                    }
                                                    FFAppState()
                                                        .sesionIniciada = true;
                                                    safeSetState(() {});

                                                    context.pushNamed(
                                                        InicioWidget.routeName);
                                                  }

                                                  safeSetState(() {});
                                                },
                                          text: 'Iniciar sesión',
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 52.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                        ),
                                        if (_model.iniciando ?? true)
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                (FFMainAxisAlignment.center)
                                                    .flutterValue,
                                            crossAxisAlignment:
                                                (FFCrossAxisAlignment.center)
                                                    .flutterValue,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              CircularPercentIndicator(
                                                percent: 0.0,
                                                radius: 8.0,
                                                lineWidth: 2.0,
                                                animation: false,
                                                animateFromLastPercent: true,
                                              ),
                                              Text(
                                                'Iniciando sesión...',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .plusJakartaSans(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ].divide(SizedBox(width: 8.0)),
                                          ),
                                        Container(
                                          child: Visibility(
                                            visible: (false) ?? true,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  (FFMainAxisAlignment.start)
                                                      .flutterValue,
                                              crossAxisAlignment:
                                                  (FFCrossAxisAlignment.center)
                                                      .flutterValue,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Divider(
                                                    thickness: 1.0,
                                                  ),
                                                ),
                                                Text(
                                                  'o',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
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
                                                                .bodySmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Divider(
                                                    thickness: 1.0,
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 12.0)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Visibility(
                                            visible: (false) ?? true,
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'El acceso con Google se activará al conectar el backend.',
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                              },
                                              text: 'Continuar con Google',
                                              icon: Icon(
                                                Icons.account_circle,
                                                size: 20.0,
                                              ),
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                iconColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                color: Colors.transparent,
                                                textStyle: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                ),
                                                elevation: 0.0,
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              (FFMainAxisAlignment.center)
                                                  .flutterValue,
                                          crossAxisAlignment:
                                              (FFCrossAxisAlignment.center)
                                                  .flutterValue,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text(
                                              '¿No tienes una cuenta?',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
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
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                    RegistroWidget.routeName);
                                              },
                                              child: Container(
                                                child: Text(
                                                  'Regístrate',
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
                                          ].divide(SizedBox(width: 6.0)),
                                        ),
                                      ].divide(SizedBox(height: 16.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 20.0),
                              child: Text(
                                'Al continuar, aceptas nuestros Términos y Condiciones',
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
                            ),
                          ),
                        ].divide(SizedBox(height: 12.0)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
