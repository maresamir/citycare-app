// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class FotoReporte extends StatelessWidget {
  const FotoReporte({
    super.key,
    this.width,
    this.height,
    required this.url,
  });

  final double? width;
  final double? height;
  final String url;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        url,
        width: width ?? double.infinity,
        height: height ?? 220,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progreso) => progreso == null
            ? child
            : Container(
                width: width ?? double.infinity,
                height: height ?? 220,
                color: tema.alternate,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
        errorBuilder: (context, error, stack) => Container(
          width: width ?? double.infinity,
          height: height ?? 220,
          color: tema.alternate,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_not_supported_outlined,
                  size: 36, color: tema.secondaryText),
              const SizedBox(height: 8),
              Text(
                'No pudimos cargar la foto. Regresa y abre el reporte de nuevo.',
                textAlign: TextAlign.center,
                style: tema.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
