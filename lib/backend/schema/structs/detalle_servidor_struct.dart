// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct DetalleServidor
class DetalleServidorStruct extends BaseStruct {
  DetalleServidorStruct({
    /// DetalleServidor.exito
    bool? exito,

    /// DetalleServidor.codigoHttp
    int? codigoHttp,

    /// DetalleServidor.mensaje
    String? mensaje,

    /// DetalleServidor.folio
    String? folio,

    /// DetalleServidor.estado
    String? estado,

    /// DetalleServidor.fotoUrl
    String? fotoUrl,

    /// DetalleServidor.historial
    List<String>? historial,
  })  : _exito = exito,
        _codigoHttp = codigoHttp,
        _mensaje = mensaje,
        _folio = folio,
        _estado = estado,
        _fotoUrl = fotoUrl,
        _historial = historial;

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

  // "fotoUrl" field.
  String? _fotoUrl;
  String get fotoUrl => _fotoUrl ?? '';
  set fotoUrl(String? val) => _fotoUrl = val;

  bool hasFotoUrl() => _fotoUrl != null;

  // "historial" field.
  List<String>? _historial;
  List<String> get historial => _historial ?? const [];
  set historial(List<String>? val) => _historial = val;

  void updateHistorial(Function(List<String>) updateFn) {
    updateFn(_historial ??= []);
  }

  bool hasHistorial() => _historial != null;

  static DetalleServidorStruct fromMap(Map<String, dynamic> data) =>
      DetalleServidorStruct(
        exito: data['exito'] as bool?,
        codigoHttp: castToType<int>(data['codigoHttp']),
        mensaje: data['mensaje'] as String?,
        folio: data['folio'] as String?,
        estado: data['estado'] as String?,
        fotoUrl: data['fotoUrl'] as String?,
        historial: getDataList(data['historial']),
      );

  static DetalleServidorStruct? maybeFromMap(dynamic data) => data is Map
      ? DetalleServidorStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'exito': _exito,
        'codigoHttp': _codigoHttp,
        'mensaje': _mensaje,
        'folio': _folio,
        'estado': _estado,
        'fotoUrl': _fotoUrl,
        'historial': _historial,
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
        'folio': serializeParam(
          _folio,
          ParamType.String,
        ),
        'estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'fotoUrl': serializeParam(
          _fotoUrl,
          ParamType.String,
        ),
        'historial': serializeParam(
          _historial,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static DetalleServidorStruct fromSerializableMap(Map<String, dynamic> data) =>
      DetalleServidorStruct(
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
        fotoUrl: deserializeParam(
          data['fotoUrl'],
          ParamType.String,
          false,
        ),
        historial: deserializeParam<String>(
          data['historial'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'DetalleServidorStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DetalleServidorStruct &&
        exito == other.exito &&
        codigoHttp == other.codigoHttp &&
        mensaje == other.mensaje &&
        folio == other.folio &&
        estado == other.estado &&
        fotoUrl == other.fotoUrl &&
        listEquality.equals(historial, other.historial);
  }

  @override
  int get hashCode => const ListEquality().hash([
        exito,
        codigoHttp,
        mensaje,
        folio,
        estado,
        fotoUrl,
        const ListEquality().hash(historial)
      ]);
}

DetalleServidorStruct createDetalleServidorStruct({
  bool? exito,
  int? codigoHttp,
  String? mensaje,
  String? folio,
  String? estado,
  String? fotoUrl,
}) =>
    DetalleServidorStruct(
      exito: exito,
      codigoHttp: codigoHttp,
      mensaje: mensaje,
      folio: folio,
      estado: estado,
      fotoUrl: fotoUrl,
    );
