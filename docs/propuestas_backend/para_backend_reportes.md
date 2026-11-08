# CityCare MX: datos de un reporte (para el backend)

Código generado por FlutterFlow (Flutter/Dart). Muestra **de dónde salen las coordenadas** y **qué guarda la app** al enviar un reporte. Hoy el reporte se guarda solo en el teléfono (App State). El backend debe recibir estos mismos datos.

---

## 1. Obtener coordenadas (GPS del teléfono)
`lib/reportar/reportar_widget.dart`, al abrir la pantalla "Reportar" (y en el botón "Actualizar ubicación"):

```dart
currentUserLocationValue =
    await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));

_model.latitud  = functions.latitudDe(currentUserLocationValue);   // double
_model.longitud = functions.longitudDe(currentUserLocationValue);  // double

if (_model.latitud == 0.0) {
  // Sin permiso de ubicación
  _model.direccion = 'Activa el permiso de ubicación y toca actualizar.';
} else {
  // Coordenadas -> dirección de texto (OpenStreetMap)
  _model.direccionInicial = await DireccionDesdeCoordenadasCall.call(
    lat: _model.latitud,
    lon: _model.longitud,
  );
  if (_model.direccionInicial?.succeeded ?? true) {
    _model.direccion = DireccionOSMStruct.maybeFromMap(
            _model.direccionInicial?.jsonBody ?? '')
        ?.displayName;
  } else {
    _model.direccion = 'No pudimos obtener la dirección. Toca actualizar.';
  }
  
}
```

## 2. Coordenadas a dirección (OpenStreetMap Nominatim, gratis)
`lib/backend/api_requests/api_calls.dart`:

```dart
class DireccionDesdeCoordenadasCall {
  static Future<ApiCallResponse> call({double? lat, double? lon}) async {
    return ApiManager.instance.makeApiCall(
      callName: 'DireccionDesdeCoordenadas',
      apiUrl:
          'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lon}&zoom=18&accept-language=es',
      callType: ApiCallType.GET,
      headers: {
        'User-Agent': 'CityCareMX/1.0 (mx.citycare.app; proyecto escolar)',
      },
      params: {},
      returnBody: true,
      // ...
    );
  }
}
```

La app solo usa el campo `display_name` de la respuesta, por ejemplo:
`"Avenida Juárez, Zona Centro, Guadalajara, Jalisco, 44100, México"`.

## 3. Guardar el reporte (botón "Enviar reporte")
`lib/reportar/reportar_widget.dart`. **Aquí se conectará la llamada `POST` al backend:**

```dart
FFAppState().insertAtIndexInReportes(
  0,
  ReporteStruct(
    categoria:   _model.categoria,
    descripcion: _model.campoDescripcionTextController.text,
    direccion:   _model.direccion,
    latitud:     _model.latitud,
    longitud:    _model.longitud,
    estado:      'Pendiente',
    fecha:       getCurrentTimestamp,
    tieneFoto:   true,
  ),
);
```

La foto es obligatoria y se guarda en `_model.uploadedLocalFile_fotoReporte` (bytes + nombre del archivo).

## 4. Modelo del reporte
`lib/backend/schema/structs/reporte_struct.dart`:

| Campo         | Tipo Dart  | Ejemplo / valores                                       |
|---------------|------------|---------------------------------------------------------|
| `categoria`   | `String`   | Ver lista abajo                                         |
| `descripcion` | `String`   | Texto libre del ciudadano                               |
| `direccion`   | `String`   | `display_name` de OpenStreetMap                         |
| `latitud`     | `double`   | `20.67665` (0.0 = sin ubicación)                        |
| `longitud`    | `double`   | `-103.34751`                                            |
| `estado`      | `String`   | `Pendiente` · `En proceso` · `Resuelto`                 |
| `fecha`       | `DateTime` | Momento del envío                                       |
| `tieneFoto`   | `bool`     | Siempre `true` hoy                                      |

**Categorías** (dropdown): `Bache`, `Alumbrado público`, `Fuga de agua`, `Basura acumulada`, `Semáforo dañado`, `Banqueta dañada`, `Árbol caído`, `Grafiti o vandalismo`, `Otro`.

---

## Qué necesita la app del backend (sugerencia)

**`POST /reportes`** (`multipart/form-data`, con `Authorization: Bearer <token>`):
- `categoria`, `descripcion`, `direccion` (string)
- `latitud`, `longitud` (number; en BD se recomienda `DECIMAL(9,6)`)
- `foto` (archivo jpg/png)

La respuesta debe devolver el reporte creado con `id`, `estado` (`Pendiente`), `fecha` (ISO 8601) y `fotoUrl`.

**`GET /reportes`** (los del usuario con sesión) debe devolver una lista con esos mismos campos, más `id` y `fotoUrl`.

La conversión de coordenadas a dirección **la hace la app** con OpenStreetMap. El backend solo guarda `direccion` como texto; no necesita ninguna API de mapas.
