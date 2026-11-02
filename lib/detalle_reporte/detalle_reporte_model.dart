import '/backend/schema/structs/index.dart';
import '/components/tarjeta_reporte_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'detalle_reporte_widget.dart' show DetalleReporteWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetalleReporteModel extends FlutterFlowModel<DetalleReporteWidget> {
  ///  Local state fields for this page.

  String? fotoUrl = '';

  List<String> historial = [];
  void addToHistorial(String item) => historial.add(item);
  void removeFromHistorial(String item) => historial.remove(item);
  void removeAtIndexFromHistorial(int index) => historial.removeAt(index);
  void insertAtIndexInHistorial(int index, String item) =>
      historial.insert(index, item);
  void updateHistorialAtIndex(int index, Function(String) updateFn) =>
      historial[index] = updateFn(historial[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - urlServidor] action in DetalleReporte widget.
  String? urlDetalle;
  // Stores action output result for [Custom Action - obtenerDetalleReporte] action in DetalleReporte widget.
  DetalleServidorStruct? detalle;
  // Model for TarjetaReporte.
  late TarjetaReporteModel tarjetaReporteModel;

  @override
  void initState(BuildContext context) {
    tarjetaReporteModel = createModel(context, () => TarjetaReporteModel());
  }

  @override
  void dispose() {
    tarjetaReporteModel.dispose();
  }
}
