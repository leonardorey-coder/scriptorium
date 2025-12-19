import SwiftUI
import UniformTypeIdentifiers

/// Vista del transformador de texto
struct TransformerView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var textoOriginal = ""
    @State private var textoTransformado = ""
    @State private var temperatura: Double = 0.7
    @State private var contextoAdicional = ""
    @State private var mostrarContexto = false
    
    // Nuevos parámetros del modelo
    @State private var topP: Double = 1.0
    @State private var frequencyPenalty: Double = 0.0
    @State private var presencePenalty: Double = 0.0
    
    // Transformación múltiple
    @State private var transformacionMultiple = false
    @State private var numeroTransformaciones: Int = 3
    @State private var randomizarParametros = true
    @State private var resultadosMultiples: [(id: UUID, contenido: String, params: String)] = []
    @State private var resultadoSeleccionado: UUID?
    @State private var progresoTransformacion: Int = 0
    
    @State private var isTransforming = false
    @State private var errorTransformacion: String?
    @State private var isTargetedForDrop = false
    
    private let pythonBridge = PythonBridge.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            toolbarView
            
            Divider()
            
            // Contenido principal
            HSplitView {
                // Panel de texto original
                originalPanel
                    .frame(minWidth: 350)
                
                // Panel de texto transformado
                transformedPanel
                    .frame(minWidth: 350)
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
    
    // MARK: - Toolbar
    
    private var toolbarView: some View {
        HStack {
            Label("Transformar Texto", systemImage: "arrow.triangle.2.circlepath")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            // Transformación múltiple
            HStack(spacing: 8) {
                Toggle(isOn: $transformacionMultiple) {
                    Image(systemName: "square.stack.3d.up.fill")
                }
                .toggleStyle(.button)
                .help("Transformación múltiple")
                
                if transformacionMultiple {
                    Picker("", selection: $numeroTransformaciones) {
                        ForEach(2...5, id: \.self) { n in
                            Text("\(n)").tag(n)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                    
                    Toggle(isOn: $randomizarParametros) {
                        Image(systemName: "dice")
                    }
                    .toggleStyle(.button)
                    .help("Randomizar parámetros")
                }
            }
            
            Divider()
                .frame(height: 24)
            
            // Parámetros inline
            HStack(spacing: 8) {
                Text("Temp:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize()
                
                Slider(value: $temperatura, in: 0...1, step: 0.05)
                    .frame(width: 80)
                
                Text(String(format: "%.2f", temperatura))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    .frame(width: 35)
            }
            
            Toggle("Prompt", isOn: $mostrarContexto)
                .toggleStyle(.button)
                .fixedSize()
            
            Divider()
                .frame(height: 24)
            
            // Botón de transformar
            Button {
                if transformacionMultiple {
                    transformarMultiple()
                } else {
                    transformarTexto()
                }
            } label: {
                HStack {
                    if isTransforming {
                        ProgressView()
                            .scaleEffect(0.7)
                        if transformacionMultiple {
                            Text("\(progresoTransformacion)/\(numeroTransformaciones)")
                        }
                    } else {
                        Image(systemName: "sparkles")
                        Text(transformacionMultiple ? "Transformar ×\(numeroTransformaciones)" : "Transformar")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(textoOriginal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isTransforming)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
    }
    
    // MARK: - Original Panel
    
    private var originalPanel: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Texto Original")
                    .font(.headline)
                
                Spacer()
                
                Text("\(textoOriginal.count) caracteres")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                
                Button {
                    cargarDesdeArchivo()
                } label: {
                    Label("Cargar archivo", systemImage: "doc.fill")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button {
                    textoOriginal = ""
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(textoOriginal.isEmpty)
            }
            .padding()
            
            Divider()
            
            // Editor con drop
            ZStack {
                TextEditor(text: $textoOriginal)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .padding()
                
                if textoOriginal.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "arrow.down.doc.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(isTargetedForDrop ? Color.accentColor : Color.gray.opacity(0.3))
                        
                        Text("Arrastra un archivo aquí o escribe tu texto")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .allowsHitTesting(false)
                }
            }
            .background(Color(nsColor: .textBackgroundColor))
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(isTargetedForDrop ? Color.accentColor : Color.clear, lineWidth: 3)
            )
            .onDrop(of: [.plainText, .fileURL], isTargeted: $isTargetedForDrop) { providers in
                handleDrop(providers: providers)
            }
            
            // Contexto adicional
            if mostrarContexto {
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Prompt adicional")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextField("Instrucciones adicionales para la transformación...", text: $contextoAdicional, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2...4)
                }
                .padding()
                .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
            }
        }
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.3))
    }
    
    // MARK: - Transformed Panel
    
    private var transformedPanel: some View {
        VStack(spacing: 0) {
            transformedHeader
            Divider()
            transformedContent
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
    
    @ViewBuilder
    private var transformedHeader: some View {
        HStack {
            if transformacionMultiple && !resultadosMultiples.isEmpty {
                Text("Resultados (\(resultadosMultiples.count))")
                    .font(.headline)
            } else {
                Text("Texto Transformado")
                    .font(.headline)
            }
            
            Spacer()
            
            transformedHeaderButtons
        }
        .padding()
    }
    
    @ViewBuilder
    private var transformedHeaderButtons: some View {
        if transformacionMultiple && !resultadosMultiples.isEmpty {
            if let selected = resultadoSeleccionado,
               let resultado = resultadosMultiples.first(where: { $0.id == selected }) {
                Button {
                    copiarResultadoMultiple(resultado.contenido)
                } label: {
                    Label("Copiar", systemImage: "doc.on.clipboard")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button {
                    guardarResultadoMultiple(resultado.contenido)
                } label: {
                    Label("Guardar", systemImage: "square.and.arrow.down")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
        } else if !textoTransformado.isEmpty {
            Text("\(textoTransformado.count) caracteres")
                .font(.caption)
                .foregroundStyle(.tertiary)
            
            Button {
                copiarTransformado()
            } label: {
                Label("Copiar", systemImage: "doc.on.clipboard")
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            
            Button {
                guardarComoDocumento()
            } label: {
                Label("Guardar", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
    }
    
    @ViewBuilder
    private var transformedContent: some View {
        if isTransforming {
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                
                if transformacionMultiple {
                    Text("Transformando \(progresoTransformacion) de \(numeroTransformaciones)...")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Transformando texto...")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                
                Text("El texto se adaptará a tu estilo de escritura")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = errorTransformacion {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.red)
                
                Text("Error al transformar")
                    .font(.headline)
                
                Text(error)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if transformacionMultiple && !resultadosMultiples.isEmpty {
            multipleResultsView
        } else if textoTransformado.isEmpty && resultadosMultiples.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "text.badge.checkmark")
                    .font(.system(size: 48))
                    .foregroundStyle(.quaternary)
                
                Text("Resultado de la transformación")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text("El texto transformado aparecerá aquí")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                Text(textoTransformado)
                    .font(.body)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(Color(nsColor: .textBackgroundColor))
        }
    }
    
    private var multipleResultsView: some View {
        HSplitView {
            resultsList
            selectedResultContent
        }
    }
    
    private var resultsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<resultadosMultiples.count, id: \.self) { index in
                    resultRowView(index: index)
                    Divider()
                }
            }
        }
        .frame(width: 160)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
    }
    
    private func resultRowView(index: Int) -> some View {
        let resultado = resultadosMultiples[index]
        let isSelected = resultadoSeleccionado == resultado.id
        
        return Button {
            resultadoSeleccionado = resultado.id
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Resultado \(index + 1)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(resultado.params)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding(10)
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var selectedResultContent: some View {
        if let selected = resultadoSeleccionado,
           let resultado = resultadosMultiples.first(where: { $0.id == selected }) {
            ScrollView {
                Text(resultado.contenido)
                    .font(.body)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(Color(nsColor: .textBackgroundColor))
        } else {
            VStack {
                Text("Selecciona un resultado")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Actions
    
    private func transformarTexto() {
        isTransforming = true
        errorTransformacion = nil
        resultadosMultiples = []
        
        Task {
            do {
                let resultado = try await pythonBridge.transformarTexto(
                    texto: textoOriginal,
                    contextoAdicional: mostrarContexto && !contextoAdicional.isEmpty ? contextoAdicional : nil,
                    temperatura: temperatura
                )
                await MainActor.run {
                    textoTransformado = resultado
                    isTransforming = false
                }
            } catch {
                await MainActor.run {
                    errorTransformacion = error.localizedDescription
                    isTransforming = false
                }
            }
        }
    }
    
    private func transformarMultiple() {
        isTransforming = true
        errorTransformacion = nil
        resultadosMultiples = []
        resultadoSeleccionado = nil
        progresoTransformacion = 0
        
        Task {
            for i in 1...numeroTransformaciones {
                await MainActor.run {
                    progresoTransformacion = i
                }
                
                // Generar parámetros (randomizados o fijos)
                let temp: Double
                if randomizarParametros {
                    temp = Double.random(in: 0.3...1.0)
                } else {
                    temp = temperatura
                }
                
                do {
                    let resultado = try await pythonBridge.transformarTexto(
                        texto: textoOriginal,
                        contextoAdicional: mostrarContexto && !contextoAdicional.isEmpty ? contextoAdicional : nil,
                        temperatura: temp
                    )
                    let paramsString = String(format: "T:%.2f", temp)
                    let newResult = (id: UUID(), contenido: resultado, params: paramsString)
                    
                    await MainActor.run {
                        resultadosMultiples.append(newResult)
                        if resultadoSeleccionado == nil {
                            resultadoSeleccionado = newResult.id
                        }
                    }
                } catch {
                    await MainActor.run {
                        errorTransformacion = "Error en transformación \(i): \(error.localizedDescription)"
                        isTransforming = false
                    }
                    return
                }
            }
            
            await MainActor.run {
                isTransforming = false
            }
        }
    }
    
    private func cargarDesdeArchivo() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.plainText, .text]
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                textoOriginal = try String(contentsOf: url, encoding: .utf8)
            } catch {
                appState.errorMessage = "Error al cargar archivo: \(error.localizedDescription)"
            }
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    if let data = item as? Data,
                       let url = URL(dataRepresentation: data, relativeTo: nil),
                       let contenido = try? String(contentsOf: url, encoding: .utf8) {
                        DispatchQueue.main.async {
                            textoOriginal = contenido
                        }
                    }
                }
                return true
            }
            
            if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { item, error in
                    if let texto = item as? String {
                        DispatchQueue.main.async {
                            textoOriginal = texto
                        }
                    }
                }
                return true
            }
        }
        return false
    }
    
    private func copiarTransformado() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(textoTransformado, forType: .string)
    }
    
    private func copiarResultadoMultiple(_ contenido: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(contenido, forType: .string)
    }
    
    private func guardarComoDocumento() {
        let documento = pythonBridge.parsearDocumento(texto: textoTransformado, tema: "Texto transformado")
        appState.documentos.insert(documento, at: 0)
        appState.documentoSeleccionado = documento
        appState.navegarA(.documentos)
    }
    
    private func guardarResultadoMultiple(_ contenido: String) {
        let documento = pythonBridge.parsearDocumento(texto: contenido, tema: "Texto transformado")
        appState.documentos.insert(documento, at: 0)
        appState.documentoSeleccionado = documento
        appState.navegarA(.documentos)
    }
}

// MARK: - Preview

#Preview {
    TransformerView()
        .environmentObject(AppState())
        .frame(width: 900, height: 600)
}
