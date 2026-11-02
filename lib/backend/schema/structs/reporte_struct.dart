// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct Reporte
class ReporteStruct extends BaseStruct {
  ReporteStruct({
    /// Reporte.categoria
    String? categoria,

    /// Reporte.descripcion
    String? descripcion,

    /// Reporte.direccion
    String? direccion,

    /// Reporte.latitud
    double? latitud,

    /// Reporte.longitud
    double? longitud,

    /// Reporte.estado
    String? estado,

    /// Reporte.fecha
    DateTime? fecha,

    /// Reporte.tieneFoto
    bool? tieneFoto,

    /// Reporte.folio
    String? folio,

    /// Reporte.origenUbicacion
    String? origenUbicacion,

    /// Reporte.precisionUbicacion
    double? precisionUbicacion,

    /// Reporte.idServidor
    String? idServidor,

    /// Reporte.fotoUrl
    String? fotoUrl,
  })  : _categoria = categoria,
        _descripcion = descripcion,
        _direccion = direccion,
        _latitud = latitud,
        _longitud = longitud,
        _estado = estado,
        _fecha = fecha,
        _tieneFoto = tieneFoto,
        _folio = folio,
        _origenUbicacion = origenUbicacion,
        _precisionUbicacion = precisionUbicacion,
        _idServidor = idServidor,
        _fotoUrl = fotoUrl;

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  set categoria(String? val) => _categoria = val;

  bool hasCategoria() => _categoria != null;

  // "descripcion" field.
  String? _descripcion;
  String get descripcion => _descripcion ?? '';
  set descripcion(String? val) => _descripcion = val;

  bool hasDescripcion() => _descripcion != null;

  // "direccion" field.
  String? _direccion;
  String get direccion => _direccion ?? '';
  set direccion(String? val) => _direccion = val;

  bool hasDireccion() => _direccion != null;

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

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  set estado(String? val) => _estado = val;

  bool hasEstado() => _estado != null;

  // "fecha" field.
  DateTime? _fecha;
  DateTime? get fecha => _fecha;
  set fecha(DateTime? val) => _fecha = val;

  bool hasFecha() => _fecha != null;

  // "tieneFoto" field.
  bool? _tieneFoto;
  bool get tieneFoto => _tieneFoto ?? false;
  set tieneFoto(bool? val) => _tieneFoto = val;

  bool hasTieneFoto() => _tieneFoto != null;

  // "folio" field.
  String? _folio;
  String get folio => _folio ?? '';
  set folio(String? val) => _folio = val;

  bool hasFolio() => _folio != null;

  // "origenUbicacion" field.
  String? _origenUbicacion;
  String get origenUbicacion => _origenUbicacion ?? '';
  set origenUbicacion(String? val) => _origenUbicacion = val;

  bool hasOrigenUbicacion() => _origenUbicacion != null;

  // "precisionUbicacion" field.
  double? _precisionUbicacion;
  double get precisionUbicacion => _precisionUbicacion ?? 0.0;
  set precisionUbicacion(double? val) => _precisionUbicacion = val;

  void incrementPrecisionUbicacion(double amount) =>
      precisionUbicacion = precisionUbicacion + amount;

  bool hasPrecisionUbicacion() => _precisionUbicacion != null;

  // "idServidor" field.
  String? _idServidor;
  String get idServidor => _idServidor ?? '';
  set idServidor(String? val) => _idServidor = val;

  bool hasIdServidor() => _idServidor != null;

  // "fotoUrl" field.
  String? _fotoUrl;
  String get fotoUrl => _fotoUrl ?? '';
  set fotoUrl(String? val) => _fotoUrl = val;

  bool hasFotoUrl() => _fotoUrl != null;

  static ReporteStruct fromMap(Map<String, dynamic> data) => ReporteStruct(
        categoria: data['categoria'] as String?,
        descripcion: data['descripcion'] as String?,
        direccion: data['direccion'] as String?,
        latitud: castToType<double>(data['latitud']),
        longitud: castToType<double>(data['longitud']),
        estado: data['estado'] as String?,
        fecha: data['fecha'] as DateTime?,
        tieneFoto: data['tieneFoto'] as bool?,
        folio: data['folio'] as String?,
        origenUbicacion: data['origenUbicacion'] as String?,
        precisionUbicacion: castToType<double>(data['precisionUbicacion']),
        idServidor: data['idServidor'] as String?,
        fotoUrl: data['fotoUrl'] as String?,
      );

