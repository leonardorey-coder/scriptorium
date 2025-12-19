# Guía de Contribución - MisDocumentosAI

¡Gracias por tu interés en contribuir a MisDocumentosAI! Este documento te guiará a través del proceso de contribución.

---

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [Cómo Empezar](#cómo-empezar)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Guías de Estilo](#guías-de-estilo)
- [Reportar Bugs](#reportar-bugs)
- [Proponer Features](#proponer-features)
- [Pull Requests](#pull-requests)
- [Configuración del Entorno](#configuración-del-entorno)

---

## 📜 Código de Conducta

Nos comprometemos a proporcionar un ambiente amigable, seguro y acogedor para todos. Por favor, sé respetuoso y considerado con otros contribuyentes.

### Comportamiento Esperado

- ✅ Usar lenguaje acogedor e inclusivo
- ✅ Respetar diferentes puntos de vista y experiencias
- ✅ Aceptar críticas constructivas con gracia
- ✅ Enfocarse en lo mejor para la comunidad
- ✅ Mostrar empatía hacia otros contribuyentes

### Comportamiento Inaceptable

- ❌ Uso de lenguaje o imágenes sexualizadas
- ❌ Comentarios despectivos, insultantes o trolling
- ❌ Acoso público o privado
- ❌ Publicar información privada de otros sin permiso
- ❌ Cualquier conducta inapropiada en un entorno profesional

---

## 🚀 Cómo Empezar

### 1. Fork y Clone

```bash
# Fork el repositorio desde GitHub, luego:
git clone https://github.com/TU_USUARIO/MisDocumentosAI.git
cd MisDocumentosAI

# Agregar el repositorio original como upstream
git remote add upstream https://github.com/ORIGINAL_USUARIO/MisDocumentosAI.git
```

### 2. Configurar el Entorno

```bash
# Crear entorno virtual Python
python -m venv venv
source venv/bin/activate  # Linux/macOS
# o: .\venv\Scripts\activate  # Windows

# Instalar dependencias
pip install -r requirements.txt
pip install -r requirements-dev.txt  # Dependencias de desarrollo

# Configurar token de GitHub (para pruebas)
export GITHUB_TOKEN="tu_token_aqui"
```

### 3. Mantener tu Fork Actualizado

```bash
# Obtener cambios del upstream
git fetch upstream

# Actualizar tu rama main
git checkout main
git merge upstream/main

# Push a tu fork
git push origin main
```

---

## 🔄 Proceso de Desarrollo

### Flujo de Trabajo

```
1. Crear issue (si no existe)
       ↓
2. Crear rama desde main
       ↓
3. Hacer cambios
       ↓
4. Escribir/actualizar tests
       ↓
5. Commit con mensaje descriptivo
       ↓
6. Push a tu fork
       ↓
7. Crear Pull Request
       ↓
8. Revisión de código
       ↓
9. Merge
```

### Crear una Rama

```bash
# Siempre partir de main actualizado
git checkout main
git pull upstream main

# Crear rama con nombre descriptivo
git checkout -b tipo/descripcion-corta

# Ejemplos:
git checkout -b feature/exportar-pdf
git checkout -b fix/error-embeddings
git checkout -b docs/mejorar-readme
```

### Convención de Nombres de Ramas

| Prefijo | Uso | Ejemplo |
|:--------|:----|:--------|
| `feature/` | Nueva funcionalidad | `feature/soporte-docx` |
| `fix/` | Corrección de bug | `fix/timeout-api` |
| `docs/` | Documentación | `docs/guia-instalacion` |
| `refactor/` | Refactorización | `refactor/embeddings-manager` |
| `test/` | Tests | `test/documentos-manager` |
| `chore/` | Mantenimiento | `chore/actualizar-deps` |

---

## 📝 Guías de Estilo

### Python (CLI y Sistema RAG)

#### Estilo General

- Seguir **PEP 8**
- Máximo 100 caracteres por línea
- Usar **snake_case** para funciones y variables
- Usar **PascalCase** para clases
- Documentar en español

#### Ejemplo de Código

```python
from typing import List, Dict, Any, Optional
import os

class MiClase:
    """
    Descripción breve de la clase.
    
    Attributes:
        atributo (str): Descripción del atributo
    """
    
    def __init__(self, atributo: str) -> None:
        """
        Inicializar la clase.
        
        Args:
            atributo (str): Descripción del parámetro
        """
        self.atributo = atributo
    
    def mi_metodo(self, parametro: str, opcional: Optional[int] = None) -> Dict[str, Any]:
        """
        Descripción del método.
        
        Args:
            parametro (str): Descripción del parámetro
            opcional (int, optional): Descripción. Defaults to None.
            
        Returns:
            Dict[str, Any]: Descripción del retorno
            
        Raises:
            ValueError: Cuando ocurre un error
        """
        if not parametro:
            raise ValueError("El parámetro no puede estar vacío")
        
        return {"resultado": parametro}
```

#### Imports

```python
# 1. Imports de biblioteca estándar
import os
import json
from typing import List, Dict, Any

# 2. Imports de terceros
import numpy as np
import requests

# 3. Imports locales
from .documentos_manager import DocumentosManager
from .embeddings_manager import EmbeddingsManager
```

### Swift (GUI macOS)

#### Estilo General

- Seguir **Swift API Design Guidelines**
- Usar **camelCase** para funciones y propiedades
- Usar **PascalCase** para tipos
- Documentar con comentarios `///`
- Preferir programación declarativa con SwiftUI

#### Ejemplo de Código

```swift
import SwiftUI

/// Vista para mostrar la lista de documentos
struct DocumentListView: View {
    // MARK: - Properties
    
    /// Estado de la aplicación
    @EnvironmentObject var appState: AppState
    
    /// Término de búsqueda
    @State private var searchTerm: String = ""
    
    // MARK: - Body
    
    var body: some View {
        List {
            ForEach(filteredDocuments) { documento in
                DocumentRow(documento: documento)
            }
        }
        .searchable(text: $searchTerm)
        .navigationTitle("Documentos")
    }
    
    // MARK: - Computed Properties
    
    /// Documentos filtrados por término de búsqueda
    private var filteredDocuments: [Documento] {
        guard !searchTerm.isEmpty else {
            return appState.documentos
        }
        return appState.documentos.filter {
            $0.titulo.localizedCaseInsensitiveContains(searchTerm)
        }
    }
}

// MARK: - Preview

#Preview {
    DocumentListView()
        .environmentObject(AppState())
}
```

#### Organización de Archivos Swift

```swift
import SwiftUI

// MARK: - Main View

struct MiVista: View {
    // MARK: - Properties
    
    // MARK: - Body
    
    var body: some View {
        // ...
    }
    
    // MARK: - Computed Properties
    
    // MARK: - Private Methods
}

// MARK: - Subviews

private struct SubVista: View {
    // ...
}

// MARK: - Preview

#Preview {
    MiVista()
}
```

---

## 🐛 Reportar Bugs

### Antes de Reportar

1. Busca si ya existe un issue similar
2. Verifica que estés usando la última versión
3. Intenta reproducir el bug en un entorno limpio

### Crear un Issue

Usa esta plantilla:

```markdown
## Descripción del Bug

[Descripción clara y concisa del bug]

## Pasos para Reproducir

1. Ir a '...'
2. Ejecutar '...'
3. Ver error

## Comportamiento Esperado

[Qué debería pasar]

## Comportamiento Actual

[Qué pasa realmente]

## Entorno

- Sistema Operativo: [ej. macOS 14.0, Windows 11]
- Versión de Python: [ej. 3.11.5]
- Versión de Swift (si aplica): [ej. 5.9]
- Versión del proyecto: [ej. 1.0.0]

## Logs o Capturas

[Incluir cualquier log de error o captura de pantalla]

## Contexto Adicional

[Cualquier otra información relevante]
```

---

## 💡 Proponer Features

### Plantilla para Propuesta

```markdown
## Resumen

[Descripción breve de la característica]

## Motivación

[¿Por qué es necesaria esta característica?]

## Solución Propuesta

[Descripción detallada de cómo implementarla]

## Alternativas Consideradas

[Otras soluciones que consideraste y por qué las descartaste]

## Impacto

- [ ] Requiere cambios en CLI
- [ ] Requiere cambios en GUI
- [ ] Requiere cambios en el sistema RAG
- [ ] Es un cambio breaking

## ¿Puedes Implementarlo?

[Sí/No/Con ayuda]
```

---

## 🔀 Pull Requests

### Antes de Crear un PR

1. ✅ Tu código sigue las guías de estilo
2. ✅ Has añadido tests si es necesario
3. ✅ Todos los tests pasan
4. ✅ Has actualizado la documentación
5. ✅ Tu rama está actualizada con main

### Plantilla de PR

```markdown
## Descripción

[Descripción de los cambios realizados]

## Tipo de Cambio

- [ ] 🐛 Bug fix
- [ ] ✨ Nueva feature
- [ ] 📝 Documentación
- [ ] ♻️ Refactor
- [ ] 🧪 Tests
- [ ] 🔧 Configuración

## Issue Relacionado

Closes #[número del issue]

## Checklist

- [ ] Mi código sigue las guías de estilo
- [ ] He realizado self-review de mi código
- [ ] He comentado código complejo
- [ ] He actualizado la documentación
- [ ] Mis cambios no generan warnings
- [ ] He añadido tests
- [ ] Todos los tests pasan localmente

## Capturas de Pantalla (si aplica)

[Incluir capturas para cambios de UI]
```

### Mensajes de Commit

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Formato
<tipo>(<alcance>): <descripción>

[cuerpo opcional]

[footer opcional]
```

#### Tipos

| Tipo | Descripción |
|:-----|:------------|
| `feat` | Nueva característica |
| `fix` | Corrección de bug |
| `docs` | Solo documentación |
| `style` | Cambios que no afectan el significado del código |
| `refactor` | Cambio que no añade feature ni corrige bug |
| `perf` | Mejora de rendimiento |
| `test` | Añadir tests faltantes |
| `chore` | Cambios en el proceso de build o herramientas |

#### Ejemplos

```bash
feat(generator): añadir soporte para exportar a PDF

fix(rag): corregir error de timeout en llamada a API

docs(readme): actualizar instrucciones de instalación

refactor(embeddings): simplificar cálculo de similitud

test(documentos): añadir tests para guardar_documento
```

---

## ⚙️ Configuración del Entorno

### Desarrollo CLI (Python)

```bash
# Crear entorno virtual
python -m venv venv
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Instalar dependencias de desarrollo
pip install pytest black flake8 mypy

# Formatear código
black .

# Verificar estilo
flake8 .

# Verificar tipos
mypy .

# Ejecutar tests
pytest
```

### Desarrollo GUI (Swift/macOS)

```bash
# Compilar
cd MisDocumentosAI
swift build

# Ejecutar tests
swift test

# Ejecutar aplicación
swift run

# Abrir en Xcode
open Package.swift
```

### Variables de Entorno

```bash
# Requerido
export GITHUB_TOKEN="tu_token_github"

# Opcional
export OPENROUTER_API_KEY="tu_api_key"
export RAG_MODEL="openai/gpt-4.1"
export RAG_ENDPOINT="https://models.github.ai/inference"
```

---

## 🧪 Tests

### Tests Python

```bash
# Ejecutar todos los tests
pytest

# Con cobertura
pytest --cov=rag --cov-report=html

# Solo un archivo
pytest tests/test_documentos_manager.py

# Modo verbose
pytest -v
```

### Estructura de Tests

```
tests/
├── __init__.py
├── test_documentos_manager.py
├── test_embeddings_manager.py
├── test_rag_sistema.py
└── fixtures/
    └── documentos_ejemplo/
```

### Ejemplo de Test

```python
import pytest
from rag.documentos_manager import DocumentosManager

class TestDocumentosManager:
    """Tests para DocumentosManager."""
    
    @pytest.fixture
    def manager(self, tmp_path):
        """Crear manager con directorio temporal."""
        return DocumentosManager(directorio_docs=str(tmp_path))
    
    def test_guardar_documento(self, manager):
        """Verificar que se guarda correctamente un documento."""
        doc = {
            "titulo": "Test",
            "tipo": "practica",
            "contenido": "Contenido de prueba"
        }
        
        ruta = manager.guardar_documento(doc)
        
        assert ruta.endswith(".json")
        assert os.path.exists(ruta)
    
    def test_cargar_documentos_vacio(self, manager):
        """Verificar comportamiento con directorio vacío."""
        docs = manager.cargar_documentos()
        
        assert docs == []
```

---

## 📚 Recursos Adicionales

### Documentación

- [PRD (Product Requirements Document)](docs/PRD.md)
- [README](README.md)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)

### Herramientas Recomendadas

| Herramienta | Propósito |
|:------------|:----------|
| VS Code / PyCharm | Editor para Python |
| Xcode | IDE para Swift |
| Git Kraken / Fork | Cliente Git visual |
| Postman | Probar APIs |

---

## ❓ Preguntas

Si tienes preguntas:

1. Revisa la documentación existente
2. Busca en issues existentes
3. Crea un issue con la etiqueta `question`
4. Contacta al mantenedor

---

<p align="center">
  <strong>¡Gracias por contribuir a MisDocumentosAI! 🙏</strong>
</p>
