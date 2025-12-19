import SwiftUI

/// Vista principal de la aplicación con NavigationSplitView
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.seccionActual == .documentos {
                // Vista de 3 columnas para documentos
                NavigationSplitView {
                    SidebarView()
                } content: {
                    contentView
                } detail: {
                    detailView
                }
                .navigationSplitViewStyle(.balanced)
            } else {
                // Vista de 2 columnas para generador y transformador
                NavigationSplitView {
                    SidebarView()
                } detail: {
                    contentView
                }
                .navigationSplitViewStyle(.balanced)
            }
        }
        .animation(nil, value: appState.seccionActual)
        .transaction { transaction in
            transaction.animation = nil
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .overlay {
            if appState.isLoading {
                LoadingOverlay()
            }
        }
        .alert("Error", isPresented: .constant(appState.errorMessage != nil)) {
            Button("OK") {
                appState.errorMessage = nil
            }
        } message: {
            if let error = appState.errorMessage {
                Text(error)
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch appState.seccionActual {
        case .documentos:
            DocumentListView()
        case .generador:
            GeneratorView()
        case .transformador:
            TransformerView()
        }
    }
    
    @ViewBuilder
    private var detailView: some View {
        switch appState.seccionActual {
        case .documentos:
            if let documento = appState.documentoSeleccionado {
                DocumentDetailView(documento: binding(for: documento))
            } else {
                EmptyDetailView(
                    icono: "doc.text",
                    titulo: "Selecciona un documento",
                    subtitulo: "Elige un documento de la lista o crea uno nuevo"
                )
            }
        case .generador, .transformador:
            // No mostrar panel derecho para estas secciones - ya tienen su propia UI completa
            EmptyView()
        }
    }
    
    private func binding(for documento: Documento) -> Binding<Documento> {
        Binding(
            get: { documento },
            set: { newValue in
                if let index = appState.documentos.firstIndex(where: { $0.id == documento.id }) {
                    appState.documentos[index] = newValue
                    appState.documentoSeleccionado = newValue
                }
            }
        )
    }
}

// MARK: - Loading Overlay

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(.circular)
                
                Text("Cargando...")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(32)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - Empty Detail View

struct EmptyDetailView: View {
    let icono: String
    let titulo: String
    let subtitulo: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icono)
                .font(.system(size: 64))
                .foregroundStyle(.quaternary)
            
            Text(titulo)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text(subtitulo)
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(AppState())
        .frame(width: 1200, height: 800)
}
