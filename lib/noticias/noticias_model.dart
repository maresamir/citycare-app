import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/tarjeta_noticia_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'noticias_widget.dart' show NoticiasWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class NoticiasModel extends FlutterFlowModel<NoticiasWidget> {
  ///  Local state fields for this page.

  List<NoticiaStruct> noticias = [];
  void addToNoticias(NoticiaStruct item) => noticias.add(item);
  void removeFromNoticias(NoticiaStruct item) => noticias.remove(item);
  void removeAtIndexFromNoticias(int index) => noticias.removeAt(index);
  void insertAtIndexInNoticias(int index, NoticiaStruct item) =>
      noticias.insert(index, item);
  void updateNoticiasAtIndex(int index, Function(NoticiaStruct) updateFn) =>
      noticias[index] = updateFn(noticias[index]);

  bool? cargando = true;

  bool? error = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (NoticiasGuadalajara)] action in Noticias widget.
  ApiCallResponse? noticiasIniciales;
  // Stores action output result for [Backend Call - API (NoticiasGuadalajara)] action in IconButton widget.
  ApiCallResponse? noticiasActualizadas;
  // Stores action output result for [Backend Call - API (NoticiasGuadalajara)] action in Button widget.
  ApiCallResponse? noticiasReintento;
  // Models for TarjetaNoticia.
  late FlutterFlowDynamicModels<TarjetaNoticiaModel> tarjetaNoticiaModels;

  @override
  void initState(BuildContext context) {
    tarjetaNoticiaModels =
        FlutterFlowDynamicModels(() => TarjetaNoticiaModel());
  }

  @override
  void dispose() {
    tarjetaNoticiaModels.dispose();
  }
}
