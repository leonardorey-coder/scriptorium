import Foundation

/// Configuración del sistema RAG
struct RAGConfig: Codable {
    var githubToken: String
    var openRouterApiKey: String
    var endpoint: String
    var modelName: String
    var temperatura: Double
    var maxTokens: Int
    var directorioDocumentos: String
    
    static let `default` = RAGConfig(
        githubToken: "",
        openRouterApiKey: "",
        endpoint: "https://models.github.ai/inference",
        modelName: "openai/gpt-4.1",
        temperatura: 0.7,
        maxTokens: 32768,
        directorioDocumentos: "documentos"
    )
    
    // MARK: - Persistence
    
    private static let configURL: URL = {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = appSupport.appendingPathComponent("Scriptorium", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        return appDir.appendingPathComponent("config.json")
    }()
    
    static func cargar() -> RAGConfig {
        guard FileManager.default.fileExists(atPath: configURL.path),
              let data = try? Data(contentsOf: configURL),
              let config = try? JSONDecoder().decode(RAGConfig.self, from: data) else {
            return .default
        }
        return config
    }
    
    func guardar() throws {
        let data = try JSONEncoder().encode(self)
        try data.write(to: Self.configURL)
    }
}

/// Parámetros para generar un documento
struct ParametrosGeneracion {
    var tema: String
    var tipo: String?
    var contextoAdicional: String?
    var promptPersonalizado: String?
    var temperatura: Double
    var maxTokens: Int
    var topP: Double
    var frequencyPenalty: Double
    var presencePenalty: Double
    
    init(
        tema: String,
        tipo: String? = nil,
        contextoAdicional: String? = nil,
        promptPersonalizado: String? = nil,
        temperatura: Double = 0.7,
        maxTokens: Int = 32768,
        topP: Double = 1.0,
        frequencyPenalty: Double = 0.0,
        presencePenalty: Double = 0.0
    ) {
        self.tema = tema
        self.tipo = tipo
        self.contextoAdicional = contextoAdicional
        self.promptPersonalizado = promptPersonalizado
        self.temperatura = temperatura
        self.maxTokens = maxTokens
        self.topP = topP
        self.frequencyPenalty = frequencyPenalty
        self.presencePenalty = presencePenalty
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "temperatura": temperatura,
            "max_tokens": maxTokens,
            "top_p": topP,
            "frequency_penalty": frequencyPenalty,
            "presence_penalty": presencePenalty
        ]
        if let tipo = tipo, !tipo.isEmpty {
            dict["tipo"] = tipo
        }
        if let contexto = contextoAdicional, !contexto.isEmpty {
            dict["contexto_adicional"] = contexto
        }
        if let prompt = promptPersonalizado, !prompt.isEmpty {
            dict["prompt_personalizado"] = prompt
        }
        return dict
    }
}

/// Tipos de documento predefinidos
enum TipoDocumento: String, CaseIterable, Identifiable {
    case practica = "práctica"
    case investigacion = "investigación"
    case ensayo = "ensayo"
    case reporte = "reporte"
    case manual = "manual"
    case otro = "otro"
    
    var id: String { rawValue }
    
    var icono: String {
        switch self {
        case .practica: return "hammer.fill"
        case .investigacion: return "magnifyingglass"
        case .ensayo: return "text.quote"
        case .reporte: return "chart.bar.doc.horizontal.fill"
        case .manual: return "book.fill"
        case .otro: return "doc.fill"
        }
    }
}
