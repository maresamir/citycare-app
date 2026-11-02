// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct UsuarioSesion
class UsuarioSesionStruct extends BaseStruct {
  UsuarioSesionStruct({
    /// UsuarioSesion.exito
    bool? exito,

    /// UsuarioSesion.codigoHttp
    int? codigoHttp,

    /// UsuarioSesion.mensaje
    String? mensaje,

    /// UsuarioSesion.token
    String? token,

    /// UsuarioSesion.nombre
    String? nombre,

    /// UsuarioSesion.correo
    String? correo,

    /// UsuarioSesion.telefono
    String? telefono,
  })  : _exito = exito,
        _codigoHttp = codigoHttp,
        _mensaje = mensaje,
        _token = token,
        _nombre = nombre,
        _correo = correo,
        _telefono = telefono;

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

  // "token" field.
  String? _token;
  String get token => _token ?? '';
  set token(String? val) => _token = val;

  bool hasToken() => _token != null;

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  set nombre(String? val) => _nombre = val;

  bool hasNombre() => _nombre != null;

  // "correo" field.
  String? _correo;
  String get correo => _correo ?? '';
  set correo(String? val) => _correo = val;

  bool hasCorreo() => _correo != null;

  // "telefono" field.
  String? _telefono;
  String get telefono => _telefono ?? '';
  set telefono(String? val) => _telefono = val;

  bool hasTelefono() => _telefono != null;

  static UsuarioSesionStruct fromMap(Map<String, dynamic> data) =>
      UsuarioSesionStruct(
        exito: data['exito'] as bool?,
        codigoHttp: castToType<int>(data['codigoHttp']),
        mensaje: data['mensaje'] as String?,
        token: data['token'] as String?,
        nombre: data['nombre'] as String?,
        correo: data['correo'] as String?,
        telefono: data['telefono'] as String?,
      );

  static UsuarioSesionStruct? maybeFromMap(dynamic data) => data is Map
      ? UsuarioSesionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'exito': _exito,
        'codigoHttp': _codigoHttp,
        'mensaje': _mensaje,
        'token': _token,
        'nombre': _nombre,
        'correo': _correo,
        'telefono': _telefono,
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
        'token': serializeParam(
          _token,
          ParamType.String,
        ),
        'nombre': serializeParam(
          _nombre,
          ParamType.String,
        ),
        'correo': serializeParam(
          _correo,
          ParamType.String,
        ),
        'telefono': serializeParam(
          _telefono,
          ParamType.String,
        ),
      }.withoutNulls;

  static UsuarioSesionStruct fromSerializableMap(Map<String, dynamic> data) =>
      UsuarioSesionStruct(
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
        token: deserializeParam(
          data['token'],
          ParamType.String,
          false,
        ),
        nombre: deserializeParam(
          data['nombre'],
          ParamType.String,
          false,
        ),
        correo: deserializeParam(
          data['correo'],
          ParamType.String,
          false,
        ),
        telefono: deserializeParam(
          data['telefono'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UsuarioSesionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UsuarioSesionStruct &&
        exito == other.exito &&
        codigoHttp == other.codigoHttp &&
        mensaje == other.mensaje &&
        token == other.token &&
        nombre == other.nombre &&
        correo == other.correo &&
        telefono == other.telefono;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([exito, codigoHttp, mensaje, token, nombre, correo, telefono]);
}

UsuarioSesionStruct createUsuarioSesionStruct({
  bool? exito,
  int? codigoHttp,
  String? mensaje,
  String? token,
  String? nombre,
  String? correo,
  String? telefono,
}) =>
    UsuarioSesionStruct(
      exito: exito,
      codigoHttp: codigoHttp,
      mensaje: mensaje,
      token: token,
      nombre: nombre,
      correo: correo,
      telefono: telefono,
    );
