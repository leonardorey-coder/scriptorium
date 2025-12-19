import Foundation

/// Modelo que representa un documento académico
struct Documento: Identifiable, Codable, Equatable, Hashable {
    var id: String
    var titulo: String
    var tipo: String
    var materia: String
    var presenta: String
    var profesor: String
    var introduccion: String
    var desarrollo: String
    var conclusion: String
    
    /// Nombre del archivo JSON (null para documentos nuevos no guardados)
    var nombreArchivo: String?
    
    /// Fecha de última modificación
    var fechaModificacion: Date?
    
    // MARK: - Computed Properties
    
    var esNuevo: Bool {
        nombreArchivo == nil
    }
    
    var resumen: String {
        let texto = introduccion.isEmpty ? desarrollo : introduccion
        let maxChars = 150
        if texto.count > maxChars {
            return String(texto.prefix(maxChars)) + "..."
        }
        return texto
    }
    
    var tipoFormateado: String {
        tipo.isEmpty ? "Sin tipo" : tipo.capitalized
    }
    
    var materiaFormateada: String {
        materia.isEmpty ? "Sin materia" : materia.capitalized
    }
    
    // MARK: - Inicializadores
    
    init(
        id: String = UUID().uuidString,
        titulo: String = "",
        tipo: String = "",
        materia: String = "",
        presenta: String = "",
        profesor: String = "",
        introduccion: String = "",
        desarrollo: String = "",
        conclusion: String = "",
        nombreArchivo: String? = nil,
        fechaModificacion: Date? = nil
    ) {
        self.id = id
        self.titulo = titulo
        self.tipo = tipo
        self.materia = materia
        self.presenta = presenta
        self.profesor = profesor
        self.introduccion = introduccion
        self.desarrollo = desarrollo
        self.conclusion = conclusion
        self.nombreArchivo = nombreArchivo
        self.fechaModificacion = fechaModificacion
    }
    
    // MARK: - Métodos
    
    /// Convierte el documento a texto completo
    func textoCompleto() -> String {
        """
        Título: \(titulo)
        Tipo: \(tipo)
        Materia: \(materia)
        Presenta: \(presenta)
        Profesor: \(profesor)
        
        Introducción:
        \(introduccion)
        
        Desarrollo:
        \(desarrollo)
        
        Conclusión:
        \(conclusion)
        """
    }
    
    /// Valida que el documento tenga los campos mínimos
    var esValido: Bool {
        !titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Preview Helpers

extension Documento {
    static var ejemplo: Documento {
        Documento(
            id: "1",
            titulo: "Algoritmos de Ordenamiento en Java",
            tipo: "práctica",
            materia: "Programación",
            presenta: "Leonardo Cruz",
            profesor: "Prof. García",
            introduccion: "En esta práctica se analizarán los principales algoritmos de ordenamiento implementados en Java...",
            desarrollo: "Los algoritmos de ordenamiento son fundamentales en ciencias de la computación...",
            conclusion: "Se concluye que cada algoritmo tiene sus ventajas dependiendo del contexto...",
            nombreArchivo: "algoritmos_ordenamiento.json",
            fechaModificacion: Date()
        )
    }
    
    static var ejemplos: [Documento] {
        [
            ejemplo,
            Documento(
                id: "2",
                titulo: "Patrones de Diseño",
                tipo: "investigación",
                materia: "Ingeniería de Software",
                presenta: "Leonardo Cruz",
                profesor: "Prof. Martínez",
                introduccion: "Los patrones de diseño representan soluciones probadas...",
                desarrollo: "El patrón Singleton garantiza una única instancia...",
                conclusion: "Los patrones de diseño son herramientas esenciales...",
                nombreArchivo: "patrones_diseno.json",
                fechaModificacion: Date().addingTimeInterval(-86400)
            ),
            Documento(
                id: "3",
                titulo: "Bases de Datos NoSQL",
                tipo: "ensayo",
                materia: "Bases de Datos",
                presenta: "Leonardo Cruz",
                profesor: "Prof. López",
                introduccion: "Las bases de datos NoSQL han revolucionado el almacenamiento...",
                desarrollo: "MongoDB, como base de datos documental...",
                conclusion: "NoSQL ofrece flexibilidad pero requiere consideración cuidadosa...",
                nombreArchivo: "nosql.json",
                fechaModificacion: Date().addingTimeInterval(-172800)
            )
        ]
    }
}
