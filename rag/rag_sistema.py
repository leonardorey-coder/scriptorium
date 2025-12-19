import os
from typing import List, Dict, Any, Tuple
import requests

from .documentos_manager import DocumentosManager
from .embeddings_manager import EmbeddingsManager

class RAGSistema:
    """Sistema de Retrieval-Augmented Generation para generar documentos personalizados."""
    
    def __init__(self, token: str, endpoint: str = "https://models.github.ai/inference"):
        """
        Inicializar el sistema RAG.
        
        Args:
            token (str): Token de autenticación para GitHub AI
            endpoint (str): Endpoint de GitHub AI
        """
        self.token = token
        self.endpoint = endpoint
        self.model_name = "openai/gpt-4.1"
        
        self.doc_manager = DocumentosManager()
        self.embeddings_manager = EmbeddingsManager(api_client=None)
    
    def _construir_prompt_con_contexto(
        self, 
        consulta: str, 
        docs_similares: List[Tuple[Dict[str, Any], float]],
        tipo_documento: str = None,
        contexto_adicional: str = None,
        num_ejemplos: int = 3
    ) -> str:
        """
        Construir prompt con contexto para enviar al modelo.
        
        Args:
            consulta (str): Consulta del usuario
            docs_similares (List[Tuple[Dict, float]]): Documentos similares con score
            tipo_documento (str, optional): Tipo de documento a generar
            contexto_adicional (str, optional): Texto plano adicional como contexto
            num_ejemplos (int): Número máximo de ejemplos a incluir
            
        Returns:
            str: Prompt completo con contexto
        """
        # Limitar el número de ejemplos
        docs_similares = docs_similares[:min(num_ejemplos, len(docs_similares))]
        
        # Construir prompt
        ejemplos_texto = []
        for doc, score in docs_similares:
            ejemplo = self.doc_manager.get_documento_completo(doc)
            ejemplos_texto.append(f"EJEMPLO (relevancia: {score:.2f}):\n{ejemplo}\n")
        
        contexto = "\n".join(ejemplos_texto)
        
        # Agregar contexto adicional si se proporcionó
        seccion_contexto = ""
        if contexto_adicional:
            seccion_contexto = f"\n\nCONTEXTO ADICIONAL:\n{contexto_adicional}\n"
        
        # Agregar instrucción específica sobre el tipo de documento si se especificó
        tipo_instruccion = ""
        if tipo_documento:
            tipo_instruccion = f"\nEl documento debe ser específicamente del tipo: {tipo_documento}."
        
        prompt_template = (
            "Quiero que entiendas mi estilo de escritura a partir de los siguientes ejemplos "
            "y generes un nuevo documento con estructura similar. Estos ejemplos son documentos que yo he escrito.\n\n"
            "EJEMPLOS DE MI ESTILO:\n"
            f"{contexto}{seccion_contexto}\n"
            "Ahora quiero que escribas un nuevo documento siguiendo exactamente mi estilo y estructura, incluyendo "
            "las mismas secciones (título, tipo, materia, presenta, profesor, introducción, desarrollo y conclusión). "
            f"El tema es: {consulta}{tipo_instruccion}\n\n"
            "Tu respuesta debe mantener la estructura vista en los ejemplos, con secciones claramente delimitadas y escrita con mi mismo estilo."
        )
        
        return prompt_template
    
    def _llamar_modelo(self, messages: List[Dict[str, str]], temperature: float = 0.7, max_tokens: int = 32768,
                        top_p: float = 1.0, frequency_penalty: float = 0.0, presence_penalty: float = 0.0) -> str:
        """
        Llamar al modelo de GitHub AI.
        
        Args:
            messages (List[Dict]): Lista de mensajes en formato OpenAI
            temperature (float): Temperatura para la generación
            max_tokens (int): Máximo de tokens de salida (hasta 32768)
            top_p (float): Nucleus sampling (0.0-1.0)
            frequency_penalty (float): Penalización de frecuencia (-2.0 a 2.0)
            presence_penalty (float): Penalización de presencia (-2.0 a 2.0)
            
        Returns:
            str: Respuesta del modelo
        """
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.token}"
        }
        
        data = {
            "model": self.model_name,
            "messages": messages,
            "temperature": temperature,
            "max_tokens": min(max_tokens, 32768),
            "top_p": top_p,
            "frequency_penalty": frequency_penalty,
            "presence_penalty": presence_penalty
        }
        
        endpoint_url = f"{self.endpoint}/v1/chat/completions"
        
        try:
            response = requests.post(endpoint_url, json=data, headers=headers, timeout=120)
            
            if response.status_code == 200:
                result = response.json()
                if "choices" in result and len(result["choices"]) > 0:
                    return result["choices"][0]["message"]["content"]
                else:
                    raise Exception(f"Respuesta inesperada del API: {result}")
            elif response.status_code == 401:
                raise Exception(f"Error de autenticación (401). Verifica que el token GITHUB_TOKEN sea válido.\n"
                              f"Endpoint: {endpoint_url}\n"
                              f"Respuesta: {response.text[:200]}")
            elif response.status_code == 403:
                raise Exception(f"Acceso denegado (403). Verifica los permisos del token.\n"
                              f"Endpoint: {endpoint_url}\n"
                              f"Respuesta: {response.text[:200]}")
            elif response.status_code == 404:
                raise Exception(f"Endpoint no encontrado (404). Verifica que el endpoint sea correcto.\n"
                              f"Endpoint usado: {endpoint_url}\n"
                              f"Endpoint base: {self.endpoint}\n"
                              f"Respuesta: {response.text[:200]}")
            else:
                response.raise_for_status()
        except requests.exceptions.Timeout:
            raise Exception(f"Timeout al conectar con el endpoint. El servidor tardó demasiado en responder.\n"
                          f"Endpoint: {endpoint_url}\n"
                          f"Intenta nuevamente o verifica tu conexión a internet.")
        except requests.exceptions.HTTPError as e:
            error_msg = f"Error HTTP {e.response.status_code}"
            raise Exception(f"{error_msg} para {endpoint_url}:\n{e.response.text[:500]}")
        except requests.exceptions.RequestException as e:
            raise Exception(f"Error de conexión: {str(e)}\n"
                          f"Endpoint: {endpoint_url}\n"
                          f"Verifica tu conexión a internet y que el servicio esté disponible.")
        except Exception as e:
            raise Exception(f"Error inesperado: {str(e)}\n"
                          f"Endpoint: {endpoint_url}")
    
    def generar_documento(self, tema: str, parametros_adicionales: Dict = None) -> str:
        """
        Generar un documento nuevo basado en ejemplos similares.
        
        Args:
            tema (str): Tema para el nuevo documento
            parametros_adicionales (Dict, optional): Parámetros adicionales para la generación
                - tipo: Tipo de documento
                - contexto_adicional: Contexto adicional como texto
                - prompt_personalizado: Prompt personalizado (si se proporciona, se usa en lugar del automático)
                - temperatura: Temperatura para la generación
                - max_tokens: Máximo de tokens
            
        Returns:
            str: Documento generado
        """
        if parametros_adicionales is None:
            parametros_adicionales = {}
        
        # Cargar documentos
        documentos = self.doc_manager.cargar_documentos()
        
        if not documentos:
            return "No hay documentos de ejemplo disponibles. Por favor, agrega algunos documentos primero."
        
        # Obtener prompt personalizado si se proporcionó
        prompt_personalizado = parametros_adicionales.get('prompt_personalizado')
        
        if prompt_personalizado:
            # Si hay prompt personalizado, construir prompt con ejemplos pero usando el prompt personalizado
            textos = [self.doc_manager.get_documento_completo(doc) for doc in documentos]
            docs_similares = self.embeddings_manager.buscar_documentos_similares(
                tema, documentos, textos, top_k=3
            )
            
            ejemplos_texto = []
            for doc, score in docs_similares[:3]:
                ejemplo = self.doc_manager.get_documento_completo(doc)
                ejemplos_texto.append(f"EJEMPLO DE MI ESTILO (relevancia: {score:.2f}):\n{ejemplo}\n")
            
            contexto = "\n".join(ejemplos_texto)
            contexto_adicional = parametros_adicionales.get('contexto_adicional', '')
            
            seccion_contexto = ""
            if contexto_adicional:
                seccion_contexto = f"\n\nCONTEXTO ADICIONAL:\n{contexto_adicional}\n"
            
            prompt = (
                "Quiero que entiendas mi estilo de escritura a partir de los siguientes ejemplos "
                "y sigas las instrucciones del prompt personalizado que te proporciono.\n\n"
                "EJEMPLOS DE MI ESTILO:\n"
                f"{contexto}{seccion_contexto}\n"
                "PROMPT PERSONALIZADO:\n"
                f"{prompt_personalizado}\n\n"
                "Genera el documento siguiendo exactamente mi estilo de escritura y estructura, "
                "pero cumpliendo con las instrucciones del prompt personalizado."
            )
        else:
            # Usar el método normal de generación
            textos = [self.doc_manager.get_documento_completo(doc) for doc in documentos]
            docs_similares = self.embeddings_manager.buscar_documentos_similares(
                tema, documentos, textos, top_k=3
            )
            
            tipo_documento = parametros_adicionales.get('tipo')
            contexto_adicional = parametros_adicionales.get('contexto_adicional')
            
            prompt = self._construir_prompt_con_contexto(tema, docs_similares, tipo_documento, contexto_adicional)
        
        # Configuración de parámetros para el modelo
        temperatura = parametros_adicionales.get('temperatura', 0.7)
        max_tokens = parametros_adicionales.get('max_tokens', 32768)
        top_p = parametros_adicionales.get('top_p', 1.0)
        frequency_penalty = parametros_adicionales.get('frequency_penalty', 0.0)
        presence_penalty = parametros_adicionales.get('presence_penalty', 0.0)
        
        # Llamar al modelo
        response = self._llamar_modelo(
            messages=[
                {"role": "system", "content": "Eres un asistente que imita perfectamente el estilo de escritura del usuario."},
                {"role": "user", "content": prompt}
            ],
            temperature=temperatura,
            max_tokens=max_tokens,
            top_p=top_p,
            frequency_penalty=frequency_penalty,
            presence_penalty=presence_penalty
        )
        
        return response

    def transformar_texto(self, texto_original: str, parametros_adicionales: Dict = None) -> str:
        """
        Transformar un texto existente para que se ajuste al estilo del usuario.
        
        Args:
            texto_original (str): Texto que se desea transformar
            parametros_adicionales (Dict, optional): Parámetros adicionales para la transformación
            
        Returns:
            str: Texto transformado en el estilo del usuario
        """
        if parametros_adicionales is None:
            parametros_adicionales = {}
        
        # Cargar documentos
        documentos = self.doc_manager.cargar_documentos()
        
        if not documentos:
            return "No hay documentos de ejemplo disponibles. Por favor, agrega algunos documentos primero."
        
        # Convertir documentos a texto para búsqueda
        textos = [self.doc_manager.get_documento_completo(doc) for doc in documentos]
        
        # Buscar documentos similares basados en el texto original
        # Usamos un extracto del texto original si es muy largo para la búsqueda de similitud
        texto_para_busqueda = texto_original[:3000] if len(texto_original) > 3000 else texto_original
        docs_similares = self.embeddings_manager.buscar_documentos_similares(
            texto_para_busqueda, documentos, textos, top_k=3
        )
        
        # Crear prompt para transformar el texto
        ejemplos_texto = []
        for doc, score in docs_similares:
            ejemplo = self.doc_manager.get_documento_completo(doc)
            ejemplos_texto.append(f"EJEMPLO DE MI ESTILO (relevancia: {score:.2f}):\n{ejemplo}\n")
        
        contexto = "\n".join(ejemplos_texto)
        
        # Obtener contexto adicional si se proporcionó
        contexto_adicional = parametros_adicionales.get('contexto_adicional')
        seccion_contexto = ""
        if contexto_adicional:
            seccion_contexto = f"\n\nCONTEXTO ADICIONAL:\n{contexto_adicional}\n"
        
        # Determinar si estamos procesando texto combinado
        es_texto_combinado = "--- Contenido del segundo archivo ---" in texto_original
        instruccion_adicional = ""
        if es_texto_combinado:
            instruccion_adicional = (
                "El texto contiene contenido de dos archivos diferentes que han sido combinados. "
                "Por favor, integra ambos textos de manera coherente en un único documento "
                "que mantenga mi estilo de escritura y estructura."
            )
        
        prompt = (
            "Quiero que reformules el siguiente texto para que se adapte a mi estilo de escritura, "
            "basándote en los ejemplos proporcionados. Mantén la estructura de secciones como título, "
            "tipo, materia, etc. según los ejemplos, pero adapta el contenido del texto original. "
            "Los ejemplos muestran mi forma de escribir y estructurar documentos.\n\n"
            f"EJEMPLOS DE MI ESTILO:\n{contexto}{seccion_contexto}\n"
            f"TEXTO A TRANSFORMAR:\n{texto_original}\n\n"
            f"{instruccion_adicional}\n\n"
            "Reformula este texto para que parezca escrito por mí, manteniendo el mismo contenido y mensaje, "
            "pero con mi estilo de redacción y estructura de documento."
        )
        
        # Configuración de parámetros para el modelo
        temperatura = parametros_adicionales.get('temperatura', 0.7)
        max_tokens = parametros_adicionales.get('max_tokens', 32768)
        
        # Llamar al modelo
        response = self._llamar_modelo(
            messages=[
                {"role": "system", "content": "Eres un experto en adaptar textos al estilo de escritura de otros autores."},
                {"role": "user", "content": prompt}
            ],
            temperature=temperatura,
            max_tokens=max_tokens
        )
        
        return response

# Ejemplo de uso
if __name__ == "__main__":
    token = os.environ["GITHUB_TOKEN"]
    rag = RAGSistema(token=token)
    
    # Generar un documento nuevo sobre un tema
    tema = "Implementación de patrones de diseño en Java"
    documento_generado = rag.generar_documento(tema)
    print(documento_generado)

