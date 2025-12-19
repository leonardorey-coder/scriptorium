import os
import pickle
import numpy as np
from typing import List, Dict, Any, Tuple
from sklearn.metrics.pairwise import cosine_similarity
import re

class EmbeddingsManager:
    """Clase para gestionar la generación y búsqueda de embeddings."""
    
    def __init__(self, api_client=None, model_embedding="text-embedding-ada-002", cache_file="embeddings_cache.pkl"):
        """
        Inicializar el gestor de embeddings.
        
        Args:
            api_client: Cliente de API para generar embeddings (opcional)
            model_embedding (str): Modelo de embeddings a utilizar
            cache_file (str): Archivo para guardar la caché de embeddings
        """
        self.api_client = api_client
        self.model_embedding = model_embedding
        self.cache_path = os.path.join(os.path.dirname(__file__), cache_file)
        self.embeddings_cache = self._cargar_cache()
    
    def _cargar_cache(self) -> Dict[str, np.ndarray]:
        """Cargar caché de embeddings si existe."""
        if os.path.exists(self.cache_path):
            try:
                with open(self.cache_path, 'rb') as f:
                    return pickle.load(f)
            except Exception as e:
                print(f"Error al cargar cache de embeddings: {e}")
        return {}
    
    def _guardar_cache(self):
        """Guardar caché de embeddings."""
        with open(self.cache_path, 'wb') as f:
            pickle.dump(self.embeddings_cache, f)
    
    def _generar_embedding_simple(self, texto: str) -> np.ndarray:
        """
        Generar embedding simple basado en palabras clave cuando no hay API disponible.
        
        Args:
            texto (str): Texto para generar el embedding
            
        Returns:
            np.ndarray: Vector de embedding simple
        """
        palabras = re.findall(r'\b\w+\b', texto.lower())
        vector = np.zeros(1536)
        for i, palabra in enumerate(palabras[:1536]):
            hash_val = hash(palabra) % 1000
            vector[i % 1536] += hash_val / 1000.0
        return vector / (np.linalg.norm(vector) + 1e-8)
    
    def generar_embedding(self, texto: str) -> np.ndarray:
        """
        Generar embedding para un texto.
        
        Args:
            texto (str): Texto para generar el embedding
            
        Returns:
            np.ndarray: Vector de embedding
        """
        if self.api_client is None:
            return self._generar_embedding_simple(texto)
        
        try:
            response = self.api_client.get_embeddings(
                input=[texto],
                model=self.model_embedding
            )
            return np.array(response.data[0].embedding)
        except Exception as e:
            print(f"Error al generar embedding: {e}")
            return self._generar_embedding_simple(texto)
    
    def procesar_documento(self, doc_id: str, texto: str) -> np.ndarray:
        """
        Procesar un documento y generar/recuperar su embedding.
        
        Args:
            doc_id (str): Identificador único del documento
            texto (str): Texto del documento
            
        Returns:
            np.ndarray: Vector de embedding del documento
        """
        if doc_id not in self.embeddings_cache:
            self.embeddings_cache[doc_id] = self.generar_embedding(texto)
            self._guardar_cache()
        
        return self.embeddings_cache[doc_id]
    
    def buscar_documentos_similares(
        self, 
        consulta: str, 
        documentos: List[Dict[str, Any]], 
        textos: List[str], 
        top_k: int = 3
    ) -> List[Tuple[Dict[str, Any], float]]:
        """
        Buscar documentos similares a una consulta.
        
        Args:
            consulta (str): Texto de consulta
            documentos (List[Dict]): Lista de documentos
            textos (List[str]): Lista de textos correspondientes a los documentos
            top_k (int): Número de documentos a devolver
            
        Returns:
            List[Tuple[Dict, float]]: Lista de (documento, score) ordenados por relevancia
        """
        # Generar embedding para la consulta
        consulta_embedding = self.generar_embedding(consulta)
        
        # Preparar embeddings de documentos
        doc_embeddings = []
        for idx, doc in enumerate(documentos):
            doc_id = doc.get('id', f"doc_{idx}")
            doc_embeddings.append(self.procesar_documento(doc_id, textos[idx]))
        
        # Convertir a matriz de numpy
        doc_embeddings_matrix = np.array(doc_embeddings)
        
        # Calcular similitud
        similitudes = cosine_similarity([consulta_embedding], doc_embeddings_matrix)[0]
        
        # Ordenar índices por similitud (de mayor a menor)
        indices_ordenados = np.argsort(similitudes)[::-1][:top_k]
        
        # Crear lista de resultados
        resultados = [(documentos[idx], float(similitudes[idx])) for idx in indices_ordenados]
        
        return resultados
