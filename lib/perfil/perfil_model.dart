import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'perfil_widget.dart' show PerfilWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PerfilModel extends FlutterFlowModel<PerfilWidget> {
  ///  Local state fields for this page.

  bool? editando = false;

  bool? conServidor = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - urlServidor] action in Perfil widget.
  String? urlPerfil;
  // Stores action output result for [Custom Action - obtenerPerfil] action in Perfil widget.
  UsuarioSesionStruct? perfil;
  // State field(s) for Toggle widget.
  bool? toggleValue;
  // State field(s) for editarNombre widget.
  FocusNode? editarNombreFocusNode;
  TextEditingController? editarNombreTextController;
  String? Function(BuildContext, String?)? editarNombreTextControllerValidator;
  // State field(s) for editarTelefono widget.
  FocusNode? editarTelefonoFocusNode;
  TextEditingController? editarTelefonoTextController;
  String? Function(BuildContext, String?)?
      editarTelefonoTextControllerValidator;
  // State field(s) for editarColonia widget.
  FocusNode? editarColoniaFocusNode;
  TextEditingController? editarColoniaTextController;
  String? Function(BuildContext, String?)? editarColoniaTextControllerValidator;
  // Stores action output result for [Custom Action - urlServidor] action in Button widget.
  String? urlSalir;
  // Stores action output result for [Custom Action - cerrarSesionApi] action in Button widget.
  bool? result;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    editarNombreFocusNode?.dispose();
    editarNombreTextController?.dispose();

    editarTelefonoFocusNode?.dispose();
    editarTelefonoTextController?.dispose();

    editarColoniaFocusNode?.dispose();
    editarColoniaTextController?.dispose();
  }
}
