import os
import json
from typing import List, Dict, Any

class DocumentosManager:
    """Clase para gestionar los documentos JSON del usuario."""
    
    def __init__(self, directorio_docs: str = "documentos"):
        """
        Inicializar el gestor de documentos.
        
        Args:
            directorio_docs (str): Directorio donde se almacenan los documentos JSON
        """
        # Directorio principal de documentos
        self.directorio_base = os.path.join(os.path.dirname(os.path.dirname(__file__)), directorio_docs)
        os.makedirs(self.directorio_base, exist_ok=True)
        
        # Directorio adicional dentro de rag para buscar documentos
        self.directorio_rag = os.path.dirname(__file__)
    
    def cargar_documentos(self) -> List[Dict[str, Any]]:
        """
        Cargar todos los documentos JSON del directorio.
        
        Returns:
            List[Dict[str, Any]]: Lista de documentos como diccionarios
        """
        documentos = []
        
        # Buscar en el directorio principal de documentos
        self._cargar_desde_directorio(self.directorio_base, documentos)
        
        # También buscar en el directorio rag
        self._cargar_desde_directorio(self.directorio_rag, documentos)
        
        return documentos
    
    def _cargar_desde_directorio(self, directorio: str, documentos: List[Dict[str, Any]]):
        """Carga documentos JSON desde un directorio específico."""
        if not os.path.exists(directorio):
            return
            
        for archivo in os.listdir(directorio):
            if archivo.endswith('.json'):
                ruta_completa = os.path.join(directorio, archivo)
                try:
                    with open(ruta_completa, 'r', encoding='utf-8') as f:
                        doc = json.load(f)
                        doc['id'] = archivo  # Agregar el nombre del archivo como ID
                        documentos.append(doc)
                        print(f"✅ Documento cargado: {archivo}")
                except Exception as e:
                    print(f"❌ Error al cargar {archivo}: {e}")
    
    def guardar_documento(self, documento: Dict[str, Any], nombre_archivo: str = None) -> str:
        """
        Guardar un documento en formato JSON.
        
        Args:
            documento (Dict[str, Any]): El documento a guardar
            nombre_archivo (str, optional): Nombre de archivo. Si es None, se usa el título del documento.
            
        Returns:
            str: Ruta del archivo guardado
        """
        if nombre_archivo is None:
            # Generar nombre de archivo basado en el título
            nombre_archivo = documento.get('titulo', 'documento_sin_titulo')
            nombre_archivo = nombre_archivo.lower().replace(' ', '_')[:50]
            nombre_archivo += '.json'
            
        ruta_completa = os.path.join(self.directorio_base, nombre_archivo)
        
        with open(ruta_completa, 'w', encoding='utf-8') as f:
            json.dump(documento, f, ensure_ascii=False, indent=2)
            
        return ruta_completa
    
    def get_documento_completo(self, doc: Dict[str, Any]) -> str:
        """
        Convierte un documento JSON en texto completo para procesamiento.
        
        Args:
            doc (Dict[str, Any]): El documento como diccionario
            
        Returns:
            str: Texto completo del documento
        """
        partes = [
            f"Título: {doc.get('titulo', '')}",
            f"Tipo: {doc.get('tipo', '')}",
            f"Materia: {doc.get('materia', '')}",
            f"Presenta: {doc.get('presenta', '')}",
            f"Profesor: {doc.get('profesor', '')}",
            f"Introducción: {doc.get('introduccion', '')}",
            f"Desarrollo: {doc.get('desarrollo', '')}",
            f"Conclusión: {doc.get('conclusion', '')}"
        ]
        return "\n\n".join(partes)

# Ejemplo de uso
if __name__ == "__main__":
    manager = DocumentosManager()
    
    # Documento de ejemplo
    doc_ejemplo = {
        "titulo": "Uso práctico de JMenuBar, JMenu, JMenuItem y JToolBar con imágenes",
        "tipo": "practica",
        "materia": "programacion visual",
        "presenta": "juan apellido apellido",
        "profesor": "aldo apellido apellido",
        "introduccion": "En esta práctica veremos la aplicación de crear una interfaz gráfica en Java utilizando los componentes JMenuBar, JMenu, JMenuItem y JToolBar. Implementaremos...",
        "desarrollo": "Como primer paso, se tiene que desarrollar la clase principal. Esta clase contendrá el método",
        "conclusion": "conclusion..."
    }
    
    # Guardar documento de ejemplo
    manager.guardar_documento(doc_ejemplo)
    
    # Cargar documentos
    docs = manager.cargar_documentos()
    print(f"Documentos cargados: {len(docs)}")
