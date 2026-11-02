# CityCare MX: estado del proyecto (1 nov 2026)

**Objetivo:** app en FlutterFlow (proyecto `citycaremx-mjsptk`) donde un ciudadano de Guadalajara inicia sesión, crea reportes de incidencias (categoría, foto, GPS, descripción) que llegan al backend de Miguel (AdonisJS + MySQL + MinIO), da seguimiento a sus reportes, lee noticias de GDL y consulta su perfil. Al final se exporta como APK.

## Lo que funciona
- **Pantallas:** Iniciar sesión, Registro, Recuperar contraseña, Inicio, Reportar, Mis reportes, Detalle, Noticias (UDG TV con miniaturas) y Perfil.
- **Reportar:**
  - Lee el GPS sin inventar ubicaciones (nunca manda 0,0) y da mensajes claros si falla.
  - Obtiene la dirección desde OpenStreetMap.
  - Valida la foto (JPG o PNG, máximo 10 MB).
  - La descripción es obligatoria solo en "Otro".
  - El botón Enviar se bloquea sin GPS y mientras envía.
- **Conexión con el backend de Miguel** (contrato `city-care.v1.yaml` y "Guía de conexión Flutter"):

  | Momento | Endpoint |
  |---|---|
  | Tocar Entrar | `POST /auth/login` |
  | Abrir la app con sesión guardada (restaura la sesión) | `GET /account/profile` |
  | Abrir Perfil | `GET /account/profile` |
  | Cerrar sesión | `POST /account/logout` |
  | Tocar Enviar en Reportar (primero ajusta el nombre de la categoría al catálogo) | `GET /report-categories` y `POST /reports` |
  | Abrir Inicio o Mis reportes | `GET /reports` (solo los reportes propios, todas las páginas) |
  | Abrir el detalle de un reporte (foto, folio, historial) | `GET /reports/:id` |

- **Seguridad de la sesión, según la guía:**
  - El token se guarda cifrado (`flutter_secure_storage`), ya no en SharedPreferences.
  - Al abrir la app se valida con el perfil. Si el servidor responde 401 o 403, se borra el token y se regresa al login. Sin red, entra con los datos guardados.
  - Al cerrar sesión se avisa primero al servidor y el token se borra aunque falle la red. También se borran los reportes del teléfono.
- **Estados de los reportes:** `pending` → Pendiente, `in_progress` → En proceso, `resolved` → Resuelto. El folio siempre lo genera el servidor.
- **Android:** permite HTTP local (`usesCleartextTraffic`), necesario para `http://10.0.2.2:3333` o la IP de la PC. Con una URL HTTPS definitiva se puede quitar.
- **Sin registro público:** las cuentas las crea el administrador. En modo servidor, Registro y Recuperar contraseña muestran un aviso.
- **Probado:**
  - 37 casos de las acciones contra un servidor simulado que imita la guía (`.ffai_staging/prueba_backend`).
  - La app real compilada para web, contra ese servidor:
    - login → Inicio con 2 reportes del servidor (1 en proceso);
    - Mis reportes con estados;
    - detalle con folio, foto e historial (captura `prueba_detalle_servidor.jpg`);
    - al recargar, la sesión se restaura con el perfil;
    - con el token vencido (401), regresa al login;
    - cerrar sesión avisa al servidor y al recargar se queda en el login.
  - Sin probar en el navegador: enviar un reporte, porque el navegador de prueba no tiene GPS ni cámara. La acción de envío sí pasó sus casos.

## Cómo se configura el servidor
- FlutterFlow › **App Values › Constants › `urlApi`**. Vacía = la app funciona sin servidor; con una dirección = usa el backend. Debe terminar en `/api/v1`.
- **Hoy tiene `http://10.0.2.2:3333/api/v1`**, que solo funciona en el emulador Android de la computadora de Miguel.

| Dónde se prueba | Valor de `urlApi` |
|---|---|
| Emulador Android en la PC de Miguel | `http://10.0.2.2:3333/api/v1` |
| Celular real en la misma red wifi que la PC de Miguel | `http://IP_DE_LA_PC:3333/api/v1` |
| Cualquier lugar (recomendado) | `https://xxxx.trycloudflare.com/api/v1` (túnel de Miguel) |

## Lo que falta (depende de Miguel)
1. **Una dirección a la que llegue la app.** Puede ser su IP local (los dos en la misma red) o un túnel HTTPS (`cloudflared tunnel --url http://localhost:3333`).
2. **CORS activado**, para probar desde el navegador (modo Run de FlutterFlow).
3. **Fotos de MinIO:** con `MINIO_PUBLIC_ENDPOINT=10.0.2.2`, la foto del detalle solo carga en su emulador. En un celular real o en el navegador debe apuntar a una dirección accesible.
4. **El contrato OpenAPI actualizado** (la guía dice que ya existe). Sirve para confirmar los campos de `GET /reports` y `GET /reports/:id`; la app ya acepta las variantes más comunes.
5. **Contraseña del usuario de prueba** `ciudadano@citycare.com`: está en su `.env` y no viene en la guía.

## Otros pendientes
- El plan de prueba Growth del equipo vence el **14 de noviembre**. La exportación del código y las opciones de Android dependen de él.
- El proyecto sobrante `city-care-qw8aq0`, en el espacio Personal, se puede borrar.
- La IA (MobileNetV2) va al final, como sugerencia de categoría (así lo dice la guía).
