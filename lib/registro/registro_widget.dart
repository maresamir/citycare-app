import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'registro_model.dart';
export 'registro_model.dart';

/// Registro de nuevo ciudadano (simulado hasta conectar el backend).
class RegistroWidget extends StatefulWidget {
  const RegistroWidget({super.key});

  static String routeName = 'Registro';
  static String routePath = '/registro';

  @override
  State<RegistroWidget> createState() => _RegistroWidgetState();
}

class _RegistroWidgetState extends State<RegistroWidget> {
  late RegistroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegistroModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.urlRegistro = await actions.urlServidor();
      if (!(_model.urlRegistro == '')) {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Cuentas de City Care'),
              content: Text(
                  'Las cuentas las crea el administrador de City Care. Pídele tu correo y contraseña, y después inicia sesión.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Entendido'),
                ),
              ],
            );
          },
        );
        context.pop();
      }
    });

    _model.campoNombreTextController ??= TextEditingController();
    _model.campoNombreFocusNode ??= FocusNode();

    _model.campoCorreoRegistroTextController ??= TextEditingController();
    _model.campoCorreoRegistroFocusNode ??= FocusNode();

    _model.campoTelefonoTextController ??= TextEditingController();
    _model.campoTelefonoFocusNode ??= FocusNode();

    _model.campoContrasenaRegistroTextController ??= TextEditingController();
    _model.campoContrasenaRegistroFocusNode ??= FocusNode();

    _model.campoConfirmarTextController ??= TextEditingController();
    _model.campoConfirmarFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                  'Crear cuenta',
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
                                  'Únete y mejora tu colonia',
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
                              Icons.arrow_back,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.pop();
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
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                          (FFMainAxisAlignment.start).flutterValue,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.center).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
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
                          child: Padding(
                            padding: EdgeInsets.all(22.0),
                            child: Form(
                              key: _model.formKey,
                              autovalidateMode: AutovalidateMode.disabled,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    (FFMainAxisAlignment.start).flutterValue,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.stretch).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  TextFormField(
                                    controller:
                                        _model.campoNombreTextController,
                                    focusNode: _model.campoNombreFocusNode,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Nombre completo',
                                      hintText: 'Ej. Juan Delgado',
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
                                        .campoNombreTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller: _model
                                        .campoCorreoRegistroTextController,
                                    focusNode:
                                        _model.campoCorreoRegistroFocusNode,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Correo electrónico',
                                      hintText: 'ejemplo@correo.com',
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
                                        Icons.mail_outline,
                                      ),
                                    ),
                                    style: TextStyle(),
                                    maxLines: null,
                                    keyboardType: (FFKeyboardType.emailAddress)
                                        .flutterValue,
                                    validator: _model
                                        .campoCorreoRegistroTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller:
                                        _model.campoTelefonoTextController,
                                    focusNode: _model.campoTelefonoFocusNode,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Teléfono',
                                      hintText: '33 1234 5678',
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
                                        .campoTelefonoTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller: _model
                                        .campoContrasenaRegistroTextController,
                                    focusNode:
                                        _model.campoContrasenaRegistroFocusNode,
                                    obscureText: !_model
                                        .campoContrasenaRegistroVisibility,
                                    decoration: InputDecoration(
                                      labelText: 'Contraseña',
                                      hintText: 'Mínimo 6 caracteres',
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
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () async {
                                          safeSetState(() => _model
                                                  .campoContrasenaRegistroVisibility =
                                              !_model
                                                  .campoContrasenaRegistroVisibility);
                                        },
                                        focusNode: _model
                                            .campoContrasenaRegistroPasswordVisibilityFocusNode
                                          ..skipTraversal = !(false),
                                        child: Icon(
                                          _model.campoContrasenaRegistroVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(),
                                    validator: _model
                                        .campoContrasenaRegistroTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller:
                                        _model.campoConfirmarTextController,
                                    focusNode: _model.campoConfirmarFocusNode,
                                    obscureText:
                                        !_model.campoConfirmarVisibility,
                                    decoration: InputDecoration(
                                      labelText: 'Confirmar contraseña',
                                      hintText: 'Repite tu contraseña',
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
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () async {
                                          safeSetState(() => _model
                                                  .campoConfirmarVisibility =
                                              !_model.campoConfirmarVisibility);
                                        },
                                        focusNode: _model
                                            .campoConfirmarPasswordVisibilityFocusNode
                                          ..skipTraversal = !(false),
                                        child: Icon(
                                          _model.campoConfirmarVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(),
                                    validator: _model
                                        .campoConfirmarTextControllerValidator
                                        .asValidator(context),
                                  ),
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
                                      Theme(
                                        data: ThemeData(
                                          checkboxTheme: CheckboxThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                          ),
                                          unselectedWidgetColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                        ),
                                        child: Checkbox(
                                          value: _model.checkboxValue ??=
                                              _model.aceptaTerminos!,
                                          onChanged: (newValue) async {
                                            safeSetState(() => _model
                                                .checkboxValue = newValue!);
                                            if (newValue!) {
                                              _model.aceptaTerminos =
                                                  _model.checkboxValue;
                                              safeSetState(() {});
                                            } else {
                                              _model.aceptaTerminos =
                                                  _model.checkboxValue;
                                              safeSetState(() {});
                                            }
                                          },
                                          side: (FlutterFlowTheme.of(context)
                                                      .secondaryText !=
                                                  null)
                                              ? BorderSide(
                                                  width: 2,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText!,
                                                )
                                              : null,
                                          activeColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          checkColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Acepto los Términos y el Aviso de Privacidad',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
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
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 4.0)),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      if (_model.formKey.currentState == null ||
                                          !_model.formKey.currentState!
                                              .validate()) {
                                        return;
                                      }
                                      if (!_model.aceptaTerminos!) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Debes aceptar los términos para continuar',
                                              style: TextStyle(),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                          ),
                                        );
                                      } else {
                                        if (_model
                                                .campoContrasenaRegistroTextController
                                                .text ==
                                            _model.campoConfirmarTextController
                                                .text) {
                                          FFAppState().usuarioNombre = _model
                                              .campoNombreTextController.text;
                                          safeSetState(() {});
                                          FFAppState().usuarioCorreo = _model
                                              .campoCorreoRegistroTextController
                                              .text;
                                          safeSetState(() {});
                                          FFAppState().usuarioTelefono = _model
                                              .campoTelefonoTextController.text;
                                          safeSetState(() {});
                                          FFAppState().sesionIniciada = true;
                                          safeSetState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '¡Bienvenido a CityCare!',
                                                style: TextStyle(),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                            ),
                                          );

                                          context.pushNamed(
                                              InicioWidget.routeName);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Las contraseñas no coinciden',
                                                style: TextStyle(),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    text: 'Crear cuenta',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 52.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      borderRadius: BorderRadius.circular(14.0),
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
                                        '¿Ya tienes cuenta?',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pop();
                                        },
                                        child: Container(
                                          child: Text(
                                            'Inicia sesión',
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
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
                                ].divide(SizedBox(height: 14.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
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
