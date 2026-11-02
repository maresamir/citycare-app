import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'registro_widget.dart' show RegistroWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegistroModel extends FlutterFlowModel<RegistroWidget> {
  ///  Local state fields for this page.

  bool? aceptaTerminos = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Custom Action - urlServidor] action in Registro widget.
  String? urlRegistro;
  // State field(s) for campoNombre widget.
  FocusNode? campoNombreFocusNode;
  TextEditingController? campoNombreTextController;
  String? Function(BuildContext, String?)? campoNombreTextControllerValidator;
  String? _campoNombreTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe tu nombre';
    }

    if (val.length < 3) {
      return 'Escribe tu nombre completo';
    }

    return null;
  }

  // State field(s) for campoCorreoRegistro widget.
  FocusNode? campoCorreoRegistroFocusNode;
  TextEditingController? campoCorreoRegistroTextController;
  String? Function(BuildContext, String?)?
      campoCorreoRegistroTextControllerValidator;
  String? _campoCorreoRegistroTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe tu correo';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Escribe un correo válido';
    }
    return null;
  }

  // State field(s) for campoTelefono widget.
  FocusNode? campoTelefonoFocusNode;
  TextEditingController? campoTelefonoTextController;
  String? Function(BuildContext, String?)? campoTelefonoTextControllerValidator;
  String? _campoTelefonoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 10) {
      return 'El teléfono debe tener 10 dígitos';
    }

    return null;
  }

  // State field(s) for campoContrasenaRegistro widget.
  late FocusNode campoContrasenaRegistroPasswordVisibilityFocusNode;
  FocusNode? campoContrasenaRegistroFocusNode;
  TextEditingController? campoContrasenaRegistroTextController;
  late bool campoContrasenaRegistroVisibility;
  String? Function(BuildContext, String?)?
      campoContrasenaRegistroTextControllerValidator;
  String? _campoContrasenaRegistroTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Crea una contraseña';
    }

    if (val.length < 6) {
      return 'Mínimo 6 caracteres';
    }

    return null;
  }

  // State field(s) for campoConfirmar widget.
  late FocusNode campoConfirmarPasswordVisibilityFocusNode;
  FocusNode? campoConfirmarFocusNode;
  TextEditingController? campoConfirmarTextController;
  late bool campoConfirmarVisibility;
  String? Function(BuildContext, String?)?
      campoConfirmarTextControllerValidator;
  String? _campoConfirmarTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirma tu contraseña';
    }

    return null;
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    campoNombreTextControllerValidator = _campoNombreTextControllerValidator;
    campoCorreoRegistroTextControllerValidator =
        _campoCorreoRegistroTextControllerValidator;
    campoTelefonoTextControllerValidator =
        _campoTelefonoTextControllerValidator;
    campoContrasenaRegistroPasswordVisibilityFocusNode = FocusNode();
    campoContrasenaRegistroVisibility = false;
    campoContrasenaRegistroTextControllerValidator =
        _campoContrasenaRegistroTextControllerValidator;
    campoConfirmarPasswordVisibilityFocusNode = FocusNode();
    campoConfirmarVisibility = false;
    campoConfirmarTextControllerValidator =
        _campoConfirmarTextControllerValidator;
  }

  @override
  void dispose() {
    campoNombreFocusNode?.dispose();
    campoNombreTextController?.dispose();

    campoCorreoRegistroFocusNode?.dispose();
    campoCorreoRegistroTextController?.dispose();

    campoTelefonoFocusNode?.dispose();
    campoTelefonoTextController?.dispose();

    campoContrasenaRegistroFocusNode?.dispose();
    campoContrasenaRegistroTextController?.dispose();
    campoContrasenaRegistroPasswordVisibilityFocusNode.dispose();
    campoConfirmarFocusNode?.dispose();
    campoConfirmarTextController?.dispose();
    campoConfirmarPasswordVisibilityFocusNode.dispose();
  }
}
