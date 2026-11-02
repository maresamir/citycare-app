import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';

/// Latitud de una coordenada.
double? latitudDe(LatLng? ubicacion) {
  return ubicacion?.latitude;
}

/// Longitud de una coordenada.
double? longitudDe(LatLng? ubicacion) {
  return ubicacion?.longitude;
}

/// Formatea latitud y longitud para mostrarlas.
String? textoCoordenadas(
  double? lat,
  double? lon,
) {
  final la = lat ?? 0.0;
  final lo = lon ?? 0.0;
  return '${la.toStringAsFixed(5)}, ${lo.toStringAsFixed(5)}';
}

/// Enlace a OpenStreetMap centrado en el reporte.
String? urlMapa(
  double? lat,
  double? lon,
) {
  final la = lat ?? 0.0;
  final lo = lon ?? 0.0;
  return 'https://www.openstreetmap.org/?mlat=$la&mlon=$lo#map=18/$la/$lo';
}

/// Fecha legible en español (31 oct 2026, 10:30).
String? formatearFecha(DateTime? fecha) {
  if (fecha == null) return '';
  const meses = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic'
  ];
  final h = fecha.hour.toString().padLeft(2, '0');
  final m = fecha.minute.toString().padLeft(2, '0');
  return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}, $h:$m';
}

/// Fecha corta para las noticias.
String? fechaNoticia(String? pubDate) {
  final fecha = DateTime.tryParse(pubDate ?? '');
  if (fecha == null) return pubDate ?? '';
  const meses = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic'
  ];
  final h = fecha.hour.toString().padLeft(2, '0');
  final m = fecha.minute.toString().padLeft(2, '0');
  return '${fecha.day} ${meses[fecha.month - 1]} · $h:$m';
}

/// Iniciales para el avatar.
String? iniciales(String? nombre) {
  final partes =
      (nombre ?? '').trim().split(' ').where((p) => p.isNotEmpty).toList();
  if (partes.isEmpty) return 'CC';
  if (partes.length == 1) return partes.first[0].toUpperCase();
  return (partes[0][0] + partes[1][0]).toUpperCase();
}

/// Saludo con el primer nombre del usuario.
String? saludo(String? nombre) {
  final partes = (nombre ?? '').trim().split(' ');
  final primero =
      partes.isEmpty || partes.first.isEmpty ? 'vecino' : partes.first;
  return 'Hola, $primero';
}

/// Cuenta los reportes con un estado (o todos).
String? contarPorEstado(
  List<ReporteStruct>? reportes,
  String? estado,
) {
  final lista = reportes ?? [];
  if (estado == null || estado == 'Todos') return lista.length.toString();
  return lista.where((r) => r.estado == estado).length.toString();
}

/// Los reportes más recientes para el inicio.
List<ReporteStruct>? ultimosReportes(
  List<ReporteStruct>? reportes,
  int? cantidad,
) {
  final lista = reportes ?? [];
  return lista.take(cantidad ?? 3).toList();
}

/// Reportes filtrados por estado (Todos devuelve la lista completa).
List<ReporteStruct>? filtrarReportes(
  List<ReporteStruct>? reportes,
  String? estado,
) {
  final lista = reportes ?? [];
  if (estado == null || estado == 'Todos') return lista;
  return lista.where((r) => r.estado == estado).toList();
}

/// true si las coordenadas existen, están en rango y no son 0,0.
bool? coordenadasValidas(
  double? lat,
  double? lon,
) {
  if (lat == null || lon == null || lat.isNaN || lon.isNaN) return false;
  if (lat < -90 || lat > 90 || lon < -180 || lon > 180) return false;
  return !(lat == 0 && lon == 0);
}

/// Mensaje de error de la foto (vacía, más de 10 MB o no JPG/PNG); cadena
/// vacía si es válida.
String? validarFoto(FFUploadedFile? foto) {
  final bytes = foto?.bytes;
  if (bytes == null || bytes.isEmpty) {
    return 'Agrega una fotografía clara del problema.';
  }
  if (bytes.length > 10 * 1024 * 1024) {
    return 'La fotografía pesa más de 10 MB. Toma otra o elige una más ligera.';
  }
  final esJpeg = bytes.length > 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF;
  final esPng = bytes.length > 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47;
  if (!esJpeg && !esPng) {
    return 'La fotografía debe ser JPG o PNG.';
  }
  return '';
}

/// Folio local CC-AAAA-000001 hasta que el backend devuelva el suyo.
String? generarFolio(
  int? consecutivo,
  DateTime? fecha,
) {
  final anio = (fecha ?? DateTime.now()).year;
  final numero = (consecutivo ?? 1).toString().padLeft(6, '0');
  return 'CC-$anio-$numero';
}

/// Convierte la fecha ISO 8601 del backend a la hora local.
DateTime? fechaDesdeIso(String? texto) {
  return DateTime.tryParse(texto ?? '')?.toLocal() ?? DateTime.now();
}
