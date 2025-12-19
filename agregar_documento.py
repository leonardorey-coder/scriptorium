import os
import argparse
import re
from rag.documentos_manager import DocumentosManager

def parsear_documento_txt(contenido: str) -> dict:
    """
    Parsea un archivo de texto plano y extrae las secciones del documento.
    
    Args:
        contenido (str): Contenido del archivo .txt
        
    Returns:
        dict: Diccionario con la estructura del documento
    """
    doc_dict = {}
    
    patrones = {
        'titulo': r'T[ií]tulo:?\s*(.+?)(?:\n|$)',
        'tipo': r'Tipo:?\s*(.+?)(?:\n|$)',
        'materia': r'Materia:?\s*(.+?)(?:\n|$)',
        'presenta': r'Presenta:?\s*(.+?)(?:\n|$)',
        'profesor': r'Profesor:?\s*(.+?)(?:\n|$)',
        'introduccion': r'Introducci[oó]n:?\s*([\s\S]+?)(?=Desarrollo:|Conclusi[oó]n:|$)',
        'desarrollo': r'Desarrollo:?\s*([\s\S]+?)(?=Conclusi[oó]n:|$)',
        'conclusion': r'Conclusi[oó]n:?\s*([\s\S]+?)(?=\n\n[A-Z]|$)'
    }
    
    for campo, patron in patrones.items():
        match = re.search(patron, contenido, re.IGNORECASE | re.MULTILINE)
        if match:
            doc_dict[campo] = match.group(1).strip()
        else:
            doc_dict[campo] = ""
    
    return doc_dict

def main():
    parser = argparse.ArgumentParser(description='Agregar un documento desde un archivo .txt al sistema RAG')
    parser.add_argument('archivo', type=str, help='Archivo .txt con el documento a agregar')
    parser.add_argument('--nombre', type=str, default=None,
                        help='Nombre personalizado para el archivo JSON (sin extensión)')
    parser.add_argument('--sobrescribir', action='store_true',
                        help='Sobrescribir el archivo si ya existe')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.archivo):
        print(f"Error: El archivo {args.archivo} no existe")
        return
    
    if not args.archivo.endswith('.txt'):
        print(f"Advertencia: El archivo {args.archivo} no tiene extensión .txt")
    
    try:
        with open(args.archivo, 'r', encoding='utf-8') as f:
            contenido = f.read()
    except Exception as e:
        print(f"Error al leer el archivo: {e}")
        return
    
    if not contenido.strip():
        print("Error: El archivo está vacío")
        return
    
    print(f"Parseando documento desde: {args.archivo}")
    doc_dict = parsear_documento_txt(contenido)
    
    if not doc_dict.get('titulo'):
        print("Advertencia: No se encontró un título en el documento")
        respuesta = input("¿Deseas continuar de todas formas? (s/n): ")
        if respuesta.lower() != 's':
            return
    
    print("\nDocumento parseado:")
    print(f"  Título: {doc_dict.get('titulo', '(sin título)')}")
    print(f"  Tipo: {doc_dict.get('tipo', '(sin tipo)')}")
    print(f"  Materia: {doc_dict.get('materia', '(sin materia)')}")
    print(f"  Presenta: {doc_dict.get('presenta', '(sin autor)')}")
    print(f"  Profesor: {doc_dict.get('profesor', '(sin profesor)')}")
    print(f"  Introducción: {'✓' if doc_dict.get('introduccion') else '✗'}")
    print(f"  Desarrollo: {'✓' if doc_dict.get('desarrollo') else '✗'}")
    print(f"  Conclusión: {'✓' if doc_dict.get('conclusion') else '✗'}")
    
    respuesta = input("\n¿Deseas guardar este documento? (s/n): ")
    if respuesta.lower() != 's':
        print("Operación cancelada")
        return
    
    manager = DocumentosManager()
    
    if args.nombre:
        nombre_archivo = f"{args.nombre}.json"
    else:
        nombre_archivo = None
    
    ruta_archivo = os.path.join(manager.directorio_base, nombre_archivo) if nombre_archivo else None
    
    if ruta_archivo and os.path.exists(ruta_archivo) and not args.sobrescribir:
        print(f"Error: El archivo {nombre_archivo} ya existe. Usa --sobrescribir para reemplazarlo")
        return
    
    try:
        archivo_guardado = manager.guardar_documento(doc_dict, nombre_archivo)
        print(f"\n✅ Documento guardado exitosamente en: {archivo_guardado}")
        print(f"El documento ahora está disponible para el sistema RAG")
    except Exception as e:
        print(f"Error al guardar el documento: {e}")

if __name__ == "__main__":
    main()

