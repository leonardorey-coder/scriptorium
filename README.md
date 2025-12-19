<p align="center">
  <img src="https://img.shields.io/badge/macOS-14%2B-blue?style=for-the-badge&logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/Python-3.8%2B-green?style=for-the-badge&logo=python" alt="Python">
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">
</p>

# 📝 MisDocumentosAI

> **Sistema de generación y transformación de documentos que aprende tu estilo de escritura personal usando RAG (Retrieval-Augmented Generation)**

MisDocumentosAI es una herramienta de IA que analiza tus documentos existentes para aprender tu estilo único de escritura y genera nuevos documentos o transforma textos existentes manteniendo tu voz personal.

---

## ✨ Características

<table>
<tr>
<td width="50%">

### 🎯 Generación Inteligente
- Genera documentos nuevos desde un tema
- Mantiene tu estilo de escritura único
- Soporta múltiples tipos de documentos
- Control total sobre parámetros de IA

</td>
<td width="50%">

### 🔄 Transformación de Texto
- Adapta cualquier texto a tu estilo
- Combina múltiples archivos
- Preserva el contenido original
- Reformatea estructura automáticamente

</td>
</tr>
<tr>
<td width="50%">

### 📚 Sistema RAG
- Aprende de tus documentos
- Búsqueda por similitud semántica
- Cache de embeddings para velocidad
- Fallback local sin API

</td>
<td width="50%">

### 🖥️ Dos Versiones
- **CLI**: Para automatización y scripts
- **GUI**: Interfaz nativa macOS elegante
- Misma potencia, diferente experiencia

</td>
</tr>
</table>

---

## 📋 Compatibilidad de Sistemas Operativos

| Sistema Operativo | CLI (Python) | GUI (SwiftUI) | Notas |
|:------------------|:------------:|:-------------:|:------|
| macOS 14+ (Sonoma) | ✅ | ✅ | Soporte completo |
| macOS 13 (Ventura) | ✅ | ⚠️ | GUI requiere 14+ |
| macOS 12 (Monterey) | ✅ | ❌ | Solo CLI |
| Windows 10/11 | ✅ | ❌ | Solo CLI |
| Linux (Ubuntu 20.04+) | ✅ | ❌ | Solo CLI |
| WSL2 | ✅ | ❌ | Solo CLI |

---

## 🚀 Inicio Rápido

### Requisitos Previos

<details>
<summary><strong>📦 Para versión CLI (Todas las plataformas)</strong></summary>

```bash
# Python 3.8 o superior
python --version

# Dependencias
pip install requests numpy scikit-learn

# Token de GitHub AI (requerido)
export GITHUB_TOKEN="tu_token_aqui"
```

</details>

<details>
<summary><strong>🍎 Para versión GUI (Solo macOS)</strong></summary>

```bash
# Requisitos
- macOS 14.0 (Sonoma) o superior
- Xcode 15.0+
- Python 3.8+ (para el backend)

# Clonar e instalar
git clone https://github.com/tu-usuario/MisDocumentosAI.git
cd MisDocumentosAI/MisDocumentosAI
swift build
swift run
```

</details>

### Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/MisDocumentosAI.git
cd MisDocumentosAI

# 2. Instalar dependencias Python
pip install -r requirements.txt

# 3. Configurar token de API
export GITHUB_TOKEN="ghp_tu_token_aqui"

# 4. (Opcional) Agregar documentos de ejemplo
python agregar_documento.py documento_ejemplo.txt
```

---

## 💻 Uso

### Versión CLI

#### Generar un documento nuevo

```bash
# Generación básica
python generar_documento.py "Implementación de patrones de diseño en Java"

# Con tipo específico
python generar_documento.py "Bases de datos relacionales" --tipo practica

# Con contexto adicional
python generar_documento.py "Machine Learning" --contexto notas.txt

# Con prompt personalizado
python generar_documento.py "Redes neuronales" --prompt-texto "Escribe un ensayo argumentativo"

# Guardar el resultado
python generar_documento.py "Cloud Computing" --guardar
```

#### Transformar texto existente

```bash
# Transformar un archivo
python transformar_texto.py --archivo texto_original.txt

