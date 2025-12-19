import SwiftUI

/// Vista de detalle y edición de documento
struct DocumentDetailView: View {
    @Binding var documento: Documento
    @EnvironmentObject var appState: AppState
    
    @State private var isSaving = false
    @State private var showingSaveSuccess = false
    @State private var activeSection: EditSection? = nil
    @FocusState private var focusedField: EditSection?
    
    enum EditSection: String, CaseIterable {
        case titulo = "Título"
        case metadatos = "Metadatos"
        case introduccion = "Introducción"
        case desarrollo = "Desarrollo"
        case conclusion = "Conclusión"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header con título
                headerSection
                
                Divider()
                
                // Metadatos
                metadatosSection
                
                Divider()
                
                // Secciones de contenido
                contentSection(
                    titulo: "Introducción",
                    section: .introduccion,
                    texto: $documento.introduccion,
                    placeholder: "Escribe la introducción del documento..."
                )
                
                contentSection(
                    titulo: "Desarrollo",
                    section: .desarrollo,
                    texto: $documento.desarrollo,
                    placeholder: "Escribe el desarrollo del documento..."
                )
                
                contentSection(
                    titulo: "Conclusión",
                    section: .conclusion,
                    texto: $documento.conclusion,
                    placeholder: "Escribe la conclusión del documento..."
                )
                
                Spacer(minLength: 50)
            }
            .padding(32)
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if showingSaveSuccess {
                    Label("Guardado", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Button {
                    guardarDocumento()
                } label: {
                    if isSaving {
                        ProgressView()
                            .scaleEffect(0.7)
                    } else {
                        Label("Guardar", systemImage: "square.and.arrow.down")
                    }
                }
                .keyboardShortcut("s", modifiers: .command)
                .disabled(isSaving || !documento.esValido)
                
                Menu {
                    Button {
                        exportarComoTexto()
                    } label: {
                        Label("Exportar como texto", systemImage: "doc.text")
                    }
                    
                    Button {
                        copiarAlPortapapeles()
                    } label: {
                        Label("Copiar al portapapeles", systemImage: "doc.on.clipboard")
                    }
                } label: {
                    Label("Más", systemImage: "ellipsis.circle")
                }
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                TextField("Título del documento", text: $documento.titulo)
                    .font(.system(size: 28, weight: .bold))
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .titulo)
                
                Spacer()
                
                if documento.esNuevo {
                    Text("No guardado")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.15), in: Capsule())
                }
            }
            
            if let fecha = documento.fechaModificacion {
                Text("Última modificación: \(fecha, style: .relative)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
    
    // MARK: - Metadatos Section
    
    private var metadatosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información del documento")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                MetadataField(
                    label: "Tipo",
                    icon: "tag.fill",
                    text: $documento.tipo,
                    placeholder: "Ej: práctica, ensayo..."
                )
                
                MetadataField(
                    label: "Materia",
                    icon: "book.fill",
                    text: $documento.materia,
                    placeholder: "Ej: Programación..."
                )
                
                MetadataField(
                    label: "Presenta",
                    icon: "person.fill",
                    text: $documento.presenta,
                    placeholder: "Tu nombre..."
                )
                
                MetadataField(
                    label: "Profesor",
                    icon: "person.crop.rectangle.fill",
                    text: $documento.profesor,
                    placeholder: "Nombre del profesor..."
                )
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Content Section
    
    private func contentSection(
        titulo: String,
        section: EditSection,
        texto: Binding<String>,
        placeholder: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(titulo)
                    .font(.headline)
                
                Spacer()
                
                Text("\(texto.wrappedValue.count) caracteres")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            ZStack(alignment: .topLeading) {
                if texto.wrappedValue.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                
                TextEditor(text: texto)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .focused($focusedField, equals: section)
                    .frame(minHeight: 150)
            }
            .padding(12)
            .background(Color(nsColor: .textBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(focusedField == section ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
    }
    
    // MARK: - Actions
    
    private func guardarDocumento() {
        isSaving = true
        documento.fechaModificacion = Date()
        
        Task {
            do {
                try await appState.guardarDocumento(documento)
                await MainActor.run {
                    isSaving = false
                    withAnimation {
                        showingSaveSuccess = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showingSaveSuccess = false
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    isSaving = false
                    appState.errorMessage = "Error al guardar: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func exportarComoTexto() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.plainText]
        panel.nameFieldStringValue = "\(documento.titulo).txt"
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                try documento.textoCompleto().write(to: url, atomically: true, encoding: .utf8)
            } catch {
                appState.errorMessage = "Error al exportar: \(error.localizedDescription)"
            }
        }
    }
    
    private func copiarAlPortapapeles() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(documento.textoCompleto(), forType: .string)
    }
}

// MARK: - Metadata Field

struct MetadataField: View {
    let label: String
    let icon: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
        }
    }
}

// MARK: - Preview

#Preview {
    DocumentDetailView(documento: .constant(Documento.ejemplo))
        .environmentObject(AppState())
        .frame(width: 700, height: 800)
}
