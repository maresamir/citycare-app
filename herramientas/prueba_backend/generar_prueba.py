# Arma bin/prueba_acciones.dart con: cabecera (structs simulados), el código
# de las acciones de ../acciones/*.dart.txt (sin sus imports) y los casos.
# Uso: python generar_prueba.py
import pathlib

aqui = pathlib.Path(__file__).parent
acciones = [
    'enviar_reporte', 'iniciar_sesion_api', 'obtener_perfil', 'cerrar_sesion_api',
    'listar_mis_reportes', 'obtener_detalle_reporte',
]
partes = [(aqui / 'cabecera.dart.txt').read_text(encoding='utf-8')]
for nombre in acciones:
    codigo = (aqui.parent / 'acciones' / f'{nombre}.dart.txt').read_text(encoding='utf-8')
    lineas = [l for l in codigo.splitlines() if not l.startswith('import ')]
    partes.append('\n'.join(lineas).strip() + '\n')
partes.append((aqui / 'pruebas_main.dart.txt').read_text(encoding='utf-8'))
(aqui / 'bin' / 'prueba_acciones.dart').write_text('\n'.join(partes), encoding='utf-8')
print('bin/prueba_acciones.dart generado')
