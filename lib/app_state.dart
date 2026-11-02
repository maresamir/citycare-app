import 'package:flutter/material.dart'
    show ChangeNotifier, Color, Colors, VoidCallback;
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _sesionIniciada = prefs.getBool('ff_sesionIniciada') ?? _sesionIniciada;
    });
    _safeInit(() {
      _usuarioNombre = prefs.getString('ff_usuarioNombre') ?? _usuarioNombre;
    });
    _safeInit(() {
      _usuarioCorreo = prefs.getString('ff_usuarioCorreo') ?? _usuarioCorreo;
    });
    _safeInit(() {
      _usuarioTelefono =
          prefs.getString('ff_usuarioTelefono') ?? _usuarioTelefono;
    });
    _safeInit(() {
      _usuarioColonia = prefs.getString('ff_usuarioColonia') ?? _usuarioColonia;
    });
    _safeInit(() {
      _notificaciones = prefs.getBool('ff_notificaciones') ?? _notificaciones;
    });
    _safeInit(() {
      _reportes = prefs
              .getStringList('ff_reportes')
              ?.map((x) {
                try {
                  return ReporteStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _reportes;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  /// DSL app state sesionIniciada
  bool _sesionIniciada = false;
  bool get sesionIniciada => _sesionIniciada;
  set sesionIniciada(bool value) {
    _sesionIniciada = value;
    prefs.setBool('ff_sesionIniciada', value);
  }

  /// DSL app state usuarioNombre
  String _usuarioNombre = '';
  String get usuarioNombre => _usuarioNombre;
  set usuarioNombre(String value) {
    _usuarioNombre = value;
    prefs.setString('ff_usuarioNombre', value);
  }

  /// DSL app state usuarioCorreo
  String _usuarioCorreo = '';
  String get usuarioCorreo => _usuarioCorreo;
  set usuarioCorreo(String value) {
    _usuarioCorreo = value;
    prefs.setString('ff_usuarioCorreo', value);
  }

  /// DSL app state usuarioTelefono
  String _usuarioTelefono = '';
  String get usuarioTelefono => _usuarioTelefono;
  set usuarioTelefono(String value) {
    _usuarioTelefono = value;
    prefs.setString('ff_usuarioTelefono', value);
  }

  /// DSL app state usuarioColonia
  String _usuarioColonia = 'Guadalajara';
  String get usuarioColonia => _usuarioColonia;
  set usuarioColonia(String value) {
    _usuarioColonia = value;
    prefs.setString('ff_usuarioColonia', value);
  }

  /// DSL app state notificaciones
  bool _notificaciones = true;
  bool get notificaciones => _notificaciones;
  set notificaciones(bool value) {
    _notificaciones = value;
    prefs.setBool('ff_notificaciones', value);
  }

  /// DSL app state reportes
  List<ReporteStruct> _reportes = [];
  List<ReporteStruct> get reportes => _reportes;
  set reportes(List<ReporteStruct> value) {
    _reportes = value;
    prefs.setStringList(
        'ff_reportes', value.map((x) => x.serialize()).toList());
  }

  void addToReportes(ReporteStruct value) {
    reportes.add(value);
    prefs.setStringList(
        'ff_reportes', _reportes.map((x) => x.serialize()).toList());
  }

  void removeFromReportes(ReporteStruct value) {
    reportes.remove(value);
    prefs.setStringList(
        'ff_reportes', _reportes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromReportes(int index) {
    reportes.removeAt(index);
    prefs.setStringList(
        'ff_reportes', _reportes.map((x) => x.serialize()).toList());
  }

  void updateReportesAtIndex(
    int index,
    ReporteStruct Function(ReporteStruct) updateFn,
  ) {
    reportes[index] = updateFn(_reportes[index]);
    prefs.setStringList(
        'ff_reportes', _reportes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInReportes(int index, ReporteStruct value) {
    reportes.insert(index, value);
    prefs.setStringList(
        'ff_reportes', _reportes.map((x) => x.serialize()).toList());
  }

  /// DSL app state tokenSesion
  String _tokenSesion = '';
  String get tokenSesion => _tokenSesion;
  set tokenSesion(String value) {
    _tokenSesion = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
