import SwiftUI

/// Barra lateral de navegación
struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    @State private var hoveredSection: SeccionNavegacion?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            Divider()
                .padding(.horizontal)
            
            // Navegación principal
            VStack(spacing: 8) {
                ForEach(SeccionNavegacion.allCases) { seccion in
                    SidebarButton(
                        seccion: seccion,
                        isSelected: appState.seccionActual == seccion,
                        isHovered: hoveredSection == seccion
                    ) {
                        appState.navegarA(seccion)
                    }
                    .onHover { isHovered in
                        hoveredSection = isHovered ? seccion : nil
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            
            Spacer()
            
            Divider()
                .padding(.horizontal)
            
            // Footer con estadísticas
            footerView
        }
        .frame(minWidth: 230, idealWidth: 250, maxWidth: 280)
        .background(Color(nsColor: .controlBackgroundColor))
    }
    
    private var headerView: some View {
        HStack(spacing: 12) {
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("MisDocumentos")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Sistema RAG")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var footerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundStyle(.secondary)
                Text("\(appState.documentos.count) documentos")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                appState.importarDocumento()
            } label: {
                Label("Importar Archivo", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Button {
                appState.crearNuevoDocumento()
            } label: {
                Label("Nuevo Documento", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)
        }
        .padding()
    }
}

// MARK: - Sidebar Button

struct SidebarButton: View {
    let seccion: SeccionNavegacion
    let isSelected: Bool
    let isHovered: Bool
    let action: () -> Void
    
    @State private var localHover = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: seccion.icono)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .frame(width: 24)
                
                Text(seccion.rawValue)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Spacer()
                
                if seccion == .documentos {
                    Text("⌘1")
                        .font(.caption2)
                        .foregroundStyle(isSelected ? Color.white.opacity(0.7) : Color.secondary.opacity(0.5))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(isSelected ? .white.opacity(0.2) : Color(nsColor: .quaternaryLabelColor).opacity(0.3))
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(borderColor, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            localHover = hovering
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: localHover)
    }
    
    private var effectiveHover: Bool {
        isHovered || localHover
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .accentColor
        } else if effectiveHover {
            return Color(nsColor: .controlBackgroundColor).opacity(0.8)
        } else {
            return .clear
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return .clear
        } else if effectiveHover {
            return Color.accentColor.opacity(0.5)
        } else {
            return .clear
        }
    }
}

// MARK: - Preview

#Preview {
    SidebarView()
        .environmentObject(AppState())
        .frame(height: 600)
}
