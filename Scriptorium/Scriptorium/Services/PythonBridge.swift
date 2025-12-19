import Foundation

/// Servicio puente entre Swift y Python para el sistema RAG
/// Esta versión usa lectura directa de archivos JSON como fallback cuando Python no está disponible
class PythonBridge {
    static let shared = PythonBridge()
    
    private let projectPath: String
    private let documentosPath: String
    
    private init() {
        print("🚀 Inicializando PythonBridge...")
        projectPath = "/Users/leonardocruz/Documents/proyectos/misDocumentos_AI"
        documentosPath = projectPath + "/documentos"
        print("📂 Ruta documentos: \(documentosPath)")
    }
    
    // MARK: - Documentos (Implementación nativa Swift)
    
    func cargarDocumentos() async throws -> [Documento] {
        print("🔍 Cargando documentos...")
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    var documentos: [Documento] = []
                    let fileManager = FileManager.default
                    
                    // Buscar en directorio de documentos
                    let paths = [
                        self.documentosPath,
                        self.projectPath + "/rag"
                    ]
                    
                    for basePath in paths {
                        guard fileManager.fileExists(atPath: basePath) else { continue }
                        
                        let files = try fileManager.contentsOfDirectory(atPath: basePath)
                        for file in files where file.hasSuffix(".json") {
                            let filePath = basePath + "/" + file
                            if let data = fileManager.contents(atPath: filePath),
                               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                let documento = Documento(
                                    id: file,
                                    titulo: json["titulo"] as? String ?? "",
                                    tipo: json["tipo"] as? String ?? "",
                                    materia: json["materia"] as? String ?? "",
                                    presenta: json["presenta"] as? String ?? "",
                                    profesor: json["profesor"] as? String ?? "",
                                    introduccion: json["introduccion"] as? String ?? "",
                                    desarrollo: json["desarrollo"] as? String ?? "",
                                    conclusion: json["conclusion"] as? String ?? "",
                                    nombreArchivo: file,
                                    fechaModificacion: self.getFileModificationDate(filePath)
                                )
                                documentos.append(documento)
                            }
                        }
                    }
                    