  static ReporteStruct? maybeFromMap(dynamic data) =>
      data is Map ? ReporteStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'categoria': _categoria,
        'descripcion': _descripcion,
        'direccion': _direccion,
        'latitud': _latitud,
        'longitud': _longitud,
        'estado': _estado,
        'fecha': _fecha,
        'tieneFoto': _tieneFoto,
        'folio': _folio,
        'origenUbicacion': _origenUbicacion,
        'precisionUbicacion': _precisionUbicacion,
        'idServidor': _idServidor,
        'fotoUrl': _fotoUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'categoria': serializeParam(
          _categoria,
          ParamType.String,
        ),
        'descripcion': serializeParam(
          _descripcion,
          ParamType.String,
        ),
        'direccion': serializeParam(
          _direccion,
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
        'estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'fecha': serializeParam(
          _fecha,
          ParamType.DateTime,
        ),
        'tieneFoto': serializeParam(
          _tieneFoto,
          ParamType.bool,
        ),
        'folio': serializeParam(
          _folio,
          ParamType.String,
        ),
        'origenUbicacion': serializeParam(
          _origenUbicacion,
          ParamType.String,
        ),
        'precisionUbicacion': serializeParam(
          _precisionUbicacion,
          ParamType.double,
        ),
        'idServidor': serializeParam(
          _idServidor,
          ParamType.String,
        ),
        'fotoUrl': serializeParam(
          _fotoUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static ReporteStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReporteStruct(
        categoria: deserializeParam(
          data['categoria'],
          ParamType.String,
          false,
        ),
        descripcion: deserializeParam(
          data['descripcion'],
          ParamType.String,
          false,
        ),
        direccion: deserializeParam(
          data['direccion'],
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
        estado: deserializeParam(
          data['estado'],
          ParamType.String,
          false,
        ),
        fecha: deserializeParam(
          data['fecha'],
          ParamType.DateTime,
          false,
        ),
        tieneFoto: deserializeParam(
          data['tieneFoto'],
          ParamType.bool,
          false,
        ),
        folio: deserializeParam(
          data['folio'],
          ParamType.String,
          false,
        ),
        origenUbicacion: deserializeParam(
          data['origenUbicacion'],
          ParamType.String,
          false,
        ),
        precisionUbicacion: deserializeParam(
          data['precisionUbicacion'],
          ParamType.double,
          false,
        ),
        idServidor: deserializeParam(
          data['idServidor'],
          ParamType.String,
          false,
        ),
        fotoUrl: deserializeParam(
          data['fotoUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ReporteStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ReporteStruct &&
        categoria == other.categoria &&
        descripcion == other.descripcion &&
        direccion == other.direccion &&
        latitud == other.latitud &&
        longitud == other.longitud &&
        estado == other.estado &&
        fecha == other.fecha &&
        tieneFoto == other.tieneFoto &&
        folio == other.folio &&
        origenUbicacion == other.origenUbicacion &&
        precisionUbicacion == other.precisionUbicacion &&
        idServidor == other.idServidor &&
        fotoUrl == other.fotoUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([
        categoria,
        descripcion,
        direccion,
        latitud,
        longitud,
        estado,
        fecha,
        tieneFoto,
        folio,
        origenUbicacion,
        precisionUbicacion,
        idServidor,
        fotoUrl
      ]);
}

ReporteStruct createReporteStruct({
  String? categoria,
  String? descripcion,
  String? direccion,
  double? latitud,
  double? longitud,
  String? estado,
  DateTime? fecha,
  bool? tieneFoto,
  String? folio,
  String? origenUbicacion,
  double? precisionUbicacion,
  String? idServidor,
  String? fotoUrl,
}) =>
    ReporteStruct(
      categoria: categoria,
      descripcion: descripcion,
      direccion: direccion,
      latitud: latitud,
      longitud: longitud,
      estado: estado,
      fecha: fecha,
      tieneFoto: tieneFoto,
      folio: folio,
      origenUbicacion: origenUbicacion,
      precisionUbicacion: precisionUbicacion,
      idServidor: idServidor,
      fotoUrl: fotoUrl,
    );
