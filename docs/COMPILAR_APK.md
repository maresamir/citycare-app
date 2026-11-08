# Cómo sacar el APK cuando Miguel prenda el servidor

La app ya está lista. **Lo único que falta es poner la dirección nueva del túnel.**

## 1. Pedirle a Miguel
1. Que prenda el backend y el túnel: `cloudflared tunnel --url http://localhost:3333`.
2. Que te mande la dirección nueva: `https://algo.trycloudflare.com`.
3. Que **deje esa ventana abierta**. Si la cierra o reinicia, la dirección cambia y el APK deja de conectar.
4. Que confirme si `fotoUrl` ya es accesible desde fuera (`https`). Si sigue en `http://192.168.100.228:9000`, las fotos no cargarán fuera de su wifi; la app mostrará "No pudimos cargar la foto".

## 2. Cambiar la dirección
**Opción fácil:** pásale la dirección a Claude y dile "conéctala". La prueba primero y la cambia en la app.

**Opción manual, en FlutterFlow:**
1. Busca `urlApi` con Ctrl + K (App Values › Constants).
2. Pega la dirección **agregando `/api/v1` al final**: `https://algo.trycloudflare.com/api/v1`.
3. Guarda.

## 3. Probar antes de compilar (2 minutos)
En FlutterFlow toca **Run** e inicia sesión con tu cuenta. Revisa Inicio, Mis reportes y el detalle de un reporte. En el navegador, Reportar puede no tener GPS: enviar un reporte se prueba en el celular.

## 4. Generar el APK
En FlutterFlow, abre el menú de descarga o compilación, elige **Download APK** e instálalo en el celular.

## 5. Probar en el celular
- [ ] Iniciar sesión.
- [ ] Reportar: acepta el permiso de ubicación, elige categoría, toma una foto y toca Enviar. Debe aparecer el folio `CC-AÑO-000000`.
- [ ] Prueba varias categorías, no solo "Otro". Solo se ha probado "Otro" contra el servidor real.
- [ ] Mis reportes: aparece el reporte nuevo.
- [ ] Pídele a Miguel que cambie el estado: se actualiza solo en unos 20 segundos, o con el botón ⟳.
- [ ] Detalle: folio, foto e historial.
- [ ] Cierra y abre la app: la sesión sigue. Cerrar sesión regresa al login.

## Antes de la entrega
- **Ícono:** el APK todavía usa el logo de Flutter. Sube `icono_citycare_1024.png` en FlutterFlow: **Settings and Integrations › App Assets › Launcher Icon**.
- **Dirección fija:** el túnel `trycloudflare` cambia al reiniciarse. Si el APK debe funcionar días después, Miguel necesita una dirección fija (dominio propio o ngrok con dominio gratuito).
