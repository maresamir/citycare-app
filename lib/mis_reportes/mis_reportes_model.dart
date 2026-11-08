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
import 'mis_reportes_widget.dart' show MisReportesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class MisReportesModel extends FlutterFlowModel<MisReportesWidget> {
  ///  Local state fields for this page.

  String? filtro = 'Todos';

  bool? conServidor = false;

  bool? actualizando = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - urlServidor] action in MisReportes widget.
  String? urlMisReportes;
  // Stores action output result for [Custom Action - listarMisReportes] action in MisReportes widget.
  ResultadoReportesStruct? reportesServidor;
  InstantTimer? actualizarReportes;
  // Stores action output result for [Custom Action - listarMisReportes] action in MisReportes widget.
  ResultadoReportesStruct? reportesPeriodico;
  // Stores action output result for [Custom Action - urlServidor] action in BotonActualizarReportes widget.
  String? urlBotonReportes;
  // Stores action output result for [Custom Action - listarMisReportes] action in BotonActualizarReportes widget.
  ResultadoReportesStruct? reportesBoton;
  // Models for TarjetaReporte.
  late FlutterFlowDynamicModels<TarjetaReporteModel> tarjetaReporteModels;

  @override
  void initState(BuildContext context) {
    tarjetaReporteModels =
        FlutterFlowDynamicModels(() => TarjetaReporteModel());
  }

  @override
  void dispose() {
    actualizarReportes?.cancel();
    tarjetaReporteModels.dispose();
  }
}
