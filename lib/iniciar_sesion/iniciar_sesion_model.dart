import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'iniciar_sesion_widget.dart' show IniciarSesionWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class IniciarSesionModel extends FlutterFlowModel<IniciarSesionWidget> {
  ///  Local state fields for this page.

  bool? iniciando = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Custom Action - urlServidor] action in IniciarSesion widget.
  String? urlAlAbrir;
  // Stores action output result for [Custom Action - leerTokenSeguro] action in IniciarSesion widget.
  String? tokenGuardado;
  // Stores action output result for [Custom Action - obtenerPerfil] action in IniciarSesion widget.
  UsuarioSesionStruct? perfilAlAbrir;
  // State field(s) for campoCorreo widget.
  FocusNode? campoCorreoFocusNode;
  TextEditingController? campoCorreoTextController;
  String? Function(BuildContext, String?)? campoCorreoTextControllerValidator;
  String? _campoCorreoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe tu correo';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Escribe un correo válido';
    }
    return null;
  }

  // State field(s) for campoContrasena widget.
  late FocusNode campoContrasenaPasswordVisibilityFocusNode;
  FocusNode? campoContrasenaFocusNode;
  TextEditingController? campoContrasenaTextController;
  late bool campoContrasenaVisibility;
  String? Function(BuildContext, String?)?
      campoContrasenaTextControllerValidator;
  String? _campoContrasenaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe tu contraseña';
    }

    if (val.length < 6) {
      return 'Mínimo 6 caracteres';
    }

    return null;
  }

  // Stores action output result for [Custom Action - urlServidor] action in botonIniciarSesion widget.
  String? urlLogin;
  // Stores action output result for [Custom Action - iniciarSesionApi] action in botonIniciarSesion widget.
  UsuarioSesionStruct? sesion;

  @override
  void initState(BuildContext context) {
    campoCorreoTextControllerValidator = _campoCorreoTextControllerValidator;
    campoContrasenaPasswordVisibilityFocusNode = FocusNode();
    campoContrasenaVisibility = false;
    campoContrasenaTextControllerValidator =
        _campoContrasenaTextControllerValidator;
  }

  @override
  void dispose() {
    campoCorreoFocusNode?.dispose();
    campoCorreoTextController?.dispose();

    campoContrasenaFocusNode?.dispose();
    campoContrasenaTextController?.dispose();
    campoContrasenaPasswordVisibilityFocusNode.dispose();
  }
}
