# Seguridad

## Reportar una Vulnerabilidad

Si descubres una vulnerabilidad de seguridad en Scriptorium, por favor repórtala de manera responsable.

### Cómo Reportar

1. **NO** abras un issue público para vulnerabilidades de seguridad
2. Envía un email a: [leonardo.cfjl@gmail.com]
3. Incluye:
   - Descripción detallada de la vulnerabilidad
   - Pasos para reproducirla
   - Impacto potencial
   - Posibles soluciones (si las tienes)

### Qué Esperar

- Confirmación de recepción en 48 horas
- Evaluación inicial en 7 días
- Actualizaciones regulares sobre el progreso
- Reconocimiento en el CHANGELOG (si lo deseas)

### Alcance

#### En Alcance
- Código del sistema RAG (Python)
- Aplicación GUI (Swift/macOS)
- Manejo de credenciales y tokens
- Almacenamiento local de datos

#### Fuera de Alcance
- Vulnerabilidades en dependencias de terceros (reportar upstream)
- APIs externas (GitHub AI, OpenRouter)
- Ataques de ingeniería social
- Ataques físicos

## Mejores Prácticas de Seguridad

### Para Usuarios

1. **No compartas tu `GITHUB_TOKEN`**
   ```bash
   # MAL: Token en el código o commits
   token = "ghp_xxxxx"
   
   # BIEN: Variable de entorno
   export GITHUB_TOKEN="ghp_xxxxx"
   ```

2. **Usa el Keychain de macOS** (GUI)
   - La app almacena tokens en el Keychain del sistema
   - Los tokens nunca se guardan en texto plano

3. **Revisa permisos de archivos**
   ```bash
   # Los archivos de configuración deben ser privados
   chmod 600 ~/.config/scriptorium/config.json
   ```

### Para Contribuyentes

1. **Nunca commits credenciales**
   ```bash
   # Usa .gitignore
   .env
   secrets.json
   *.pem
   ```

2. **Sanitiza inputs**
   ```python
   # Validar entradas de usuario
   def procesar_input(texto: str) -> str:
       if not isinstance(texto, str):
           raise TypeError("Se esperaba string")
       return texto.strip()
   ```

3. **Maneja errores con cuidado**
   ```python
   # No exponer información sensible en errores
   try:
       response = api_call()
   except Exception as e:
       # MAL: print(f"Error: {str(e)}")  # Podría incluir tokens
       # BIEN:
       print("Error al conectar con la API")
       logging.debug(f"Detalle: {str(e)}")  # Solo en logs
   ```

## Dependencias

Mantenemos las dependencias actualizadas para evitar vulnerabilidades conocidas.

```bash
# Verificar vulnerabilidades
pip install safety
safety check -r requirements.txt
```

## Actualizaciones de Seguridad

| Fecha | Versión | Descripción |
|:------|:--------|:------------|
| 2024-12-19 | 1.0.0 | Lanzamiento inicial |

---

Gracias por ayudar a mantener Scriptorium seguro.