                    print("✅ Cargados \(documentos.count) documentos")
                    continuation.resume(returning: documentos)
                } catch {
                    print("❌ Error cargando documentos: \(error)")
                    continuation.resume(throwing: PythonBridgeError.pythonError(error.localizedDescription))
                }
            }
        }
    }
    
    private func getFileModificationDate(_ path: String) -> Date? {
        try? FileManager.default.attributesOfItem(atPath: path)[.modificationDate] as? Date
    }
    
    func guardarDocumento(_ documento: Documento) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let docDict: [String: String] = [
                        "titulo": documento.titulo,
                        "tipo": documento.tipo,
                        "materia": documento.materia,
                        "presenta": documento.presenta,
                        "profesor": documento.profesor,
                        "introduccion": documento.introduccion,
                        "desarrollo": documento.desarrollo,
                        "conclusion": documento.conclusion
                    ]
                    
                    let data = try JSONSerialization.data(withJSONObject: docDict, options: [.prettyPrinted, .sortedKeys])
                    
                    // Generar nombre de archivo si es nuevo
                    let nombreArchivo = documento.nombreArchivo ?? {
                        let titulo = documento.titulo.lowercased()
                            .replacingOccurrences(of: " ", with: "_")
                            .prefix(50)
                        return String(titulo) + ".json"
                    }()
                    
                    let filePath = self.documentosPath + "/" + nombreArchivo
                    
                    // Crear directorio si no existe
                    try FileManager.default.createDirectory(
                        atPath: self.documentosPath,
                        withIntermediateDirectories: true
                    )
                    
                    try data.write(to: URL(fileURLWithPath: filePath))
                    
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: PythonBridgeError.pythonError(error.localizedDescription))
                }
            }
        }
    }
    
    func eliminarDocumento(_ documento: Documento) async throws {
        guard let nombreArchivo = documento.nombreArchivo else {
            throw PythonBridgeError.invalidDocument
        }
        
        let filePath = documentosPath + "/" + nombreArchivo
        try FileManager.default.removeItem(atPath: filePath)
    }
    
    // MARK: - Importar Documento desde Archivo
    
    func importarDocumentoDesdeArchivo(url: URL) async throws -> Documento {
        let fileExtension = url.pathExtension.lowercased()
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    var contenido: String = ""
                    
                    switch fileExtension {
                    case "txt":
                        // Leer archivo de texto directamente
                        contenido = try String(contentsOf: url, encoding: .utf8)
                        
                    case "docx":
                        // Usar script Python para extraer texto de DOCX
                        contenido = try self.extraerTextoDOCX(url: url)
                        
                    default:
                        throw PythonBridgeError.pythonError("Formato de archivo no soportado: .\(fileExtension). Use .txt o .docx")
                    }
                    
                    // Parsear el contenido y crear documento
                    let documento = self.parsearDocumento(texto: contenido, tema: url.deletingPathExtension().lastPathComponent)
                    continuation.resume(returning: documento)
                    
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func extraerTextoDOCX(url: URL) throws -> String {
        // Intentar usar python-docx para extraer texto
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/Library/Frameworks/Python.framework/Versions/3.12/bin/python3")
        
        // Script inline para extraer texto de DOCX
        let pythonScript = """
        import sys
        try:
            from docx import Document
            doc = Document(sys.argv[1])
            text = []
            for para in doc.paragraphs:
                text.append(para.text)
            print('\\n'.join(text))
        except ImportError:
            # Fallback: extraer XML directamente del DOCX (es un ZIP)
            import zipfile
            import xml.etree.ElementTree as ET
            with zipfile.ZipFile(sys.argv[1], 'r') as z:
                xml_content = z.read('word/document.xml')
                tree = ET.fromstring(xml_content)
                ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
                texts = []
                for elem in tree.iter():
                    if elem.tag.endswith('}t'):
                        if elem.text:
                            texts.append(elem.text)
                print(' '.join(texts))
        """
        
        process.arguments = ["-c", pythonScript, url.path]
        process.currentDirectoryURL = URL(fileURLWithPath: projectPath)
        
        let pipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = pipe
        process.standardError = errorPipe
        
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus != 0 {
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let errorOutput = String(data: errorData, encoding: .utf8) ?? "Error al procesar DOCX"
            throw PythonBridgeError.pythonError(errorOutput)
        }
        
        let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: outputData, encoding: .utf8) ?? ""
    }
    
    // MARK: - Generación RAG (Llamada al script Python)
    
    func generarDocumento(parametros: ParametrosGeneracion) async throws -> String {
        // Obtener token
        guard let token = KeychainService.shared.getToken(for: "github_ai") ??
              ProcessInfo.processInfo.environment["GITHUB_TOKEN"],
              !token.isEmpty else {
            throw PythonBridgeError.tokenNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    // Construir argumentos para el script
                    var args = [
                        "/Library/Frameworks/Python.framework/Versions/3.12/bin/python3",
                        self.projectPath + "/generar_documento.py",
                        parametros.tema
                    ]
                    
                    if let tipo = parametros.tipo, !tipo.isEmpty {
                        args.append("--tipo")
                        args.append(tipo)
                    }
                    
                    args.append("--temperatura")
                    args.append(String(parametros.temperatura))
                    
                    args.append("--max-tokens")
                    args.append(String(parametros.maxTokens))
                    
                    args.append("--top-p")
                    args.append(String(parametros.topP))
                    
                    args.append("--frequency-penalty")
                    args.append(String(parametros.frequencyPenalty))
                    
                    args.append("--presence-penalty")
                    args.append(String(parametros.presencePenalty))
                    
                    if let contexto = parametros.contextoAdicional, !contexto.isEmpty {
                        args.append("--contexto-texto")
                        args.append(contexto)
                    }
                    
                    if let prompt = parametros.promptPersonalizado, !prompt.isEmpty {
                        args.append("--prompt-texto")
                        args.append(prompt)
                    }
                    
                    // Ejecutar proceso
                    let process = Process()
                    process.executableURL = URL(fileURLWithPath: args[0])
                    process.arguments = Array(args.dropFirst())
                    process.currentDirectoryURL = URL(fileURLWithPath: self.projectPath)
                    process.environment = ProcessInfo.processInfo.environment
                    process.environment?["GITHUB_TOKEN"] = token
                    
                    let pipe = Pipe()
                    let errorPipe = Pipe()
                    process.standardOutput = pipe
                    process.standardError = errorPipe
                    
                    try process.run()
                    process.waitUntilExit()
                    
                    let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
                    let output = String(data: outputData, encoding: .utf8) ?? ""
                    
                    if process.terminationStatus != 0 {
                        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                        let errorOutput = String(data: errorData, encoding: .utf8) ?? "Error desconocido"
                        throw PythonBridgeError.pythonError(errorOutput)
                    }
                    
                    // Extraer el documento generado del output
                    if let range = output.range(of: "=============== DOCUMENTO GENERADO ===============") {
                        let startIndex = output.index(range.upperBound, offsetBy: 1, limitedBy: output.endIndex) ?? range.upperBound
                        if let endRange = output.range(of: "=================================================", range: startIndex..<output.endIndex) {
                            let documento = String(output[startIndex..<endRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                            continuation.resume(returning: documento)
                            return
                        }
                    }
                    
                    // Si no encontramos los delimitadores, devolver todo el output
                    continuation.resume(returning: output)
                } catch {
                    continuation.resume(throwing: PythonBridgeError.pythonError(error.localizedDescription))
                }
            }
        }
    }
    
    // MARK: - Transformación
    
    func transformarTexto(texto: String, contextoAdicional: String?, temperatura: Double) async throws -> String {
        // Obtener token
        guard let token = KeychainService.shared.getToken(for: "github_ai") ??
              ProcessInfo.processInfo.environment["GITHUB_TOKEN"],
              !token.isEmpty else {
            throw PythonBridgeError.tokenNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    // Crear archivo temporal con el texto
                    let tempDir = FileManager.default.temporaryDirectory
                    let inputFile = tempDir.appendingPathComponent("input_\(UUID().uuidString).txt")
                    try texto.write(to: inputFile, atomically: true, encoding: .utf8)
                    
                    // Construir argumentos
                    var args = [
                        "/Library/Frameworks/Python.framework/Versions/3.12/bin/python3",
                        self.projectPath + "/transformar_texto.py",
                        inputFile.path
                    ]
                    
                    args.append("--temperatura")
                    args.append(String(temperatura))
                    
                    if let contexto = contextoAdicional, !contexto.isEmpty {
                        args.append("--contexto-texto")
                        args.append(contexto)
                    }
                    
                    // Ejecutar proceso
                    let process = Process()
                    process.executableURL = URL(fileURLWithPath: args[0])
                    process.arguments = Array(args.dropFirst())
                    process.currentDirectoryURL = URL(fileURLWithPath: self.projectPath)
                    process.environment = ProcessInfo.processInfo.environment
                    process.environment?["GITHUB_TOKEN"] = token
                    
                    let pipe = Pipe()
                    let errorPipe = Pipe()
                    process.standardOutput = pipe
                    process.standardError = errorPipe
                    
                    try process.run()
                    process.waitUntilExit()
                    
                    // Limpiar archivo temporal
                    try? FileManager.default.removeItem(at: inputFile)
                    
                    let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
                    let output = String(data: outputData, encoding: .utf8) ?? ""
                    
                    if process.terminationStatus != 0 {
                        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                        let errorOutput = String(data: errorData, encoding: .utf8) ?? "Error desconocido"
                        throw PythonBridgeError.pythonError(errorOutput)
                    }
                    
                    // Extraer el texto transformado
                    if let range = output.range(of: "=============== TEXTO TRANSFORMADO ===============") {
                        let startIndex = output.index(range.upperBound, offsetBy: 1, limitedBy: output.endIndex) ?? range.upperBound
                        if let endRange = output.range(of: "=================================================", range: startIndex..<output.endIndex) {
                            let resultado = String(output[startIndex..<endRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                            continuation.resume(returning: resultado)
                            return
                        }
                    }
                    
                    continuation.resume(returning: output)
                } catch {
                    continuation.resume(throwing: PythonBridgeError.pythonError(error.localizedDescription))
                }
            }
        }
    }
    
    // MARK: - Utilidades
    
    func parsearDocumento(texto: String, tema: String) -> Documento {
        let patrones: [(String, String)] = [
            ("titulo", #"T[ií]tulo:?\s*(.+?)(?:\n|$)"#),
            ("tipo", #"Tipo:?\s*(.+?)(?:\n|$)"#),
            ("materia", #"Materia:?\s*(.+?)(?:\n|$)"#),
            ("presenta", #"Presenta:?\s*(.+?)(?:\n|$)"#),
            ("profesor", #"Profesor:?\s*(.+?)(?:\n|$)"#),
            ("introduccion", #"Introducci[oó]n:?\s*([\s\S]+?)(?=Desarrollo:|Conclusi[oó]n:|$)"#),
            ("desarrollo", #"Desarrollo:?\s*([\s\S]+?)(?=Conclusi[oó]n:|$)"#),
            ("conclusion", #"Conclusi[oó]n:?\s*([\s\S]+)$"#)
        ]
        
        var campos: [String: String] = [:]
        
        for (campo, patron) in patrones {
            if let regex = try? NSRegularExpression(pattern: patron, options: [.caseInsensitive]),
               let match = regex.firstMatch(in: texto, options: [], range: NSRange(texto.startIndex..., in: texto)),
               let range = Range(match.range(at: 1), in: texto) {
                campos[campo] = String(texto[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        return Documento(
            id: UUID().uuidString,
            titulo: campos["titulo"] ?? tema,
            tipo: campos["tipo"] ?? "",
            materia: campos["materia"] ?? "",
            presenta: campos["presenta"] ?? "",
            profesor: campos["profesor"] ?? "",
            introduccion: campos["introduccion"] ?? "",
            desarrollo: campos["desarrollo"] ?? "",
            conclusion: campos["conclusion"] ?? "",
            nombreArchivo: nil,
            fechaModificacion: Date()
        )
    }
    
    func verificarConexion(token: String, endpoint: String) async throws -> Bool {
        // Hacer una petición simple para verificar el token
        guard let url = URL(string: endpoint + "/v1/models") else {
            return false
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            return false
        } catch {
            return false
        }
    }
}

// MARK: - Errors

enum PythonBridgeError: LocalizedError {
    case moduleNotLoaded
    case tokenNotFound
    case invalidDocument
    case invalidResponse
    case pythonError(String)
    
    var errorDescription: String? {
        switch self {
        case .moduleNotLoaded:
            return "No se pudieron cargar los módulos Python. Verifica que Python esté instalado correctamente."
        case .tokenNotFound:
            return "No se encontró el token de GitHub AI. Configúralo en Preferencias o establece la variable GITHUB_TOKEN."
        case .invalidDocument:
            return "El documento no es válido para esta operación."
        case .invalidResponse:
            return "La respuesta de la IA no pudo ser procesada."
        case .pythonError(let message):
            return "Error: \(message)"
        }
    }
}
