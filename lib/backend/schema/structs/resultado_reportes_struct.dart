// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct ResultadoReportes
class ResultadoReportesStruct extends BaseStruct {
  ResultadoReportesStruct({
    /// ResultadoReportes.exito
    bool? exito,

    /// ResultadoReportes.codigoHttp
    int? codigoHttp,

    /// ResultadoReportes.mensaje
    String? mensaje,

    /// ResultadoReportes.reportes
    List<ReporteStruct>? reportes,
  })  : _exito = exito,
        _codigoHttp = codigoHttp,
        _mensaje = mensaje,
        _reportes = reportes;

  // "exito" field.
  bool? _exito;
  bool get exito => _exito ?? false;
  set exito(bool? val) => _exito = val;

  bool hasExito() => _exito != null;

  // "codigoHttp" field.
  int? _codigoHttp;
  int get codigoHttp => _codigoHttp ?? 0;
  set codigoHttp(int? val) => _codigoHttp = val;

  void incrementCodigoHttp(int amount) => codigoHttp = codigoHttp + amount;

  bool hasCodigoHttp() => _codigoHttp != null;

  // "mensaje" field.
  String? _mensaje;
  String get mensaje => _mensaje ?? '';
  set mensaje(String? val) => _mensaje = val;

  bool hasMensaje() => _mensaje != null;

  // "reportes" field.
  List<ReporteStruct>? _reportes;
  List<ReporteStruct> get reportes => _reportes ?? const [];
  set reportes(List<ReporteStruct>? val) => _reportes = val;

  void updateReportes(Function(List<ReporteStruct>) updateFn) {
    updateFn(_reportes ??= []);
  }

  bool hasReportes() => _reportes != null;

  static ResultadoReportesStruct fromMap(Map<String, dynamic> data) =>
      ResultadoReportesStruct(
        exito: data['exito'] as bool?,
        codigoHttp: castToType<int>(data['codigoHttp']),
        mensaje: data['mensaje'] as String?,
        reportes: getStructList(
          data['reportes'],
          ReporteStruct.fromMap,
        ),
      );

  static ResultadoReportesStruct? maybeFromMap(dynamic data) => data is Map
      ? ResultadoReportesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'exito': _exito,
        'codigoHttp': _codigoHttp,
        'mensaje': _mensaje,
        'reportes': _reportes?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'exito': serializeParam(
          _exito,
          ParamType.bool,
        ),
        'codigoHttp': serializeParam(
          _codigoHttp,
          ParamType.int,
        ),
        'mensaje': serializeParam(
          _mensaje,
          ParamType.String,
        ),
        'reportes': serializeParam(
          _reportes,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static ResultadoReportesStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ResultadoReportesStruct(
        exito: deserializeParam(
          data['exito'],
          ParamType.bool,
          false,
        ),
        codigoHttp: deserializeParam(
          data['codigoHttp'],
          ParamType.int,
          false,
        ),
        mensaje: deserializeParam(
          data['mensaje'],
          ParamType.String,
          false,
        ),
        reportes: deserializeStructParam<ReporteStruct>(
          data['reportes'],
          ParamType.DataStruct,
          true,
          structBuilder: ReporteStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ResultadoReportesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ResultadoReportesStruct &&
        exito == other.exito &&
        codigoHttp == other.codigoHttp &&
        mensaje == other.mensaje &&
        listEquality.equals(reportes, other.reportes);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([exito, codigoHttp, mensaje, const ListEquality().hash(reportes)]);
}

ResultadoReportesStruct createResultadoReportesStruct({
  bool? exito,
  int? codigoHttp,
  String? mensaje,
}) =>
    ResultadoReportesStruct(
      exito: exito,
      codigoHttp: codigoHttp,
      mensaje: mensaje,
    );
