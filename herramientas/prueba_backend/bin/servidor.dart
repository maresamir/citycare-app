// Levanta el servidor simulado en un puerto fijo para probar la app web.
// Con --con-datos, Ana (ciudadano@citycare.com) ya tiene dos reportes: uno
// pendiente y otro en proceso.
import 'dart:io';

import 'package:prueba_envio/servidor_simulado.dart';

Future<void> main(List<String> args) async {
  final numero = args.where((a) => !a.startsWith('--')).firstOrNull;
  final puerto = numero == null ? 3333 : int.parse(numero);
  final servidor = ServidorSimulado();
  await servidor.iniciar(puerto: puerto);
  if (args.contains('--con-datos')) {
    final ejemplos = [
      ('Bache', 'Bache profundo en el carril derecho', 'Av. Juárez 120, Centro, Guadalajara',
          '20.676650', '-103.347510', '2026-10-28T16:20:00.000Z'),
      ('Alumbrado público', 'Tres luminarias apagadas', 'Calle Morelos 45, Centro, Guadalajara',
          '20.674100', '-103.350200', '2026-10-30T02:05:00.000Z'),
    ];
    for (final (categoria, descripcion, direccion, lat, lon, fecha) in ejemplos) {
      final id = servidor.siguienteReporte++;
      servidor.reportes.add({
        'id': id,
        'userId': 1,
        'folio': 'CC-2026-${id.toString().padLeft(6, '0')}',
        'categoria': categoria,
        'descripcion': descripcion,
        'direccion': direccion,
        'latitud': lat,
        'longitud': lon,
        'precisionUbicacion': 8.0,
        'origenUbicacion': 'gps',
        'estadoCodigo': 'pending',
        'estado': 'Pendiente',
        'estadoEvidencia': 'Pendiente',
        'creadoEn': fecha,
      });
    }
    servidor.cambiarEstado(2, 'in_progress', 'En proceso');
  }
  stdout.writeln('Servidor simulado listo en http://127.0.0.1:${servidor.puerto}/api/v1');
}
