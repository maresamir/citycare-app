// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct UbicacionGps
class UbicacionGpsStruct extends BaseStruct {
  UbicacionGpsStruct({
    /// UbicacionGps.estado
    String? estado,

    /// UbicacionGps.latitud
    double? latitud,

    /// UbicacionGps.longitud
    double? longitud,

    /// UbicacionGps.precision
    double? precision,
  })  : _estado = estado,
        _latitud = latitud,
        _longitud = longitud,
        _precision = precision;

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  set estado(String? val) => _estado = val;

  bool hasEstado() => _estado != null;

  // "latitud" field.
  double? _latitud;
  double get latitud => _latitud ?? 0.0;
  set latitud(double? val) => _latitud = val;

  void incrementLatitud(double amount) => latitud = latitud + amount;

  bool hasLatitud() => _latitud != null;

  // "longitud" field.
  double? _longitud;
  double get longitud => _longitud ?? 0.0;
  set longitud(double? val) => _longitud = val;

  void incrementLongitud(double amount) => longitud = longitud + amount;

  bool hasLongitud() => _longitud != null;

  // "precision" field.
  double? _precision;
  double get precision => _precision ?? 0.0;
  set precision(double? val) => _precision = val;

  void incrementPrecision(double amount) => precision = precision + amount;

  bool hasPrecision() => _precision != null;

  static UbicacionGpsStruct fromMap(Map<String, dynamic> data) =>
      UbicacionGpsStruct(
        estado: data['estado'] as String?,
        latitud: castToType<double>(data['latitud']),
        longitud: castToType<double>(data['longitud']),
        precision: castToType<double>(data['precision']),
      );

  static UbicacionGpsStruct? maybeFromMap(dynamic data) => data is Map
      ? UbicacionGpsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'estado': _estado,
        'latitud': _latitud,
        'longitud': _longitud,
        'precision': _precision,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'latitud': serializeParam(
          _latitud,
          ParamType.double,
        ),
        'longitud': serializeParam(
          _longitud,
          ParamType.double,
        ),
        'precision': serializeParam(
          _precision,
          ParamType.double,
        ),
      }.withoutNulls;

  static UbicacionGpsStruct fromSerializableMap(Map<String, dynamic> data) =>
      UbicacionGpsStruct(
        estado: deserializeParam(
          data['estado'],
          ParamType.String,
          false,
        ),
        latitud: deserializeParam(
          data['latitud'],
          ParamType.double,
          false,
        ),
        longitud: deserializeParam(
          data['longitud'],
          ParamType.double,
          false,
        ),
        precision: deserializeParam(
          data['precision'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'UbicacionGpsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UbicacionGpsStruct &&
        estado == other.estado &&
        latitud == other.latitud &&
        longitud == other.longitud &&
        precision == other.precision;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([estado, latitud, longitud, precision]);
}

UbicacionGpsStruct createUbicacionGpsStruct({
  String? estado,
  double? latitud,
  double? longitud,
  double? precision,
}) =>
    UbicacionGpsStruct(
      estado: estado,
      latitud: latitud,
      longitud: longitud,
      precision: precision,
    );
