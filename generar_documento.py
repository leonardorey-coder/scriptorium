import os
import argparse
from rag.rag_sistema import RAGSistema

def main():
    parser = argparse.ArgumentParser(description='Generar documentos con mi estilo de escritura')
    parser.add_argument('tema', type=str, help='Tema del documento a generar')
    parser.add_argument('--tipo', type=str, default=None, 
                        help='Tipo de documento (practica, investigacion, ensayo, etc.)')
    parser.add_argument('--contexto', type=str, default=None,
                        help='Archivo de texto plano con contexto adicional para el RAG')
    parser.add_argument('--contexto-texto', type=str, default=None,
                        help='Texto plano directo como contexto adicional para el RAG')
    parser.add_argument('--prompt', type=str, default=None,
                        help='Archivo de texto con un prompt personalizado para la generación')
    parser.add_argument('--prompt-texto', type=str, default=None,
                        help='Prompt personalizado directo como texto para la generación')
    parser.add_argument('--endpoint', type=str, default=None,
                        help='Endpoint personalizado para la API (por defecto: https://models.github.ai/inference)')
    parser.add_argument('--temperatura', type=float, default=0.7, help='Temperatura para la generación (0.0-1.0)')
    parser.add_argument('--max-tokens', type=int, default=32768, help='Longitud máxima del documento (máximo 32768)')
    parser.add_argument('--top-p', type=float, default=1.0, help='Nucleus sampling (0.0-1.0)')
    parser.add_argument('--frequency-penalty', type=float, default=0.0, help='Penalización de frecuencia (-2.0 a 2.0)')
    parser.add_argument('--presence-penalty', type=float, default=0.0, help='Penalización de presencia (-2.0 a 2.0)')
    parser.add_argument('--guardar', action='store_true', help='Guardar el documento generado')
    
    args = parser.parse_args()
    
    # Obtener token desde variable de entorno
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        print("Error: La variable de entorno GITHUB_TOKEN no está configurada")
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
    
    # Cargar prompt personalizado si se proporcionó
    prompt_personalizado = None
    if args.prompt_texto:
        prompt_personalizado = args.prompt_texto
    elif args.prompt:
        try:
            with open(args.prompt, 'r', encoding='utf-8') as f:
                prompt_personalizado = f.read()
            print(f"Prompt personalizado cargado desde: {args.prompt}")
        except Exception as e:
            print(f"Error al leer el archivo de prompt: {e}")
            return
    
    # Inicializar sistema RAG
    endpoint = args.endpoint if args.endpoint else None
    rag = RAGSistema(token=token, endpoint=endpoint) if endpoint else RAGSistema(token=token)
    
    # Generar documento
    print(f"Generando documento sobre: {args.tema}")
    if args.tipo:
        print(f"Tipo de documento: {args.tipo}")
    if contexto_adicional:
        print("Usando contexto adicional proporcionado")
    if prompt_personalizado:
        print("Usando prompt personalizado")
    print("Esto puede tomar un momento...\n")
    
    parametros = {
        'temperatura': args.temperatura,
        'max_tokens': args.max_tokens,
        'top_p': args.top_p,
        'frequency_penalty': args.frequency_penalty,
        'presence_penalty': args.presence_penalty,
        'tipo': args.tipo,
        'contexto_adicional': contexto_adicional,
        'prompt_personalizado': prompt_personalizado
    }
    
    documento_generado = rag.generar_documento(args.tema, parametros)
    
    # Mostrar documento generado
    print("\n=============== DOCUMENTO GENERADO ===============\n")
    print(documento_generado)
    print("\n=================================================\n")
    
    # Guardar documento si se solicitó
    if args.guardar:
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
        
        for campo, patron in patrones.items():
            match = re.search(patron, documento_generado, re.IGNORECASE)
            if match:
                doc_dict[campo] = match.group(1).strip()
            else:
                doc_dict[campo] = ""
        
        # Si no se pudo extraer el título, usar el tema
        if not doc_dict['titulo']:
            doc_dict['titulo'] = args.tema
            
        # Si se especificó un tipo y no se pudo extraer del texto, usarlo
        if args.tipo and not doc_dict['tipo']:
            doc_dict['tipo'] = args.tipo
        
        # Guardar documento
        manager = DocumentosManager()
        archivo = manager.guardar_documento(doc_dict)
        print(f"Documento guardado en: {archivo}")

if __name__ == "__main__":
    main()
