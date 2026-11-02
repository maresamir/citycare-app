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
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'noticias_model.dart';
export 'noticias_model.dart';

/// Noticias recientes de Guadalajara y Jalisco (El Informador vía rss2json).
class NoticiasWidget extends StatefulWidget {
  const NoticiasWidget({super.key});

  static String routeName = 'Noticias';
  static String routePath = '/noticias';

  @override
  State<NoticiasWidget> createState() => _NoticiasWidgetState();
}

class _NoticiasWidgetState extends State<NoticiasWidget> {
  late NoticiasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoticiasModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.cargando = true;
      safeSetState(() {});
      _model.error = false;
      safeSetState(() {});
      _model.noticiasIniciales = await NoticiasGuadalajaraCall.call();

      if ((_model.noticiasIniciales?.succeeded ?? true)) {
        _model.noticias = RespuestaNoticiasStruct.maybeFromMap(
                (_model.noticiasIniciales?.jsonBody ?? ''))!
            .items
            .toList()
            .cast<NoticiaStruct>();
        safeSetState(() {});
        _model.cargando = false;
        safeSetState(() {});
      } else {
        _model.cargando = false;
        safeSetState(() {});
        _model.error = true;
        safeSetState(() {});
      }
    });

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
                                  'Noticias GDL',
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
                                  'Lo último en Guadalajara y Jalisco',
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
                              Icons.refresh,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              _model.cargando = true;
                              safeSetState(() {});
                              _model.error = false;
                              safeSetState(() {});
                              _model.noticiasActualizadas =
                                  await NoticiasGuadalajaraCall.call();

                              if ((_model.noticiasActualizadas?.succeeded ??
                                  true)) {
                                _model.noticias =
                                    RespuestaNoticiasStruct.maybeFromMap((_model
                                                .noticiasActualizadas
                                                ?.jsonBody ??
                                            ''))!
                                        .items
                                        .toList()
                                        .cast<NoticiaStruct>();
                                safeSetState(() {});
                                _model.cargando = false;
                                safeSetState(() {});
                              } else {
                                _model.cargando = false;
                                safeSetState(() {});
                                _model.error = true;
                                safeSetState(() {});
                              }

                              safeSetState(() {});
                            },
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ),
                ],
              ),
              if (_model.cargando ?? true)
                Container(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularPercentIndicator(
                      percent: 0.0,
                      radius: 20.0,
                      lineWidth: 4.0,
                      animation: false,
                      animateFromLastPercent: true,
                    ),
                  ),
                ),
              if (_model.error ?? true)
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                          (FFMainAxisAlignment.start).flutterValue,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.center).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 48.0,
                        ),
                        Text(
                          'No pudimos cargar las noticias',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            _model.cargando = true;
                            safeSetState(() {});
                            _model.error = false;
                            safeSetState(() {});
                            _model.noticiasReintento =
                                await NoticiasGuadalajaraCall.call();

                            if ((_model.noticiasReintento?.succeeded ?? true)) {
                              _model.noticias =
                                  RespuestaNoticiasStruct.maybeFromMap(
                                          (_model.noticiasReintento?.jsonBody ??
                                              ''))!
                                      .items
                                      .toList()
                                      .cast<NoticiaStruct>();
                              safeSetState(() {});
                              _model.cargando = false;
                              safeSetState(() {});
                            } else {
                              _model.cargando = false;
                              safeSetState(() {});
                              _model.error = true;
                              safeSetState(() {});
                            }

                            safeSetState(() {});
                          },
                          text: 'Reintentar',
                          options: FFButtonOptions(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: TextStyle(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ].divide(SizedBox(height: 10.0)),
                    ),
                  ),
                ),
              if (!_model.cargando!)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 18.0, 20.0, 20.0),
                    child: Builder(
                      builder: (context) {
                        final noticia = _model.noticias.toList();

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: noticia.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.0),
                          itemBuilder: (context, noticiaIndex) {
                            final noticiaItem = noticia[noticiaIndex];
                            return wrapWithModel(
                              model: _model.tarjetaNoticiaModels.getModel(
                                noticiaIndex.toString(),
                                noticiaIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              child: TarjetaNoticiaWidget(
                                key: Key(
                                  'Key36o_${noticiaIndex.toString()}',
                                ),
                                autor: noticiaItem.author,
                                enlace: noticiaItem.link,
                                fecha:
                                    functions.fechaNoticia(noticiaItem.pubDate),
                                imagen: (String? html) {
                                  return RegExp('<img[^>]+src="([^"]+)"')
                                          .firstMatch(html ?? "")
                                          ?.group(1) ??
                                      "";
                                }(noticiaItem.content),
                                resumen: noticiaItem.description,
                                titulo: noticiaItem.title,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              Container(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: Text(
                    'Fuente: UDG TV',
                    style: FlutterFlowTheme.of(context).labelSmall.override(
                          font: GoogleFonts.plusJakartaSans(
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelSmall.fontStyle,
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