# Combinar dos archivos
python transformar_texto.py --archivo archivo1.txt --archivo2 archivo2.txt

# Con contexto adicional
python transformar_texto.py --archivo texto.txt --contexto notas.txt

# Guardar resultado
python transformar_texto.py --archivo texto.txt --guardar --salida resultado.txt
```

#### Agregar documentos de ejemplo

```bash
# Agregar un documento
python agregar_documento.py documento.txt

# Con nombre personalizado
python agregar_documento.py documento.txt --nombre mi_practica

# Sobrescribir existente
python agregar_documento.py documento.txt --nombre mi_practica --sobrescribir
```

### Versión GUI (macOS)

```bash
# Compilar y ejecutar
cd MisDocumentosAI
swift build
swift run

# O abrir en Xcode
open Package.swift
```

**Interfaz de la aplicación:**

<table>
<tr>
<td align="center"><strong>📄 Documentos</strong></td>
<td align="center"><strong>✍️ Generador</strong></td>
<td align="center"><strong>🔄 Transformador</strong></td>
</tr>
<tr>
<td>Gestiona tus documentos de ejemplo</td>
<td>Genera documentos nuevos</td>
<td>Transforma textos al tu estilo</td>
</tr>
</table>

---

## ⚙️ Parámetros de Configuración

| Parámetro | Rango | Default | Descripción |
|:----------|:-----:|:-------:|:------------|
| `--temperatura` | 0.0-1.0 | 0.7 | Creatividad (mayor = más creativo) |
| `--max-tokens` | 1-32768 | 32768 | Longitud máxima del documento |
| `--top-p` | 0.0-1.0 | 1.0 | Nucleus sampling |
| `--frequency-penalty` | -2.0 a 2.0 | 0.0 | Evitar repeticiones |
| `--presence-penalty` | -2.0 a 2.0 | 0.0 | Favorecer temas nuevos |
| `--endpoint` | URL | GitHub AI | Endpoint de API personalizado |

---

## 📁 Estructura del Proyecto

```
MisDocumentosAI/
├── 📄 generar_documento.py     # CLI: Generador de documentos
├── 📄 transformar_texto.py     # CLI: Transformador de texto
├── 📄 agregar_documento.py     # CLI: Agregador de documentos
├── 📁 rag/                      # Sistema RAG
│   ├── __init__.py
│   ├── rag_sistema.py          # Sistema RAG principal
│   ├── documentos_manager.py   # Gestión de documentos
│   └── embeddings_manager.py   # Gestión de embeddings
├── 📁 documentos/               # Documentos de ejemplo (JSON)
├── 📁 MisDocumentosAI/          # Aplicación GUI (Swift/macOS)
│   ├── Package.swift           # Configuración del paquete
│   └── MisDocumentosAI/
│       ├── MisDocumentosAIApp.swift
│       ├── ContentView.swift
│       ├── Models/
│       ├── Views/
│       ├── ViewModels/
│       └── Services/
└── 📁 docs/                     # Documentación
    └── PRD.md                  # Product Requirements Document
```

---

## 📝 Formato de Documentos

Los documentos se almacenan en formato JSON con la siguiente estructura:

```json
{
  "titulo": "Título del Documento",
  "tipo": "practica",
  "materia": "Programación Visual",
  "presenta": "Tu Nombre",
  "profesor": "Nombre del Profesor",
  "introduccion": "Texto de introducción...",
  "desarrollo": "Contenido principal del documento...",
  "conclusion": "Conclusiones y reflexiones finales..."
}
```

### Tipos de Documento Soportados

| Tipo | Descripción |
|:-----|:------------|
| `practica` | Trabajos prácticos de laboratorio |
| `investigacion` | Trabajos de investigación académica |
| `ensayo` | Ensayos argumentativos |
| `reporte` | Reportes técnicos |
| `manual` | Documentación y manuales |
| `otro` | Otros tipos de documento |

---

## 🔐 Configuración de API

### GitHub AI (Recomendado)

```bash
# Obtener token en: https://github.com/settings/tokens
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

