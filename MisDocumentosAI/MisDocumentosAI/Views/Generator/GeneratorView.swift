import SwiftUI

/// Vista del generador de documentos con RAG
struct GeneratorView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var tema = ""
    @State private var tipoSeleccionado: TipoDocumento = .practica
    @State private var usarTipo = false
    @State private var contextoAdicional = ""
    @State private var mostrarContexto = false
    @State private var promptPersonalizado = ""
    @State private var usarPromptPersonalizado = false
    @State private var temperatura: Double = 0.7
    @State private var maxTokens: Double = 32768
    
    // Nuevos parámetros del modelo
    @State private var topP: Double = 1.0
    @State private var frequencyPenalty: Double = 0.0
    @State private var presencePenalty: Double = 0.0
    @State private var mostrarParametrosAvanzados = false
    
    // Generación múltiple
    @State private var generacionMultiple = false
    @State private var numeroGeneraciones: Int = 3
    @State private var randomizarParametros = true
    @State private var resultadosMultiples: [(id: UUID, contenido: String, params: String)] = []
    @State private var resultadoSeleccionado: UUID?
    
    @State private var isGenerating = false
    @State private var resultadoGenerado = ""
    @State private var errorGeneracion: String?
    @State private var progresoGeneracion: Int = 0
    
    private let pythonBridge = PythonBridge.shared
    
    var body: some View {
        HSplitView {
            // Panel de configuración
            configPanel
                .frame(minWidth: 350, idealWidth: 400, maxWidth: 500)
            
            // Panel de resultado
            resultPanel
                .frame(minWidth: 400)
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
    
    // MARK: - Config Panel
    
    private var configPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Label("Generar Documento", systemImage: "wand.and.stars")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Genera documentos con tu estilo de escritura usando IA")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                // Tema principal
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tema del documento")
                        .font(.headline)
                    
                    TextField("Ej: Implementación de patrones de diseño en Java", text: $tema, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...5)
                }
                
                // Tipo de documento
                VStack(alignment: .leading, spacing: 8) {
                    Toggle(isOn: $usarTipo) {
                        Text("Especificar tipo de documento")
                            .font(.headline)
                    }
                    
                    if usarTipo {
                        Picker("Tipo", selection: $tipoSeleccionado) {
                            ForEach(TipoDocumento.allCases) { tipo in
                                Label(tipo.rawValue.capitalized, systemImage: tipo.icono)
                                    .tag(tipo)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                // Contexto adicional
                DisclosureGroup(isExpanded: $mostrarContexto) {
                    TextEditor(text: $contextoAdicional)
                        .font(.body)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color(nsColor: .textBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } label: {
                    Text("Contexto adicional")
                        .font(.headline)
                }
                
                // Prompt personalizado
                DisclosureGroup(isExpanded: $usarPromptPersonalizado) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("El prompt personalizado reemplaza las instrucciones automáticas")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextEditor(text: $promptPersonalizado)
                            .font(.body)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color(nsColor: .textBackgroundColor))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                } label: {
                    Text("Prompt personalizado")
                        .font(.headline)
                }
                
                Divider()
                
                // Generación Múltiple
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(isOn: $generacionMultiple) {
                        HStack {
                            Image(systemName: "square.stack.3d.up.fill")
                            Text("Generación Múltiple")
                                .font(.headline)
                        }
                    }
                    
                    if generacionMultiple {
                        HStack {
                            Text("Cantidad:")
                                .font(.subheadline)
                            Picker("", selection: $numeroGeneraciones) {
                                ForEach(2...5, id: \.self) { n in
                                    Text("\(n)").tag(n)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 150)
                        }
                        
                        Toggle(isOn: $randomizarParametros) {
                            Text("Randomizar parámetros entre generaciones")
                                .font(.subheadline)
                        }
                        
                        if randomizarParametros {
                            Text("Los parámetros variarán aleatoriamente para obtener resultados diversos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Divider()
                
                // Parámetros básicos
                VStack(alignment: .leading, spacing: 16) {
                    Text("Parámetros")
                        .font(.headline)
                    
                    // Temperatura
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Temperatura")
                            Spacer()
                            Text(String(format: "%.2f", temperatura))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                        .font(.subheadline)
                        
                        Slider(value: $temperatura, in: 0...1, step: 0.05)
                        
                        HStack {
                            Text("Más preciso")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            Spacer()
                            Text("Más creativo")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    
                    // Max tokens
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Longitud máxima")
                            Spacer()
                            Text("\(Int(maxTokens)) tokens")
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                        .font(.subheadline)
                        
                        Slider(value: $maxTokens, in: 1000...32768, step: 1000)
                    }
                    
                    // Parámetros avanzados
                    DisclosureGroup(isExpanded: $mostrarParametrosAvanzados) {
                        VStack(alignment: .leading, spacing: 12) {
                            // Top P
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Top P (Nucleus)")
                                    Spacer()
                                    Text(String(format: "%.2f", topP))
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                }
                                .font(.subheadline)
                                Slider(value: $topP, in: 0...1, step: 0.05)
                            }
                            
                            // Frequency Penalty
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Penalización Frecuencia")
                                    Spacer()
                                    Text(String(format: "%.1f", frequencyPenalty))
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                }
                                .font(.subheadline)
                                Slider(value: $frequencyPenalty, in: -2...2, step: 0.1)
                            }
                            
                            // Presence Penalty
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Penalización Presencia")
                                    Spacer()
                                    Text(String(format: "%.1f", presencePenalty))
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                }
                                .font(.subheadline)
                                Slider(value: $presencePenalty, in: -2...2, step: 0.1)
                            }
                        }
                        .padding(.top, 8)
                    } label: {
                        Text("Parámetros avanzados")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer(minLength: 20)
                
                // Botón de generar
                Button {
                    if generacionMultiple {
                        generarMultiple()
                    } else {
                        generarDocumento()
                    }
                } label: {
                    HStack {
                        if isGenerating {
                            ProgressView()
                                .scaleEffect(0.8)
                            if generacionMultiple {
                                Text("Generando \(progresoGeneracion)/\(numeroGeneraciones)...")
                            } else {
                                Text("Generando...")
                            }
                        } else {
                            Image(systemName: "sparkles")
                            Text(generacionMultiple ? "Generar \(numeroGeneraciones) Documentos" : "Generar Documento")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(tema.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isGenerating)
            }
            .padding(24)
        }
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
    }
    
    // MARK: - Result Panel
    
    private var resultPanel: some View {
        VStack(spacing: 0) {
            resultToolbar
            Divider()
            resultContent
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
    
    @ViewBuilder
    private var resultToolbar: some View {
        HStack {
            if generacionMultiple && !resultadosMultiples.isEmpty {
                Text("Resultados (\(resultadosMultiples.count))")
                    .font(.headline)
            } else {
                Text("Resultado")
                    .font(.headline)
            }
            
            Spacer()
            
            resultToolbarButtons
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
    }
    
    @ViewBuilder
    private var resultToolbarButtons: some View {
        if generacionMultiple && !resultadosMultiples.isEmpty {
            if let selected = resultadoSeleccionado,
               let resultado = resultadosMultiples.first(where: { $0.id == selected }) {
                Button {
                    copiarResultadoMultiple(resultado.contenido)
                } label: {
                    Label("Copiar", systemImage: "doc.on.clipboard")
                }
                
                Button {
                    guardarResultadoMultiple(resultado.contenido)
                } label: {
                    Label("Guardar", systemImage: "square.and.arrow.down")
                }
                .buttonStyle(.borderedProminent)
            }
        } else if !resultadoGenerado.isEmpty {
            Button {
                copiarResultado()
            } label: {
                Label("Copiar", systemImage: "doc.on.clipboard")
            }
            
            Button {
                guardarComoDocumento()
            } label: {
                Label("Guardar", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    private var resultContent: some View {
        if isGenerating {
            loadingView
        } else if let error = errorGeneracion {
            errorView(error)
        } else if generacionMultiple && !resultadosMultiples.isEmpty {
            multipleResultsView
        } else if resultadoGenerado.isEmpty && resultadosMultiples.isEmpty {
            emptyResultView
        } else {
            singleResultView
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            if generacionMultiple {
                Text("Generando resultado \(progresoGeneracion) de \(numeroGeneraciones)...")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            } else {
                Text("Generando documento con IA...")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            Text("Esto puede tomar unos segundos")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            
            Text("Error al generar")
                .font(.headline)
            
            Text(error)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Reintentar") {
                errorGeneracion = nil
                if generacionMultiple {
                    generarMultiple()
                } else {
                    generarDocumento()
                }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .frame(width: 180)
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
            .padding(12)
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
                    .padding(24)
            }
        } else {
            VStack {
                Text("Selecciona un resultado")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var emptyResultView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.quaternary)
            
            Text("Documento generado")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Configura los parámetros y haz clic en Generar")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var singleResultView: some View {
        ScrollView {
            Text(resultadoGenerado)
                .font(.body)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
        }
    }
    
    // MARK: - Actions
    
    private func generarDocumento() {
        isGenerating = true
        errorGeneracion = nil
        resultadosMultiples = []
        
        let parametros = ParametrosGeneracion(
            tema: tema,
            tipo: usarTipo ? tipoSeleccionado.rawValue : nil,
            contextoAdicional: mostrarContexto && !contextoAdicional.isEmpty ? contextoAdicional : nil,
            promptPersonalizado: usarPromptPersonalizado && !promptPersonalizado.isEmpty ? promptPersonalizado : nil,
            temperatura: temperatura,
            maxTokens: Int(maxTokens),
            topP: topP,
            frequencyPenalty: frequencyPenalty,
            presencePenalty: presencePenalty
        )
        
        Task {
            do {
                let resultado = try await pythonBridge.generarDocumento(parametros: parametros)
                await MainActor.run {
                    resultadoGenerado = resultado
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    errorGeneracion = error.localizedDescription
                    isGenerating = false
                }
            }
        }
    }
    
    private func generarMultiple() {
        isGenerating = true
        errorGeneracion = nil
        resultadosMultiples = []
        resultadoSeleccionado = nil
        progresoGeneracion = 0
        
        Task {
            for i in 1...numeroGeneraciones {
                await MainActor.run {
                    progresoGeneracion = i
                }
                
                // Generar parámetros (randomizados o fijos)
                let params: (temp: Double, topP: Double, freqP: Double, presP: Double)
                if randomizarParametros {
                    params = (
                        temp: Double.random(in: 0.3...1.0),
                        topP: Double.random(in: 0.7...1.0),
                        freqP: Double.random(in: -0.5...1.0),
                        presP: Double.random(in: -0.5...1.0)
                    )
                } else {
                    params = (temp: temperatura, topP: topP, freqP: frequencyPenalty, presP: presencePenalty)
                }
                
                let parametros = ParametrosGeneracion(
                    tema: tema,
                    tipo: usarTipo ? tipoSeleccionado.rawValue : nil,
                    contextoAdicional: mostrarContexto && !contextoAdicional.isEmpty ? contextoAdicional : nil,
                    promptPersonalizado: usarPromptPersonalizado && !promptPersonalizado.isEmpty ? promptPersonalizado : nil,
                    temperatura: params.temp,
                    maxTokens: Int(maxTokens),
                    topP: params.topP,
                    frequencyPenalty: params.freqP,
                    presencePenalty: params.presP
                )
                
                do {
                    let resultado = try await pythonBridge.generarDocumento(parametros: parametros)
                    let paramsString = String(format: "T:%.2f P:%.2f F:%.1f", params.temp, params.topP, params.freqP)
                    let newResult = (id: UUID(), contenido: resultado, params: paramsString)
                    
                    await MainActor.run {
                        resultadosMultiples.append(newResult)
                        if resultadoSeleccionado == nil {
                            resultadoSeleccionado = newResult.id
                        }
                    }
                } catch {
                    await MainActor.run {
                        errorGeneracion = "Error en generación \(i): \(error.localizedDescription)"
                        isGenerating = false
                    }
                    return
                }
            }
            
            await MainActor.run {
                isGenerating = false
            }
        }
    }
    
    private func copiarResultado() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(resultadoGenerado, forType: .string)
    }
    
    private func copiarResultadoMultiple(_ contenido: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(contenido, forType: .string)
    }
    
    private func guardarComoDocumento() {
        let documento = pythonBridge.parsearDocumento(texto: resultadoGenerado, tema: tema)
        appState.documentos.insert(documento, at: 0)
        appState.documentoSeleccionado = documento
        appState.navegarA(.documentos)
    }
    
    private func guardarResultadoMultiple(_ contenido: String) {
        let documento = pythonBridge.parsearDocumento(texto: contenido, tema: tema)
        appState.documentos.insert(documento, at: 0)
        appState.documentoSeleccionado = documento
        appState.navegarA(.documentos)
    }
}

// MARK: - Preview

#Preview {
    GeneratorView()
        .environmentObject(AppState())
        .frame(width: 900, height: 700)
}
