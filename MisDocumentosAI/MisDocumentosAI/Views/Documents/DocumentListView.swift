import SwiftUI
import UniformTypeIdentifiers

/// Vista de lista de documentos
struct DocumentListView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var filtroTipo: String? = nil
    @State private var ordenamiento: Ordenamiento = .fechaDesc
    @State private var isTargetedForDrop = false
    @State private var isImporting = false
    
    private let pythonBridge = PythonBridge.shared
    
    enum Ordenamiento: String, CaseIterable {
        case fechaDesc = "Más recientes"
        case fechaAsc = "Más antiguos"
        case tituloAsc = "Título A-Z"
        case tituloDesc = "Título Z-A"
    }
    
    private var documentosFiltrados: [Documento] {
        var docs = appState.documentos
        
        // Filtrar por búsqueda
        if !searchText.isEmpty {
            docs = docs.filter { doc in
                doc.titulo.localizedCaseInsensitiveContains(searchText) ||
                doc.materia.localizedCaseInsensitiveContains(searchText) ||
                doc.tipo.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filtrar por tipo
        if let tipo = filtroTipo {
            docs = docs.filter { $0.tipo.lowercased() == tipo.lowercased() }
        }
        
        // Ordenar
        switch ordenamiento {
        case .fechaDesc:
            docs.sort { ($0.fechaModificacion ?? .distantPast) > ($1.fechaModificacion ?? .distantPast) }
        case .fechaAsc:
            docs.sort { ($0.fechaModificacion ?? .distantPast) < ($1.fechaModificacion ?? .distantPast) }
        case .tituloAsc:
            docs.sort { $0.titulo.localizedCompare($1.titulo) == .orderedAscending }
        case .tituloDesc:
            docs.sort { $0.titulo.localizedCompare($1.titulo) == .orderedDescending }
        }
        
        return docs
    }
    
    private var tiposUnicos: [String] {
        Array(Set(appState.documentos.compactMap { 
            $0.tipo.isEmpty ? nil : $0.tipo.lowercased() 
        })).sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            toolbarView
            
            Divider()
            
            // Lista de documentos
            if documentosFiltrados.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(documentosFiltrados) { documento in
                            DocumentRowView(
                                documento: documento,
                                isSelected: appState.documentoSeleccionado?.id == documento.id
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.25)) {
                                    appState.documentoSeleccionado = documento
                                }
                            }
                            .contextMenu {
                                contextMenuItems(for: documento)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(minWidth: 300, idealWidth: 350)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
        .overlay { dropZoneOverlay }
        .onDrop(of: [.fileURL], isTargeted: $isTargetedForDrop) { providers in
            handleDrop(providers: providers)
        }
    }
    
    @ViewBuilder
    private var dropZoneOverlay: some View {
        if isTargetedForDrop {
            ZStack {
                Color.accentColor.opacity(0.1)
                
                VStack(spacing: 16) {
                    Image(systemName: "arrow.down.doc.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.accentColor)
                    
                    Text("Suelta el archivo aquí")
                        .font(.headline)
                        .foregroundStyle(Color.accentColor)
                    
                    Text("Formatos soportados: .txt, .docx")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .strokeBorder(Color.accentColor, style: StrokeStyle(lineWidth: 3, dash: [10]))
            )
        }
    }
    
    private var toolbarView: some View {
        VStack(spacing: 12) {
            // Búsqueda
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Buscar documentos...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(10)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Filtros y ordenamiento
            HStack {
                // Filtro por tipo
                Menu {
                    Button("Todos los tipos") {
                        filtroTipo = nil
                    }
                    Divider()
                    ForEach(tiposUnicos, id: \.self) { tipo in
                        Button(tipo.capitalized) {
                            filtroTipo = tipo
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text(filtroTipo?.capitalized ?? "Tipo")
                            .font(.caption)
                    }
                    .foregroundStyle(filtroTipo != nil ? Color.accentColor : Color.secondary)
                }
                .menuStyle(.borderlessButton)
                
                // Indicador de drag & drop
                if isImporting {
                    ProgressView()
                        .scaleEffect(0.6)
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.doc")
                        Text("Arrastra y suelta para importar")
                            .font(.caption)
                    }
                    .foregroundStyle(.tertiary)
                }
                
                Spacer()
                
                // Ordenamiento
                Menu {
                    ForEach(Ordenamiento.allCases, id: \.self) { orden in
                        Button {
                            ordenamiento = orden
                        } label: {
                            HStack {
                                Text(orden.rawValue)
                                if ordenamiento == orden {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.arrow.down")
                        Text(ordenamiento.rawValue)
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
                .menuStyle(.borderlessButton)
            }
        }
        .padding()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: searchText.isEmpty ? "doc.text" : "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.quaternary)
            
            Text(searchText.isEmpty ? "No hay documentos" : "Sin resultados")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text(searchText.isEmpty 
                 ? "Crea tu primer documento para comenzar" 
                 : "Intenta con otros términos de búsqueda")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
            
            if searchText.isEmpty {
                HStack(spacing: 12) {
                    Button {
                        appState.crearNuevoDocumento()
                    } label: {
                        Label("Crear", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        importarDesdeArchivo()
                    } label: {
                        Label("Importar", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    // MARK: - Importar Documentos
    
    private func importarDesdeArchivo() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [
            UTType.plainText,
            UTType(filenameExtension: "docx") ?? .data
        ]
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.message = "Selecciona archivos TXT o DOCX para importar al sistema RAG"
        
        if panel.runModal() == .OK {
            Task {
                for url in panel.urls {
                    await importarDocumento(url: url)
                }
            }
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    if let data = item as? Data,
                       let url = URL(dataRepresentation: data, relativeTo: nil) {
                        let ext = url.pathExtension.lowercased()
                        if ext == "txt" || ext == "docx" {
                            Task { @MainActor in
                                await importarDocumento(url: url)
                            }
                        }
                    }
                }
                return true
            }
        }
        return false
    }
    
    @MainActor
    private func importarDocumento(url: URL) async {
        isImporting = true
        
        do {
            let documento = try await pythonBridge.importarDocumentoDesdeArchivo(url: url)
            
            // Guardar el documento
            try await pythonBridge.guardarDocumento(documento)
            
            // Agregar a la lista
            appState.documentos.insert(documento, at: 0)
            appState.documentoSeleccionado = documento
            
        } catch {
            appState.errorMessage = "Error al importar: \(error.localizedDescription)"
        }
        
        isImporting = false
    }
    
    @ViewBuilder
    private func contextMenuItems(for documento: Documento) -> some View {
        Button {
            // Duplicar documento
            var copia = documento
            copia.id = UUID().uuidString
            copia.titulo = "\(documento.titulo) (copia)"
            copia.nombreArchivo = nil
            appState.documentos.insert(copia, at: 0)
        } label: {
            Label("Duplicar", systemImage: "doc.on.doc")
        }
        
        Divider()
        
        Button(role: .destructive) {
            Task {
                try? await appState.eliminarDocumento(documento)
            }
        } label: {
            Label("Eliminar", systemImage: "trash")
        }
    }
}

// MARK: - Document Row View

struct DocumentRowView: View {
    let documento: Documento
    let isSelected: Bool
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 14) {
            // Icono de tipo
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorForTipo.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: iconForTipo)
                    .font(.system(size: 18))
                    .foregroundStyle(colorForTipo)
            }
            
            // Contenido
            VStack(alignment: .leading, spacing: 4) {
                Text(documento.titulo.isEmpty ? "Sin título" : documento.titulo)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                HStack(spacing: 8) {
                    if !documento.tipo.isEmpty {
                        Text(documento.tipo.capitalized)
                            .font(.caption)
                            .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                    }
                    
                    if !documento.materia.isEmpty {
                        Text("•")
                            .foregroundStyle(isSelected ? Color.white.opacity(0.5) : Color.gray)
                        Text(documento.materia.capitalized)
                            .font(.caption)
                            .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            // Indicador de nuevo
            if documento.esNuevo {
                Text("Nuevo")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange, in: Capsule())
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(isSelected ? 0.1 : 0), radius: 4, y: 2)
        )
        .onHover { hovering in
            isHovered = hovering
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isHovered)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .accentColor
        } else if isHovered {
            return Color(nsColor: .controlBackgroundColor)
        } else {
            return Color(nsColor: .controlBackgroundColor).opacity(0.5)
        }
    }
    
    private var iconForTipo: String {
        switch documento.tipo.lowercased() {
        case "práctica", "practica": return "hammer.fill"
        case "investigación", "investigacion": return "magnifyingglass"
        case "ensayo": return "text.quote"
        case "reporte": return "chart.bar.doc.horizontal.fill"
        case "manual": return "book.fill"
        default: return "doc.text.fill"
        }
    }
    
    private var colorForTipo: Color {
        switch documento.tipo.lowercased() {
        case "práctica", "practica": return .orange
        case "investigación", "investigacion": return .blue
        case "ensayo": return .purple
        case "reporte": return .green
        case "manual": return .red
        default: return .gray
        }
    }
}

// MARK: - Preview

#Preview {
    DocumentListView()
        .environmentObject({
            let state = AppState()
            state.documentos = Documento.ejemplos
            return state
        }())
        .frame(width: 350, height: 600)
}