### OpenRouter (Alternativa)

```bash
# Para usar con OpenRouter
export GITHUB_TOKEN="tu_token_openrouter"
python generar_documento.py "tema" --endpoint "https://openrouter.ai/api/v1"
```

---

## 🤝 Contribuir al Proyecto

¡Las contribuciones son bienvenidas! Aquí te explicamos cómo puedes ayudar:

### Formas de Contribuir

| Tipo | Descripción |
|:-----|:------------|
| 🐛 **Reportar Bugs** | Abre un issue describiendo el problema |
| 💡 **Sugerir Features** | Propón nuevas funcionalidades |
| 📝 **Mejorar Docs** | Ayuda a mejorar la documentación |
| 💻 **Contribuir Código** | Envía pull requests con mejoras |
| 🌐 **Traducciones** | Ayuda a traducir la aplicación |

### Cómo Contribuir

1. **Fork** el repositorio

```bash
# Clonar tu fork
git clone https://github.com/TU_USUARIO/MisDocumentosAI.git
cd MisDocumentosAI
```

2. **Crear una rama** para tu feature

```bash
git checkout -b feature/mi-nueva-caracteristica
```

3. **Hacer tus cambios** y commit

```bash
git add .
git commit -m "feat: descripción de la característica"
```

4. **Push** a tu fork

```bash
git push origin feature/mi-nueva-caracteristica
```

5. **Abrir un Pull Request** desde GitHub

### Convenciones de Código

#### Python (CLI & RAG)
- Usar **PEP 8** para estilo de código
- Docstrings en español
- Type hints donde sea posible
- Tests unitarios para nuevas funcionalidades

```python
def mi_funcion(parametro: str) -> Dict[str, Any]:
    """
    Descripción de la función.
    
    Args:
        parametro (str): Descripción del parámetro
        
    Returns:
        Dict[str, Any]: Descripción del retorno
    """
    pass
```

#### Swift (GUI)
- Seguir Swift API Design Guidelines
- Documentación con comentarios `///`
- Usar SwiftUI moderno

```swift
/// Descripción de la vista
struct MiVista: View {
    /// Estado de la vista
    @State private var miEstado: String = ""
    
    var body: some View {
        // Implementación
    }
}
```

### Estructura de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

| Prefijo | Uso |
|:--------|:----|
| `feat:` | Nueva característica |
| `fix:` | Corrección de bug |
| `docs:` | Cambios en documentación |
| `style:` | Formato, sin cambios de código |
| `refactor:` | Refactorización de código |
| `test:` | Añadir o modificar tests |
| `chore:` | Tareas de mantenimiento |

### Issues y Pull Requests

#### Reportar un Bug

Al crear un issue de bug, incluye:
- Versión del sistema operativo
- Versión de Python/Swift
- Pasos para reproducir
- Comportamiento esperado vs actual
- Logs o capturas de pantalla

#### Proponer un Feature

Al proponer una nueva característica:
- Describe el problema que resuelve
- Propón una solución
- Considera alternativas
- Indica si puedes implementarlo

---

## 📜 Changelog

### v1.0.0 (Diciembre 2025)
- ✅ Generador de documentos CLI
- ✅ Transformador de texto CLI
- ✅ Sistema RAG con embeddings
- ✅ Aplicación GUI macOS (SwiftUI)
- ✅ Soporte para múltiples endpoints
- ✅ Cache de embeddings local

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

```
MIT License

Copyright (c) 2025 Leonardo Cruz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 🙏 Agradecimientos

- **GitHub AI Models** por proporcionar acceso a modelos de IA
- **OpenAI** por la inspiración en embeddings
- **Apple** por SwiftUI y las herramientas de desarrollo

---

## 📞 Contacto

- **Autor**: Leonardo Cruz
- **GitHub**: [@leonardorey-coder](https://github.com/leonardorey-coder)
- **Email**: leonardo.cfjl@gmail.com

---

<p align="center">
  <strong>⭐ Si te gusta este proyecto, considera darle una estrella!</strong>
</p>

<p align="center">
  Hecho con ❤️ en México
</p>
