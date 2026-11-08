# Copia el código de las acciones (*.dart.txt) a dsl/codigo_acciones.dart para
# que dsl/edit.dart lo suba a FlutterFlow sin duplicarlo a mano.
# Uso: python generar_codigo_dsl.py
import pathlib
import re

aqui = pathlib.Path(__file__).parent
destino = aqui.parent.parent / 'flutterflow' / 'dsl' / 'codigo_acciones.dart'

fuentes = {}
for nombre in ['enviar_reporte', 'listar_mis_reportes', 'obtener_detalle_reporte', 'obtener_ubicacion_gps']:
    fuentes[nombre] = (aqui / f'{nombre}.dart.txt').read_text(encoding='utf-8')
# token_seguro.dart.txt trae varias acciones separadas por "// ===== nombre".
texto = (aqui / 'token_seguro.dart.txt').read_text(encoding='utf-8')
for bloque in re.split(r'^// ===== ', texto, flags=re.M)[1:]:
    nombre, _, codigo = bloque.partition('\n')
    fuentes[nombre.strip()] = codigo


def camello(nombre):
    partes = re.split(r'_', nombre)
    return partes[0] + ''.join(p[:1].upper() + p[1:] for p in partes[1:])


salida = [
    '// Generado por .ffai_staging/acciones/generar_codigo_dsl.py: no editar a mano.',
    '// Código de las acciones personalizadas que sube dsl/edit.dart.',
    '',
]
for nombre, codigo in fuentes.items():
    assert "'''" not in codigo, nombre
    variable = 'codigo' + camello(nombre)[:1].upper() + camello(nombre)[1:]
    salida.append(f"final {variable} = r'''\n{codigo.strip()}\n''';\n")
destino.write_text('\n'.join(salida), encoding='utf-8')
print(f'{destino} generado: {", ".join(fuentes)}')
