// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct DireccionOSM
class DireccionOSMStruct extends BaseStruct {
  DireccionOSMStruct({
    /// DireccionOSM.display_name
    String? displayName,
  }) : _displayName = displayName;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  set displayName(String? val) => _displayName = val;

  bool hasDisplayName() => _displayName != null;

  static DireccionOSMStruct fromMap(Map<String, dynamic> data) =>
      DireccionOSMStruct(
        displayName: data['display_name'] as String?,
      );

  static DireccionOSMStruct? maybeFromMap(dynamic data) => data is Map
      ? DireccionOSMStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'display_name': _displayName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'display_name': serializeParam(
          _displayName,
          ParamType.String,
        ),
      }.withoutNulls;

  static DireccionOSMStruct fromSerializableMap(Map<String, dynamic> data) =>
      DireccionOSMStruct(
        displayName: deserializeParam(
          data['display_name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DireccionOSMStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DireccionOSMStruct && displayName == other.displayName;
  }

  @override
  int get hashCode => const ListEquality().hash([displayName]);
}

DireccionOSMStruct createDireccionOSMStruct({
  String? displayName,
}) =>
    DireccionOSMStruct(
      displayName: displayName,
    );
