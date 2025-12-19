import SwiftUI
import Security

/// Vista de configuración de la aplicación
struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var config = RAGConfig.cargar()
    @State private var tokenVisible = false
    @State private var openRouterTokenVisible = false
    @State private var isSaving = false
    @State private var showingSaveSuccess = false
    @State private var testingConnection = false
    @State private var connectionStatus: ConnectionStatus?
    
    enum ConnectionStatus {
        case success
        case error(String)
    }
    
    var body: some View {
        TabView {
            generalTab
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            
            apiTab
                .tabItem {
                    Label("API", systemImage: "network")
                }
            
            aboutTab
                .tabItem {
                    Label("Acerca de", systemImage: "info.circle")
                }
        }
        .frame(width: 500, height: 400)
        .padding()
    }
    
    // MARK: - General Tab
    
    private var generalTab: some View {
        Form {
            Section("Documentos") {
                HStack {
                    TextField("Directorio de documentos", text: $config.directorioDocumentos)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Seleccionar...") {
                        seleccionarDirectorio()
                    }
                }
                
                Text("Ruta relativa desde el directorio del proyecto")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("Generación") {
                HStack {
                    Text("Temperatura por defecto")
                    Spacer()
                    Slider(value: $config.temperatura, in: 0...1, step: 0.05)
                        .frame(width: 150)
                    Text(String(format: "%.2f", config.temperatura))
                        .monospacedDigit()
                        .frame(width: 40)
                }
                
                HStack {
                    Text("Tokens máximos")
                    Spacer()
                    TextField("", value: $config.maxTokens, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }
            }
            
            saveButton
        }
        .formStyle(.grouped)
    }
    
    // MARK: - API Tab
    
    private var apiTab: some View {
        Form {
            Section("GitHub AI") {
                HStack {
                    if tokenVisible {
                        TextField("GITHUB_TOKEN", text: $config.githubToken)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("GITHUB_TOKEN", text: $config.githubToken)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button {
                        tokenVisible.toggle()
                    } label: {
                        Image(systemName: tokenVisible ? "eye.slash" : "eye")
                    }
                    .buttonStyle(.borderless)
                }
                
                Text("El token se almacena de forma segura en el Keychain de macOS")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("OpenRouter") {
                HStack {
                    if openRouterTokenVisible {
                        TextField("OPENROUTER_API_KEY", text: $config.openRouterApiKey)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("OPENROUTER_API_KEY", text: $config.openRouterApiKey)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button {
                        openRouterTokenVisible.toggle()
                    } label: {
                        Image(systemName: openRouterTokenVisible ? "eye.slash" : "eye")
                    }
                    .buttonStyle(.borderless)
                }
                
                Text("API key para usar modelos de OpenRouter")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("Endpoint") {
                TextField("URL del endpoint", text: $config.endpoint)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Nombre del modelo", text: $config.modelName)
                    .textFieldStyle(.roundedBorder)
            }
            
            Section("Verificar conexión") {
                HStack {
                    Button {
                        probarConexion()
                    } label: {
                        HStack {
                            if testingConnection {
                                ProgressView()
                                    .scaleEffect(0.7)
                            }
                            Text("Probar conexión")
                        }
                    }
                    .disabled(config.githubToken.isEmpty || testingConnection)
                    
                    Spacer()
                    
                    if let status = connectionStatus {
                        switch status {
                        case .success:
                            Label("Conexión exitosa", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        case .error(let message):
                            Label(message, systemImage: "xmark.circle.fill")
                                .foregroundStyle(.red)
                                .lineLimit(1)
                        }
                    }
                }
            }
            
            saveButton
        }
        .formStyle(.grouped)
    }
    
    // MARK: - About Tab
    
    private var aboutTab: some View {
        VStack(spacing: 24) {
            // Logo
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 8) {
                Text("MisDocumentos AI")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Versión 1.0.0")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Text("Sistema de generación de documentos con estilo personalizado usando RAG (Retrieval-Augmented Generation)")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Divider()
                .padding(.horizontal, 40)
            
            VStack(spacing: 8) {
                Text("Desarrollado con ❤️")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                
                HStack(spacing: 16) {
                    Link(destination: URL(string: "https://github.com")!) {
                        Label("GitHub", systemImage: "link")
                    }
                    
                    Link(destination: URL(string: "https://models.github.ai")!) {
                        Label("GitHub AI", systemImage: "sparkles")
                    }
                }
                .font(.caption)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Components
    
    private var saveButton: some View {
        HStack {
            Spacer()
            
            if showingSaveSuccess {
                Label("Guardado", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Button {
                guardarConfiguracion()
            } label: {
                if isSaving {
                    ProgressView()
                        .scaleEffect(0.7)
                } else {
                    Text("Guardar")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isSaving)
        }
    }
    
    // MARK: - Actions
    
    private func seleccionarDirectorio() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            config.directorioDocumentos = url.lastPathComponent
        }
    }
    
    private func guardarConfiguracion() {
        isSaving = true
        
        Task {
            do {
                // Guardar token en Keychain
                if !config.githubToken.isEmpty {
                    KeychainService.shared.saveToken(config.githubToken, for: "github_ai")
                }
                
                // Guardar OpenRouter API key en Keychain
                if !config.openRouterApiKey.isEmpty {
                    KeychainService.shared.saveToken(config.openRouterApiKey, for: "openrouter")
                }
                
                // Guardar resto de configuración
                try config.guardar()
                
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
    
    private func probarConexion() {
        testingConnection = true
        connectionStatus = nil
        
        Task {
            do {
                let success = try await PythonBridge.shared.verificarConexion(
                    token: config.githubToken,
                    endpoint: config.endpoint
                )
                await MainActor.run {
                    testingConnection = false
                    connectionStatus = success ? .success : .error("No se pudo conectar")
                }
            } catch {
                await MainActor.run {
                    testingConnection = false
                    connectionStatus = .error(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
