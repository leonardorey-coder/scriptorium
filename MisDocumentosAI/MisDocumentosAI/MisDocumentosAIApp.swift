import SwiftUI
import AppKit
import UniformTypeIdentifiers

@main
struct MisDocumentosAIApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        print("📱 App iniciando...")
        #if os(macOS)
        // Forzar política de activación para que la ventana aparezca al correr desde terminal
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .frame(minWidth: 1000, minHeight: 700)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Nuevo Documento") {
                    appState.crearNuevoDocumento()
                }
                .keyboardShortcut("n", modifiers: .command)
                
                Divider()
                
                Button("Generar con IA") {
                    appState.navegarA(.generador)
                }
                .keyboardShortcut("g", modifiers: [.command, .shift])
            }
            
            CommandGroup(after: .sidebar) {
                Button("Mostrar Documentos") {
                    appState.navegarA(.documentos)
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("Mostrar Generador") {
                    appState.navegarA(.generador)
                }
                .keyboardShortcut("2", modifiers: .command)
                
                Button("Mostrar Transformador") {
                    appState.navegarA(.transformador)
                }
                .keyboardShortcut("3", modifiers: .command)
            }
        }
        
        Settings {
            SettingsView()
                .environmentObject(appState)
        }
    }
}

// MARK: - Estado Global de la App

enum SeccionNavegacion: String, CaseIterable, Identifiable {
    case documentos = "Documentos"
    case generador = "Generar"
    case transformador = "Transformar"
    
    var id: String { rawValue }
    
    var icono: String {
        switch self {
        case .documentos: return "doc.text.fill"
        case .generador: return "wand.and.stars"
        case .transformador: return "arrow.triangle.2.circlepath"
        }
    }
}

@MainActor
class AppState: ObservableObject {
    @Published var seccionActual: SeccionNavegacion = .documentos
    @Published var documentoSeleccionado: Documento?
    @Published var documentos: [Documento] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let pythonBridge = PythonBridge.shared
    
    init() {
        Task {
            await cargarDocumentos()
        }
    }
    
    func navegarA(_ seccion: SeccionNavegacion) {
        withAnimation(.spring(response: 0.3)) {
            seccionActual = seccion
        }
    }
    
    func cargarDocumentos() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            documentos = try await pythonBridge.cargarDocumentos()
        } catch {
            errorMessage = "Error cargando documentos: \(error.localizedDescription)"
        }
    }
    
    func crearNuevoDocumento() {
        let nuevoDoc = Documento(
            id: UUID().uuidString,
            titulo: "Nuevo Documento",
            tipo: "",
            materia: "",
            presenta: "",
            profesor: "",
            introduccion: "",
            desarrollo: "",
            conclusion: ""
        )
        documentos.insert(nuevoDoc, at: 0)
        documentoSeleccionado = nuevoDoc
        navegarA(.documentos)
    }
    
    func guardarDocumento(_ documento: Documento) async throws {
        try await pythonBridge.guardarDocumento(documento)
        if let index = documentos.firstIndex(where: { $0.id == documento.id }) {
            documentos[index] = documento
        }
    }
    
    func eliminarDocumento(_ documento: Documento) async throws {
        try await pythonBridge.eliminarDocumento(documento)
        documentos.removeAll { $0.id == documento.id }
        if documentoSeleccionado?.id == documento.id {
            documentoSeleccionado = nil
        }
    }
    
    func importarDocumento() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [
            .plainText,
            UTType(filenameExtension: "docx") ?? .data
        ]
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.message = "Selecciona archivos TXT o DOCX para importar"
        
        if panel.runModal() == .OK {
            Task {
                isLoading = true
                for url in panel.urls {
                    do {
                        let documento = try await pythonBridge.importarDocumentoDesdeArchivo(url: url)
                        try await pythonBridge.guardarDocumento(documento)
                        documentos.insert(documento, at: 0)
                        documentoSeleccionado = documento
                    } catch {
                        errorMessage = "Error importando \(url.lastPathComponent): \(error.localizedDescription)"
                    }
                }
                isLoading = false
                navegarA(.documentos)
            }
        }
    }
}
