import os
import argparse
from rag.rag_sistema import RAGSistema

def main():
    parser = argparse.ArgumentParser(description='Transformar un texto al estilo de escritura personal')
    parser.add_argument('--archivo', type=str, help='Archivo que contiene el texto a transformar')
    parser.add_argument('--archivo2', type=str, help='Segundo archivo de texto para combinar con el primero')
    parser.add_argument('--texto', type=str, help='Texto a transformar (alternativa a --archivo)')
    parser.add_argument('--contexto', type=str, default=None,
                        help='Archivo de texto plano con contexto adicional para el RAG')
    parser.add_argument('--contexto-texto', type=str, default=None,
                        help='Texto plano directo como contexto adicional para el RAG')
    parser.add_argument('--temperatura', type=float, default=0.7, help='Temperatura para la generación (0.0-1.0)')
    parser.add_argument('--max-tokens', type=int, default=32768, help='Longitud máxima del documento (máximo 32768)')
    parser.add_argument('--guardar', action='store_true', help='Guardar el documento generado')
    parser.add_argument('--salida', type=str, help='Archivo de salida donde guardar el resultado')
    
    args = parser.parse_args()
    
    # Validar que se haya proporcionado texto o archivo
    if not args.archivo and not args.texto and not args.archivo2:
        print("Error: Debes proporcionar al menos un archivo (--archivo, --archivo2) o un texto (--texto)")
        return
    
    # Obtener el texto a transformar
    texto_original = ""
    
    # Función auxiliar para leer archivos
    def leer_archivo(ruta):
        try:
            with open(ruta, 'r', encoding='utf-8') as f:
                contenido = f.read()
                print(f"Texto cargado desde: {ruta}")
                return contenido
        except Exception as e:
            print(f"Error al leer el archivo {ruta}: {e}")
            return ""
    
    # Procesar el primer archivo si se especifica
    if args.archivo:
        texto_original = leer_archivo(args.archivo)
        if not texto_original:
            return
    
    # Procesar el segundo archivo si se especifica
    if args.archivo2:
        texto_segundo = leer_archivo(args.archivo2)
        if not texto_segundo:
            return
            
        # Si tenemos dos archivos, los combinamos
        if texto_original:
            print("Combinando ambos archivos para su transformación...")
            texto_original = texto_original + "\n\n--- Contenido del segundo archivo ---\n\n" + texto_segundo
        else:
            texto_original = texto_segundo
    
    # Si no hay archivos pero hay texto directo, usarlo
    if not texto_original and args.texto:
        texto_original = args.texto
    
    # Verificar que tenemos texto para procesar
    if not texto_original:
        print("Error: No se ha podido obtener texto para transformar")
        return
    
    # Cargar contexto adicional si se proporcionó
    contexto_adicional = None
    if args.contexto_texto:
        contexto_adicional = args.contexto_texto
    elif args.contexto:
        try:
            with open(args.contexto, 'r', encoding='utf-8') as f:
                contexto_adicional = f.read()
            print(f"Contexto adicional cargado desde: {args.contexto}")
        except Exception as e:
            print(f"Error al leer el archivo de contexto: {e}")
            return
    
    # Obtener token desde variable de entorno
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        print("Error: La variable de entorno GITHUB_TOKEN no está configurada")
        return
    
    # Inicializar sistema RAG
    rag = RAGSistema(token=token)
    
    # Transformar texto
    print("Transformando texto a tu estilo de escritura...")
    if args.archivo and args.archivo2:
        print(f"Combinando y transformando textos de: {args.archivo} y {args.archivo2}")
    elif args.archivo:
        print(f"Transformando texto de: {args.archivo}")
    elif args.archivo2:
        print(f"Transformando texto de: {args.archivo2}")
    else:
        print("Transformando texto proporcionado directamente")
    if contexto_adicional:
        print("Usando contexto adicional proporcionado")
    print("Esto puede tomar un momento...\n")
    
    parametros = {
        'temperatura': args.temperatura,
        'max_tokens': args.max_tokens,
        'contexto_adicional': contexto_adicional
    }
    
    texto_transformado = rag.transformar_texto(texto_original, parametros)
    
    # Mostrar texto transformado
    print("\n=============== TEXTO TRANSFORMADO ===============\n")
    print(texto_transformado)
    print("\n=================================================\n")
    
    # Guardar resultado si se solicitó
    if args.guardar or args.salida:
        archivo_salida = args.salida if args.salida else "texto_transformado.txt"
        try:
            with open(archivo_salida, 'w', encoding='utf-8') as f:
                f.write(texto_transformado)
            print(f"Texto transformado guardado en: {archivo_salida}")
            
            # Intentar guardar como documento estructurado JSON si tiene el formato adecuado
            from rag.documentos_manager import DocumentosManager
            import json
            import re
            
            # Intentar parsear el documento generado
            doc_dict = {}
            
            # Patrones para extraer secciones
            patrones = {
                'titulo': r'T[ií]tulo:?\s*(.+?)(?:\n|$)',
                'tipo': r'Tipo:?\s*(.+?)(?:\n|$)',
                'materia': r'Materia:?\s*(.+?)(?:\n|$)',
                'presenta': r'Presenta:?\s*(.+?)(?:\n|$)',
                'profesor': r'Profesor:?\s*(.+?)(?:\n|$)',
                'introduccion': r'Introducci[oó]n:?\s*([\s\S]+?)(?=Desarrollo:|Conclusi[oó]n:|$)',
                'desarrollo': r'Desarrollo:?\s*([\s\S]+?)(?=Conclusi[oó]n:|$)',
                'conclusion': r'Conclusi[oó]n:?\s*([\s\S]+)$'
            }
            
            tiene_estructura = True
            for campo, patron in patrones.items():
                match = re.search(patron, texto_transformado, re.IGNORECASE)
                if match:
                    doc_dict[campo] = match.group(1).strip()
                else:
                    doc_dict[campo] = ""
                    if campo in ['titulo', 'tipo', 'materia']:
                        tiene_estructura = False
            
            if tiene_estructura:
                # Guardar documento estructurado
                manager = DocumentosManager()
                archivo_json = manager.guardar_documento(doc_dict)
                print(f"También se ha guardado como documento estructurado en: {archivo_json}")
            
        except Exception as e:
            print(f"Error al guardar el resultado: {e}")

if __name__ == "__main__":
    main()
