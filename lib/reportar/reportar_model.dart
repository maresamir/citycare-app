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
import 'reportar_widget.dart' show ReportarWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ReportarModel extends FlutterFlowModel<ReportarWidget> {
  ///  Local state fields for this page.

  String? categoria = '';

  String? direccion = '';

  double? latitud;

  double? longitud;

  bool? ubicacionLista = false;

  bool? buscandoUbicacion = true;

  bool? fotoCargada = false;

  String? estadoUbicacion = 'buscando';

  String? textoUbicacion = 'Detectando tu ubicación...';

  double? precisionUbicacion;

  String? origenUbicacion = '';

  String? errorFoto = '';

  String? folio = '';

  bool? enviando = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Custom Action - obtenerUbicacionGps] action in Reportar widget.
  UbicacionGpsStruct? gpsInicial;
  // Stores action output result for [Backend Call - API (DireccionDesdeCoordenadas)] action in Reportar widget.
  ApiCallResponse? direccionInicial;
  // State field(s) for campoCategoria widget.
  String? campoCategoriaValue;
  FormFieldController<String>? campoCategoriaValueController;
  bool isDataUploading_fotoReporte = false;
  FFUploadedFile uploadedLocalFile_fotoReporte =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - obtenerUbicacionGps] action in IconButton widget.
  UbicacionGpsStruct? gpsActualizada;
  // Stores action output result for [Backend Call - API (DireccionDesdeCoordenadas)] action in IconButton widget.
  ApiCallResponse? direccionActualizada;
  // Stores action output result for [Custom Action - obtenerUbicacionGps] action in BotonReintentarUbicacion widget.
  UbicacionGpsStruct? gpsReintento;
  // Stores action output result for [Backend Call - API (DireccionDesdeCoordenadas)] action in BotonReintentarUbicacion widget.
  ApiCallResponse? direccionReintento;
  // State field(s) for campoDescripcion widget.
  FocusNode? campoDescripcionFocusNode;
  TextEditingController? campoDescripcionTextController;
  String? Function(BuildContext, String?)?
      campoDescripcionTextControllerValidator;
  String? _campoDescripcionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length > 300) {
      return 'Máximo 300 caracteres';
    }

    return null;
  }

  // Stores action output result for [Custom Action - urlServidor] action in botonEnviarReporte widget.
  String? urlServidor;
  // Stores action output result for [Custom Action - enviarReporte] action in botonEnviarReporte widget.
  ResultadoEnvioStruct? envio;

  @override
  void initState(BuildContext context) {
    campoDescripcionTextControllerValidator =
        _campoDescripcionTextControllerValidator;
  }

  @override
  void dispose() {
    campoDescripcionFocusNode?.dispose();
    campoDescripcionTextController?.dispose();
  }
}
