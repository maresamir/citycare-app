import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'recuperar_contrasena_widget.dart' show RecuperarContrasenaWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecuperarContrasenaModel
    extends FlutterFlowModel<RecuperarContrasenaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Custom Action - urlServidor] action in RecuperarContrasena widget.
  String? urlRecuperar;
  // State field(s) for campoCorreoRecuperar widget.
  FocusNode? campoCorreoRecuperarFocusNode;
  TextEditingController? campoCorreoRecuperarTextController;
  String? Function(BuildContext, String?)?
      campoCorreoRecuperarTextControllerValidator;
  String? _campoCorreoRecuperarTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Escribe tu correo';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Escribe un correo válido';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    campoCorreoRecuperarTextControllerValidator =
        _campoCorreoRecuperarTextControllerValidator;
  }

  @override
  void dispose() {
    campoCorreoRecuperarFocusNode?.dispose();
    campoCorreoRecuperarTextController?.dispose();
  }
}
