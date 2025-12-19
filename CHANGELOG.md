# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Próximas Funcionalidades
- Exportación a DOCX/PDF
- Soporte multi-idioma
- Historial de generaciones
- Templates personalizables
- Versión iOS/iPadOS

---

## [1.0.0] - 2024-12-19

### ✨ Añadido

#### Sistema RAG
- Sistema completo de Retrieval-Augmented Generation
- `rag_sistema.py`: Motor principal de generación y transformación
- `documentos_manager.py`: Gestión de documentos JSON
- `embeddings_manager.py`: Generación y búsqueda de embeddings
- Cache local de embeddings para optimización

#### CLI (Python)
- `generar_documento.py`: Generación de documentos desde tema
- `transformar_texto.py`: Transformación de textos al estilo del usuario
- `agregar_documento.py`: Agregación de documentos de ejemplo
- Soporte para múltiples parámetros de generación:
  - Temperatura, max tokens, top-p
  - Penalizaciones de frecuencia y presencia
  - Contexto adicional y prompts personalizados
- Combinación de múltiples archivos para transformación

#### GUI (macOS)
- Aplicación nativa SwiftUI para macOS 14+
- Interfaz con NavigationSplitView de 3 columnas
- Vista de Documentos con lista y detalle
- Vista de Generador con controles visuales
- Vista de Transformador con editor de texto
- Configuración de API keys con KeychainService
- PythonBridge para comunicación con backend RAG

#### Documentación
- `README.md` completo con instrucciones de uso
- `CONTRIBUTING.md` con guía de contribución
- `docs/PRD.md` con especificaciones del producto
- `LICENSE` con licencia MIT

#### Configuración
- `requirements.txt` para dependencias Python
- `requirements-dev.txt` para desarrollo
- `.gitignore` para archivos ignorados
- `Package.swift` para la aplicación macOS

### 🔧 Configurado
- Soporte para GitHub AI Models como endpoint principal
- Soporte para OpenRouter como endpoint alternativo
- Modelo por defecto: `openai/gpt-4.1`
- Directorio de documentos: `documentos/`

### 📝 Notas
- Primera versión pública del proyecto
- CLI compatible con Windows, macOS y Linux
- GUI exclusiva para macOS 14+

---

## Tipos de Cambios

- `✨ Añadido` para nuevas funcionalidades.
- `🔄 Cambiado` para cambios en funcionalidades existentes.
- `⚠️ Deprecado` para funcionalidades que serán eliminadas próximamente.
- `🗑️ Eliminado` para funcionalidades eliminadas.
- `🐛 Corregido` para correcciones de bugs.
- `🔒 Seguridad` para vulnerabilidades.

---

[Unreleased]: https://github.com/tu-usuario/MisDocumentosAI/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/tu-usuario/MisDocumentosAI/releases/tag/v1.0.0
