// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct RespuestaNoticias
class RespuestaNoticiasStruct extends BaseStruct {
  RespuestaNoticiasStruct({
    /// RespuestaNoticias.status
    String? status,

    /// RespuestaNoticias.items
    List<NoticiaStruct>? items,
  })  : _status = status,
        _items = items;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "items" field.
  List<NoticiaStruct>? _items;
  List<NoticiaStruct> get items => _items ?? const [];
  set items(List<NoticiaStruct>? val) => _items = val;

  void updateItems(Function(List<NoticiaStruct>) updateFn) {
    updateFn(_items ??= []);
  }

  bool hasItems() => _items != null;

  static RespuestaNoticiasStruct fromMap(Map<String, dynamic> data) =>
      RespuestaNoticiasStruct(
        status: data['status'] as String?,
        items: getStructList(
          data['items'],
          NoticiaStruct.fromMap,
        ),
      );

  static RespuestaNoticiasStruct? maybeFromMap(dynamic data) => data is Map
      ? RespuestaNoticiasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'status': _status,
        'items': _items?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'items': serializeParam(
          _items,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static RespuestaNoticiasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      RespuestaNoticiasStruct(
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        items: deserializeStructParam<NoticiaStruct>(
          data['items'],
          ParamType.DataStruct,
          true,
          structBuilder: NoticiaStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'RespuestaNoticiasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RespuestaNoticiasStruct &&
        status == other.status &&
        listEquality.equals(items, other.items);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([status, const ListEquality().hash(items)]);
}

RespuestaNoticiasStruct createRespuestaNoticiasStruct({
  String? status,
}) =>
    RespuestaNoticiasStruct(
      status: status,
    );
