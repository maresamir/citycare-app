# CityCare MX: app móvil (Flutter)

App ciudadana de City Care para Guadalajara. Permite iniciar sesión, reportar incidencias (categoría, foto, GPS y descripción), dar seguimiento a los reportes propios, leer noticias de la ciudad y consultar el perfil.

Se construyó con **FlutterFlow** (proyecto `citycaremx-mjsptk`). Este repositorio es la **exportación completa del código** (8 nov 2026, antes de que termine la prueba de FlutterFlow) y es un proyecto Flutter normal: se abre, se edita y se compila sin FlutterFlow.

> **Desde ahora este repositorio es la fuente del código.** Si se vuelve a exportar desde FlutterFlow, se sobrescriben los cambios hechos aquí.

## Requisitos
- Flutter estable (3.x) con Android SDK (por ejemplo, Android Studio).
- El backend de City Care corriendo (AdonisJS, `npm run dev`, puerto 3333) y accesible desde el celular.

## Cómo correrla
```bash
flutter pub get
flutter run            # con un emulador o celular conectado
flutter build apk      # APK en build/app/outputs/flutter-apk/app-release.apk
```

## Dirección del backend
Está en **`lib/app_constants.dart`**. Es lo único que hay que cambiar cuando cambia el servidor:

```dart
static const String urlApi =
    'https://lynn-likewise-training-vitamins.trycloudflare.com/api/v1';
```

- Debe terminar en `/api/v1`.
- **Vacía** (`''`), la app funciona sin servidor, con datos simulados.
- El valor actual es un túnel rápido de Cloudflare, que **cambia cada vez que se reinicia**. Para la entrega conviene una dirección fija.

| Dónde corre la app | Valor de `urlApi` |
|---|---|
| Cualquier lugar (recomendado) | `https://xxxx.trycloudflare.com/api/v1` (túnel: `cloudflared tunnel --url http://localhost:3333`) |
| Emulador Android en la misma PC que el backend | `http://10.0.2.2:3333/api/v1` |
| Flutter web en la misma PC que el backend | `http://127.0.0.1:3333/api/v1` |
| Celular real en el mismo wifi que la PC | `http://IP_DE_LA_PC:3333/api/v1` |

`android:usesCleartextTraffic="true"` está activado en el AndroidManifest para permitir `http://` mientras se desarrolla. Se puede quitar cuando la API y las fotos usen `https`.

## Qué endpoint llama cada parte
Todas las llamadas están en `lib/custom_code/actions/` (Dart `http`). Los errores `{"error": {"code", "message", "details"}}` se muestran en español.

| Momento en la app | Endpoint | Archivo |
|---|---|---|
| Botón **Iniciar sesión** | `POST /auth/login` | `iniciar_sesion_api.dart` |
| Abrir la app con sesión guardada (restaura la sesión) | `GET /account/profile` | `obtener_perfil.dart` (en `lib/iniciar_sesion/`) |
| Abrir **Perfil** | `GET /account/profile` | `obtener_perfil.dart` |
| **Cerrar sesión** | `POST /account/logout` | `cerrar_sesion_api.dart` |
| Botón **Enviar** en Reportar | `GET /report-categories` (ajusta el nombre de la categoría) y `POST /reports` (multipart: `categoria`, `latitud`, `longitud`, `precisionUbicacion`, `origenUbicacion`, `direccion`, `descripcion`, `foto`) | `enviar_reporte.dart` |
| Abrir **Inicio** o **Mis reportes**, botón ⟳, y cada 20 s mientras Mis reportes está abierta | `GET /reports?page=N&perPage=50` (recorre todas las páginas) | `listar_mis_reportes.dart` |
| Abrir el **detalle** de un reporte | `GET /reports/{id}` (folio, foto, historial) | `obtener_detalle_reporte.dart` |

Otros detalles:
- El token se guarda cifrado con `flutter_secure_storage` (`guardar_token_seguro.dart`, `leer_token_seguro.dart`). Si el servidor responde 401 o 403, la app borra el token y regresa al login.
- Estados: `pending` → Pendiente, `in_progress` → En proceso, `resolved` → Resuelto.
- La foto del detalle usa el widget `lib/custom_code/widgets/foto_reporte.dart`, que muestra un aviso si la imagen no carga.
- **GPS:** en Android, reportar exige la ubicación real. En el navegador (solo `kIsWeb`) se usa una ubicación fija en Guadalajara, enviada como `origenUbicacion = manual`, para poder probar sin GPS.
- No hay registro público ni recuperación de contraseña: con servidor, esas pantallas muestran un aviso ("las cuentas las crea el administrador").

## Estructura
```
lib/                        LA APP (Flutter)
  app_constants.dart        urlApi (dirección del backend)
  app_state.dart            estado global (sesión, token en memoria, reportes)
  custom_code/actions/      llamadas al backend, token cifrado y GPS
  custom_code/widgets/      foto del reporte, fondo con degradado
  backend/schema/structs/   tipos de datos (Reporte, UsuarioSesion, ...)
  iniciar_sesion/  inicio/  reportar/  mis_reportes/  detalle_reporte/
  noticias/  perfil/  registro/  recuperar_contrasena/   pantallas
  components/               tarjetas de reporte y de noticia
android/  ios/  web/  assets/   plataformas y recursos (incluye las fuentes Poppins)
docs/
  ESTADO_PROYECTO.md        qué funciona, qué falta y cómo se configura
  COMPILAR_APK.md           pasos y lista de pruebas para sacar el APK
  icono_citycare_1024.png   ícono de la app (el APK aún usa el de Flutter)
  capturas/                 capturas de las pruebas
  propuestas_backend/       propuestas iniciales de contrato (ya reemplazadas por city-care.v1)
herramientas/
  prueba_backend/           servidor que imita el contrato + 37 pruebas de las acciones
  acciones/                 código de las acciones personalizadas (fuente para pruebas y scripts)
flutterflow/                respaldo del trabajo en FlutterFlow (no es necesario para compilar)
  dsl/edit.dart             historial de todos los cambios hechos con FlutterFlow AI, por fases
  dsl/create.dart           script con el que se creó la app
  lib/flutterflow_project/  mapa del proyecto en FlutterFlow (pantallas, widgets, estado)
```

## Probar sin el backend real
`herramientas/prueba_backend` tiene un servidor que imita `city-care.v1.yaml`:

```bash
cd herramientas/prueba_backend
dart pub get
dart run bin/servidor.dart 3333 --con-datos   # servidor en http://127.0.0.1:3333/api/v1
python generar_prueba.py && dart run bin/prueba_acciones.dart   # 37 pruebas
```

Usuario de prueba **del simulador**: `ciudadano@citycare.com` / `Ciudadano123!`. No es la cuenta del backend real.

## Pendientes conocidos
- **Ícono:** el APK todavía usa el logo de Flutter. Para cambiarlo sin FlutterFlow, usa `docs/icono_citycare_1024.png` con el paquete `flutter_launcher_icons` o desde Android Studio (Image Asset).
- **Descripción en Reportar:** el campo dice que es opcional (salvo en "Otro"), pero el formulario siempre la pide. Se corrige en el validador de `campoDescripcion` en `lib/reportar/reportar_model.dart`.
- **Dirección fija del backend** para la entrega (ver arriba).
- **Fotos:** `fotoUrl` debe ser accesible desde fuera de la red de la PC del backend. Si no, la app muestra "No pudimos cargar la foto".
