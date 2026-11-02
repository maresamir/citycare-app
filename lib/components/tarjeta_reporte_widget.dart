import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'tarjeta_reporte_model.dart';
export 'tarjeta_reporte_model.dart';

/// Resumen de un reporte con icono de categoría y estado.
class TarjetaReporteWidget extends StatefulWidget {
  const TarjetaReporteWidget({
    super.key,
    String? categoria,
    String? direccion,
    String? fecha,
    String? estado,
    this.alTocar,
  })  : this.categoria = categoria ?? 'Otro',
        this.direccion = direccion ?? '',
        this.fecha = fecha ?? '',
        this.estado = estado ?? 'Pendiente';

  final String categoria;
  final String direccion;
  final String fecha;
  final String estado;
  final Future Function()? alTocar;

  @override
  State<TarjetaReporteWidget> createState() => _TarjetaReporteWidgetState();
}

class _TarjetaReporteWidgetState extends State<TarjetaReporteWidget> {
  late TarjetaReporteModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TarjetaReporteModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await widget.alTocar?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
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
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
            crossAxisAlignment: (FFCrossAxisAlignment.center).flutterValue,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                width: 52.0,
                height: 52.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent1,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    if (widget!.categoria == 'Bache')
                      Icon(
                        Icons.construction,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    if (widget!.categoria == 'Alumbrado público')
                      Icon(
                        Icons.lightbulb,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    if (widget!.categoria == 'Fuga de agua')
                      Icon(
                        Icons.water_drop,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    if (widget!.categoria == 'Basura acumulada')
                      Icon(
                        Icons.delete,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    if (widget!.categoria == 'Semáforo dañado')
                      Icon(
                        Icons.traffic,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    if (widget!.categoria == 'Banqueta dañada')
                      Icon(
                        Icons.directions_walk,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    if (widget!.categoria == 'Árbol caído')
                      Icon(
                        Icons.park,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    if (widget!.categoria == 'Grafiti o vandalismo')
                      Icon(
                        Icons.format_paint,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                    if (widget!.categoria == 'Otro')
                      Icon(
                        Icons.report_problem,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 26.0,
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
                  crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      widget!.categoria,
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget!.direccion,
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget!.fecha,
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelSmall
                                .fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(height: 3.0)),
                ),
              ),
              Stack(
                alignment: AlignmentDirectional(0.0, 0.0),
                children: [
                  if (widget!.estado == 'Pendiente')
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(999.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 5.0, 10.0, 5.0),
                        child: Text(
                          'Pendiente',
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFFEF4444),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                        ),
                      ),
                    ),
                  if (widget!.estado == 'En proceso')
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(999.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 5.0, 10.0, 5.0),
                        child: Text(
                          'En proceso',
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFFD97706),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                        ),
                      ),
                    ),
                  if (widget!.estado == 'Resuelto')
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(999.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 5.0, 10.0, 5.0),
                        child: Text(
                          'Resuelto',
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF059669),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                        ),
                      ),
                    ),
                ],
              ),
            ].divide(SizedBox(width: 14.0)),
          ),
        ),
      ),
    );
  }
}
