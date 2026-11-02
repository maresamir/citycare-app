// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct ResultadoEnvio
class ResultadoEnvioStruct extends BaseStruct {
  ResultadoEnvioStruct({
    /// ResultadoEnvio.exito
    bool? exito,

    /// ResultadoEnvio.codigoHttp
    int? codigoHttp,

    /// ResultadoEnvio.id
    int? id,

    /// ResultadoEnvio.folio
    String? folio,

    /// ResultadoEnvio.estado
    String? estado,

    /// ResultadoEnvio.estadoEvidencia
    String? estadoEvidencia,

    /// ResultadoEnvio.creadoEn
    String? creadoEn,

    /// ResultadoEnvio.mensaje
    String? mensaje,
  })  : _exito = exito,
        _codigoHttp = codigoHttp,
        _id = id,
        _folio = folio,
        _estado = estado,
        _estadoEvidencia = estadoEvidencia,
        _creadoEn = creadoEn,
        _mensaje = mensaje;

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

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "folio" field.
  String? _folio;
  String get folio => _folio ?? '';
  set folio(String? val) => _folio = val;

  bool hasFolio() => _folio != null;

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  set estado(String? val) => _estado = val;

  bool hasEstado() => _estado != null;

  // "estadoEvidencia" field.
  String? _estadoEvidencia;
  String get estadoEvidencia => _estadoEvidencia ?? '';
  set estadoEvidencia(String? val) => _estadoEvidencia = val;

  bool hasEstadoEvidencia() => _estadoEvidencia != null;

  // "creadoEn" field.
  String? _creadoEn;
  String get creadoEn => _creadoEn ?? '';
  set creadoEn(String? val) => _creadoEn = val;

  bool hasCreadoEn() => _creadoEn != null;

  // "mensaje" field.
  String? _mensaje;
  String get mensaje => _mensaje ?? '';
  set mensaje(String? val) => _mensaje = val;

  bool hasMensaje() => _mensaje != null;

  static ResultadoEnvioStruct fromMap(Map<String, dynamic> data) =>
      ResultadoEnvioStruct(
        exito: data['exito'] as bool?,
        codigoHttp: castToType<int>(data['codigoHttp']),
        id: castToType<int>(data['id']),
        folio: data['folio'] as String?,
        estado: data['estado'] as String?,
        estadoEvidencia: data['estadoEvidencia'] as String?,
        creadoEn: data['creadoEn'] as String?,
        mensaje: data['mensaje'] as String?,
      );

  static ResultadoEnvioStruct? maybeFromMap(dynamic data) => data is Map
      ? ResultadoEnvioStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'exito': _exito,
        'codigoHttp': _codigoHttp,
        'id': _id,
        'folio': _folio,
        'estado': _estado,
        'estadoEvidencia': _estadoEvidencia,
        'creadoEn': _creadoEn,
        'mensaje': _mensaje,
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
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'folio': serializeParam(
          _folio,
          ParamType.String,
        ),
        'estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'estadoEvidencia': serializeParam(
          _estadoEvidencia,
          ParamType.String,
        ),
        'creadoEn': serializeParam(
          _creadoEn,
          ParamType.String,
        ),
        'mensaje': serializeParam(
          _mensaje,
          ParamType.String,
        ),
      }.withoutNulls;

  static ResultadoEnvioStruct fromSerializableMap(Map<String, dynamic> data) =>
      ResultadoEnvioStruct(
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
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        folio: deserializeParam(
          data['folio'],
          ParamType.String,
          false,
        ),
        estado: deserializeParam(
          data['estado'],
          ParamType.String,
          false,
        ),
        estadoEvidencia: deserializeParam(
          data['estadoEvidencia'],
          ParamType.String,
          false,
        ),
        creadoEn: deserializeParam(
          data['creadoEn'],
          ParamType.String,
          false,
        ),
        mensaje: deserializeParam(
          data['mensaje'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ResultadoEnvioStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ResultadoEnvioStruct &&
        exito == other.exito &&
        codigoHttp == other.codigoHttp &&
        id == other.id &&
        folio == other.folio &&
        estado == other.estado &&
        estadoEvidencia == other.estadoEvidencia &&
        creadoEn == other.creadoEn &&
        mensaje == other.mensaje;
  }

  @override
  int get hashCode => const ListEquality().hash([
        exito,
        codigoHttp,
        id,
        folio,
        estado,
        estadoEvidencia,
        creadoEn,
        mensaje
      ]);
}

ResultadoEnvioStruct createResultadoEnvioStruct({
  bool? exito,
  int? codigoHttp,
  int? id,
  String? folio,
  String? estado,
  String? estadoEvidencia,
  String? creadoEn,
  String? mensaje,
}) =>
    ResultadoEnvioStruct(
      exito: exito,
      codigoHttp: codigoHttp,
      id: id,
      folio: folio,
      estado: estado,
      estadoEvidencia: estadoEvidencia,
      creadoEn: creadoEn,
      mensaje: mensaje,
    );
