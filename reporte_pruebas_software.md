# **Reporte de Pruebas de Software**

**Universidad Politécnica de Quintana Roo**  
**Reporte de Pruebas de Software**  
**Presenta:** CRUZ FLORES JUAN LEONARDO  
**Carrera:** Ingeniería en Software  
**Profesor:** Juan Carlos Mejía Guzmán  
**Asignatura:** Pruebas de Software 27CV  
**Período:** Septiembre - Noviembre 2025  
**Fecha de entrega:** 12/11/2025  
*(logo de la universidad aquí)*

---

## **Índice**

1. Introducción .................................................................................. 1  
2. Capítulo 1: Conceptos Fundamentales de Pruebas de Software .......... 4  
3. Capítulo 2: Momentos de Ejecución de Pruebas ............................... 9  
4. Capítulo 3: Tipos de Pruebas ..................................................... 13  
5. Capítulo 4: Casos de Prueba y Diseño ........................................ 19  
6. Capítulo 5: Ejecución de Pruebas Manuales ................................ 24  
7. Capítulo 6: Reportes de Defectos de Software ............................. 29  
8. Capítulo 7: Buenas Prácticas en Testing ..................................... 34  
9. Capítulo 8: Estándares y Formatos Certificados ............................ 39  
10. Capítulo 9: Experiencias Prácticas del Curso .............................. 43  
11. Conclusiones ............................................................................. 48  
12. Glosario Técnico ......................................................................... 52  
13. Referencias ............................................................................... 55

---

## **Introducción**

Las pruebas de software son una de las etapas más importantes en el desarrollo de aplicaciones y sistemas, ya que de ellas depende en gran medida la calidad, funcionalidad, seguridad y experiencia del usuario final. Este reporte busca detallar y mostrar todo lo aprendido durante el curso de Pruebas de Software, abordando desde los conceptos más básicos hasta los procesos avanzados y los estándares internacionales que rigen la disciplina. El objetivo principal de este documento es plasmar de manera explícita y detallada el conocimiento adquirido, las experiencias prácticas y las lecciones aprendidas, cumpliendo con los requisitos del curso y aportando una visión integral sobre el proceso de testing en la industria actual.

Durante el semestre, a través de clases teóricas, dinámicas grupales, proyectos prácticos y el análisis de casos reales, se ha logrado comprender la importancia crítica de realizar pruebas en cada fase del ciclo de vida del software. El propósito de las pruebas no solo radica en encontrar errores, sino en garantizar que el producto cumpla con los requisitos del cliente, que sea robusto, confiable y competitivo en el mercado. La demanda laboral de profesionales en QA y testing continúa creciendo, siendo cada vez más solicitados por empresas que buscan asegurar la calidad de sus productos digitales.

El contenido de este reporte está estructurado para guiar al lector desde los fundamentos y definiciones clave, pasando por los diferentes tipos de pruebas, el diseño de casos y la ejecución manual, hasta llegar a temas avanzados como el reporte de defectos, las buenas prácticas, los estándares internacionales y la aplicación práctica en proyectos reales. Se incluyen ejemplos detallados, conceptos técnicos y reflexiones personales sobre las habilidades adquiridas y el impacto del curso en la formación profesional.

La metodología empleada durante el curso ha sido principalmente práctica, realizando presentaciones en equipo, generando documentación técnica, diseñando y ejecutando casos de prueba, y reportando defectos siguiendo formatos certificados. Esto ha permitido no solo entender los conceptos, sino aplicarlos en escenarios reales, desarrollando competencias esenciales para el campo laboral.

El reporte está dirigido a estudiantes, profesionales y cualquier persona interesada en conocer el proceso completo de pruebas de software, desde la teoría hasta la práctica, haciendo énfasis en la relevancia de esta disciplina en el desarrollo de productos competitivos y de alta calidad.

---

## **Capítulo 1: Conceptos Fundamentales de Pruebas de Software**

Las pruebas de software constituyen una etapa fundamental en el ciclo de vida de desarrollo de sistemas. Su objetivo principal es evaluar y verificar que los productos cumplan con los requisitos establecidos y funcionen de acuerdo a las expectativas del usuario y los estándares técnicos.

### **Definición de Pruebas de Software**

Las pruebas de software se definen como el proceso sistemático de ejecutar un programa o sistema con el fin de identificar defectos, validar funcionalidades y verificar que el producto cumple con las especificaciones requeridas. De acuerdo con la teoría vista en clase, involucran actividades de verificación, validación y medición del comportamiento del software bajo diferentes condiciones de uso.

- **Verificación:** Es la revisión de que el software cumple con las especificaciones técnicas establecidas en la documentación.
- **Validación:** Es la comprobación de que el software cumple con los requerimientos y expectativas del usuario final.

Ambas actividades son esenciales y se complementan en el proceso de testing.

### **¿Qué es una Prueba de Software?**

Una prueba de software es un conjunto de actividades que tienen por objetivo ejecutar un producto bajo condiciones controladas, con datos específicos, para detectar diferencias entre el comportamiento esperado y el real. El proceso involucra desde el diseño de casos de prueba, la ejecución, el registro de resultados, hasta el reporte de defectos encontrados.

La importancia de las pruebas radica en la posibilidad de:

- Detectar y corregir errores antes de que el software sea liberado.
- Mejorar la calidad y robustez del producto.
- Reducir costos de mantenimiento posteriores.
- Incrementar la satisfacción del usuario.
- Validar el cumplimiento de los requisitos funcionales y no funcionales.

Un software sin pruebas adecuadas puede presentar fallos graves, vulnerabilidades de seguridad, bajo rendimiento o baja usabilidad, lo que impacta directamente en la reputación de la empresa y en la experiencia del usuario.

### **Procesos Involucrados en las Pruebas de Software**

El proceso de pruebas de software abarca varias etapas, desde la planificación y diseño hasta la ejecución y cierre. Las principales actividades incluyen:

- **Planificación:** Definir la estrategia de pruebas, los recursos necesarios y el cronograma.
- **Diseño de casos de prueba:** Crear los casos que cubrirán los requisitos y funcionalidades.
- **Ejecución:** Realizar las pruebas siguiendo el guion definido y registrar los resultados.
- **Reporte de defectos:** Documentar los errores encontrados de manera clara y precisa.
- **Cierre:** Validar la resolución de los defectos y concluir el proceso.

Cada etapa tiene su importancia y requiere una documentación adecuada para asegurar la trazabilidad y la reproductibilidad de las pruebas.

### **Importancia de las Pruebas**

Durante el curso se enfatizó que las pruebas no solo son necesarias, sino imprescindibles en cualquier proyecto de desarrollo. Los principales beneficios observados son:

- **Identificación temprana de errores:** Permite corregir problemas antes de que impacten en el usuario final.
- **Mejoramiento de la calidad:** Garantiza que el producto funcione como se espera y sea competitivo.
- **Reducción de costos:** Evita gastos elevados en soporte y mantenimiento post-lanzamiento.
- **Satisfacción del cliente:** Un producto bien probado cumple con las expectativas y necesidades del usuario.
- **Validación de requisitos:** Asegura que el software cumple con lo que fue solicitado.

Estas razones justifican la inversión de tiempo y recursos en el proceso de testing y evidencian su relevancia en la industria actual.

---

## **Capítulo 2: Momentos de Ejecución de Pruebas**

El ciclo de vida del software está compuesto por diversas fases, y las pruebas deben integrarse en cada una de ellas para garantizar la calidad final del producto.

### **Ciclo de Vida del Software y Testing**

Las pruebas de software no se realizan únicamente al final del desarrollo, sino que deben ser parte integral desde la etapa inicial de planificación. El ciclo de vida incluye:

- **Planificación:** Definir los objetivos y alcance de las pruebas.
- **Análisis de requisitos:** Validar que los requisitos sean claros y verificables.
- **Diseño:** Revisar que los diseños sean factibles y correctos.
- **Desarrollo:** Realizar pruebas unitarias y de integración.
- **Implementación:** Ejecutar pruebas funcionales, de aceptación y de rendimiento.
- **Post-lanzamiento:** Monitorear el producto y realizar pruebas de mantenimiento.

Integrar las pruebas en cada fase permite detectar errores de manera temprana y evitar que se propaguen a etapas posteriores, donde su corrección es más costosa.

### **Fases donde se aplican pruebas**

En la práctica, se realizan diferentes tipos de pruebas en cada fase del desarrollo:

- **En la planificación:** Se definen los criterios de calidad y los recursos para testing.
- **En el análisis de requisitos:** Se valida que sean testables y completos.
- **En el diseño:** Se revisan los diagramas y especificaciones técnicas.
- **Durante el desarrollo:** Pruebas unitarias y de integración.
- **En la integración:** Verificación de la correcta comunicación entre módulos.
- **En la implementación:** Pruebas funcionales, de usabilidad y rendimiento.
- **Post-lanzamiento:** Pruebas de mantenimiento y regresión.

Este enfoque garantiza que el producto final sea robusto y confiable.

### **Modelo de pruebas continuas**

El modelo de pruebas continuas implica integrar testing en todo el proceso de desarrollo, utilizando herramientas y metodologías que permiten ejecutar pruebas de manera automática y constante. Las principales ventajas observadas son:

- **Detección temprana de errores:** Se identifican problemas en cada commit o cambio realizado.
- **Mejora en la calidad:** Se mantiene el estándar de calidad durante todo el desarrollo.
- **Reducción de riesgos:** Evita la acumulación de errores que puedan afectar el producto.
- **Automatización:** Permite ejecutar pruebas de manera rápida y eficiente.
- **Evolución del testing:** Se adapta a los cambios del proyecto y permite una respuesta ágil.

Durante el curso se analizaron ejemplos de integración continua y se revisaron herramientas que facilitan este proceso, como Jenkins y GitLab CI/CD.

---

## **Capítulo 3: Tipos de Pruebas**

La variedad de pruebas en software es amplia, y cada una cumple un propósito específico dentro del ciclo de vida del producto. En el curso se estudiaron 20 tipos de pruebas, cada una con su definición, objetivo y ejemplo práctico.

### **1. Pruebas Unitarias**

- **Definición:** Verifican el funcionamiento de componentes individuales, como funciones o clases.
- **Propósito:** Detectar errores en unidades pequeñas antes de la integración.
- **Cuándo se utiliza:** Durante el desarrollo.
- **Ventajas:** Permite corregir errores antes de que se propaguen.
- **Ejemplo:** Probar una función que suma dos números y validar el resultado.

### **2. Pruebas de Integración**

- **Definición:** Validan la correcta interacción entre módulos o componentes.
- **Propósito:** Detectar errores en la comunicación entre partes del sistema.
- **Cuándo se utiliza:** Tras completar pruebas unitarias.
- **Ventajas:** Garantiza la cohesión del sistema.
- **Ejemplo:** Verificar que el módulo de login interactúe correctamente con el módulo de base de datos.

### **3. Pruebas Funcionales**

- **Definición:** Evalúan que el sistema cumpla con los requisitos funcionales.
- **Propósito:** Validar que las funciones principales operen correctamente.
- **Cuándo se utiliza:** En la etapa de implementación.
- **Ventajas:** Asegura cumplimiento de requerimientos.
- **Ejemplo:** Probar que el sistema permita registrar nuevos usuarios.

### **4. Pruebas de Regresión**

- **Definición:** Verifican que cambios realizados no afecten funcionalidades existentes.
- **Propósito:** Detectar efectos secundarios no deseados.
- **Cuándo se utiliza:** Tras correcciones o mejoras.
- **Ventajas:** Mantiene la estabilidad del producto.
- **Ejemplo:** Actualizar el sistema y validar que el login siga funcionando correctamente.

### **5. Pruebas de Rendimiento**

- **Definición:** Evaluación de velocidad y capacidad bajo diferentes condiciones.
- **Propósito:** Medir la eficiencia del sistema.
- **Cuándo se utiliza:** Antes del lanzamiento.
- **Ventajas:** Detecta cuellos de botella.
- **Ejemplo:** Probar el tiempo de respuesta ante 100 usuarios simultáneos.

### **6. Pruebas de Seguridad**

- **Definición:** Analizan la presencia de vulnerabilidades y riesgos.
- **Propósito:** Proteger información y recursos.
- **Cuándo se utiliza:** Durante y después del desarrollo.
- **Ventajas:** Evita ataques y fugas de datos.
- **Ejemplo:** Intentar acceder a datos restringidos sin permisos.

### **7. Pruebas de Usabilidad**

- **Definición:** Evalúan la facilidad de uso y experiencia del usuario.
- **Propósito:** Mejorar la interacción y satisfacción.
- **Cuándo se utiliza:** Antes de la entrega al usuario final.
- **Ventajas:** Aumenta la aceptación del producto.
- **Ejemplo:** Validar que el proceso de registro sea intuitivo.

### **8. Pruebas de Compatibilidad**

- **Definición:** Verifican el correcto funcionamiento en diferentes entornos.
- **Propósito:** Asegurar operatividad en varios sistemas y navegadores.
- **Cuándo se utiliza:** En la etapa final.
- **Ventajas:** Ampliar el mercado objetivo.
- **Ejemplo:** Probar el sistema en Windows, Linux y Android.

### **9. Pruebas de Carga**

- **Definición:** Evalúan el comportamiento bajo cargas elevadas de usuarios o datos.
- **Propósito:** Medir la capacidad máxima.
- **Cuándo se utiliza:** Antes del lanzamiento.
- **Ventajas:** Previene caídas inesperadas.
- **Ejemplo:** Simular 500 usuarios accediendo simultáneamente.

### **10. Pruebas de Estrés**

- **Definición:** Analizan el sistema bajo condiciones extremas.
- **Propósito:** Identificar el punto de falla.
- **Cuándo se utiliza:** En pruebas de rendimiento.
- **Ventajas:** Aumenta la robustez.
- **Ejemplo:** Ejecutar procesos intensivos hasta que el sistema colapse.

### **11. Pruebas de Confiabilidad**

- **Definición:** Verifican la estabilidad y consistencia en el tiempo.
- **Propósito:** Garantizar funcionamiento prolongado.
- **Cuándo se utiliza:** En sistemas críticos.
- **Ventajas:** Asegura alta disponibilidad.
- **Ejemplo:** Ejecutar el sistema durante 72 horas sin interrupción.

### **12. Pruebas de Escalabilidad**

- **Definición:** Evalúan la capacidad para crecer en usuarios o datos.
- **Propósito:** Validar la adaptación a nuevas demandas.
- **Cuándo se utiliza:** Antes de expansión.
- **Ventajas:** Facilita la evolución del producto.
- **Ejemplo:** Probar el sistema con la duplicación de usuarios.

### **13. Pruebas de Recuperación**

- **Definición:** Analizan la respuesta ante fallos y recuperación.
- **Propósito:** Medir la capacidad de restauración.
- **Cuándo se utiliza:** En sistemas críticos.
- **Ventajas:** Minimiza el impacto de errores.
- **Ejemplo:** Simular una caída y restaurar el sistema desde un backup.

### **14. Pruebas Exploratorias**

- **Definición:** Pruebas sin guion previo, buscando errores inesperados.
- **Propósito:** Descubrir defectos ocultos.
- **Cuándo se utiliza:** En etapas finales.
- **Ventajas:** Complementa pruebas estructuradas.
- **Ejemplo:** Navegar el sistema buscando comportamientos anómalos.

### **15. Pruebas de Aceptación**

- **Definición:** Validan el cumplimiento de requisitos para aceptar el sistema.
- **Propósito:** Autorizar el lanzamiento.
- **Cuándo se utiliza:** Al finalizar el desarrollo.
- **Ventajas:** Garantiza satisfacción del cliente.
- **Ejemplo:** Cliente realiza pruebas siguiendo sus requerimientos.

### **16. Pruebas Smoke**

- **Definición:** Pruebas rápidas para verificar funcionamiento básico.
- **Propósito:** Detectar errores críticos.
- **Cuándo se utiliza:** Tras una nueva versión.
- **Ventajas:** Ahorro de tiempo.
- **Ejemplo:** Probar inicio de sesión y navegación principal.

### **17. Pruebas Sanity**

- **Definición:** Verifican que correcciones específicas funcionen.
- **Propósito:** Validar cambios recientes.
- **Cuándo se utiliza:** Después de una corrección.
- **Ventajas:** Eficiencia.
- **Ejemplo:** Probar que el botón de registro funcione tras corregirlo.

### **18. Pruebas de Localización**

- **Definición:** Validan la adaptación a diferentes idiomas y regiones.
- **Propósito:** Garantizar internacionalización.
- **Cuándo se utiliza:** Para sistemas multilingües.
- **Ventajas:** Expande el mercado.
- **Ejemplo:** Verificar traducciones en español e inglés.

### **19. Pruebas Alpha/Beta**

- **Definición:** Se realizan antes del lanzamiento, internamente (Alpha) y externamente (Beta).
- **Propósito:** Obtener retroalimentación real.
- **Cuándo se utiliza:** Al final del desarrollo.
- **Ventajas:** Mejora la calidad.
- **Ejemplo:** Usuarios reales prueban el sistema y reportan errores.

### **20. Pruebas de Penetración**

- **Definición:** Simulan ataques para detectar vulnerabilidades.
- **Propósito:** Fortalecer la seguridad.
- **Cuándo se utiliza:** Antes de la liberación.
- **Ventajas:** Evita amenazas externas.
- **Ejemplo:** Intentar acceder a información restringida mediante técnicas de hacking ético.

Cada tipo de prueba estudiado aporta una visión distinta y complementaria al proceso de testing, permitiendo cubrir todos los aspectos necesarios para asegurar la calidad del producto final.

---

## **Capítulo 4: Casos de Prueba y Diseño**

El diseño y documentación de casos de prueba es esencial para asegurar que todas las funcionalidades sean verificadas de manera sistemática y reproducible.

### **¿Qué es un Caso de Prueba?**

Un caso de prueba es un documento que describe un conjunto de acciones, datos y resultados esperados para verificar una funcionalidad específica del software. Su importancia radica en la capacidad de validar el correcto funcionamiento y documentar de manera precisa cualquier error encontrado.

### **Componentes de un Caso de Prueba**

Durante el curso se aprendió a estructurar los casos de prueba con los siguientes elementos:

- **ID:** Identificador único para rastrear el caso.
- **Descripción:** Breve explicación de lo que se va a probar.
- **Precondiciones:** Estado necesario antes de ejecutar la prueba.
- **Pasos:** Acciones detalladas a seguir.
- **Datos de entrada:** Información utilizada durante la prueba.
- **Resultados esperados:** Lo que debería suceder.
- **Resultados actuales:** Lo que realmente ocurrió.

Esta estructura permite una documentación clara y facilita la ejecución y el seguimiento.

### **Diseño de Casos de Prueba**

El diseño de casos implica seleccionar las funcionalidades a probar, definir los datos de entrada y establecer los criterios de éxito. Se utilizan diferentes técnicas, como:

- **Partición de equivalencia:** Separar los datos en grupos que se comportan igual.
- **Análisis de valores límite:** Probar datos en los extremos permitidos.
- **Tablas de decisión:** Documentar combinaciones de entradas y salidas.

Estas estrategias ayudan a maximizar la cobertura y reducir el número de pruebas necesarias.

### **Ejemplo Práctico Detallado**

**Caso de prueba para un formulario de registro:**

- **ID:** REG-001
- **Descripción:** Validar registro con datos válidos.
- **Precondiciones:** Usuario no registrado.
- **Pasos:**  
  1. Ingresar nombre, correo y contraseña válidos.  
  2. Presionar "Registrar".
- **Datos de entrada:** Nombre: Juan, Correo: juan@mail.com, Contraseña: 12345Abc
- **Resultado esperado:** Usuario registrado exitosamente.
- **Resultado actual:** (Se documenta tras ejecutar la prueba).

**Caso de prueba para una calculadora:**

- **ID:** CALC-002
- **Descripción:** Sumar dos números positivos.
- **Precondiciones:** Calculadora iniciada.
- **Pasos:**  
  1. Ingresar "5".  
  2. Presionar "+".  
  3. Ingresar "3".  
  4. Presionar "=".
- **Datos de entrada:** 5 y 3
- **Resultado esperado:** Pantalla muestra "8".

**Caso de prueba para login:**

- **ID:** LOGIN-003
- **Descripción:** Acceso con credenciales correctas.
- **Precondiciones:** Usuario registrado.
- **Pasos:**  
  1. Ingresar correo y contraseña válidos.  
  2. Presionar "Ingresar".
- **Datos de entrada:** juan@mail.com / 12345Abc
- **Resultado esperado:** Acceso exitoso.

### **Diferencia entre Diseñar y Ejecutar Pruebas**

- **Diseñar:** Se centra en la creación de los casos y criterios de éxito.
- **Ejecutar:** Consiste en seguir el guion y registrar los resultados reales.
- **Roles involucrados:** Analista de pruebas, tester y desarrollador.

Diseñar pruebas requiere creatividad y conocimiento del sistema, mientras que ejecutarlas demanda precisión y atención al detalle.

---

## **Capítulo 5: Ejecución de Pruebas Manuales**

La ejecución manual de pruebas implica seguir los casos de prueba documentados, registrar resultados y reportar defectos encontrados.

### **¿Cómo se Ejecutan Pruebas Manuales?**

Durante el curso se aprendió a ejecutar pruebas siguiendo estos pasos:

1. Leer el caso de prueba y preparar el entorno.
2. Realizar cada paso detallado.
3. Ingresar los datos de entrada especificados.
4. Comparar el resultado obtenido con el esperado.
5. Documentar cualquier diferencia o error.

La ejecución debe ser sistemática y reproducible para asegurar la calidad de los resultados.

### **Registro de Resultados**

Al ejecutar pruebas, se documentan los siguientes estados:

- **Pasó:** El resultado obtenido coincide con el esperado.
- **Falló:** Hay diferencias entre lo esperado y lo actual.
- **Bloqueado:** No se puede ejecutar la prueba por un impedimento.
- **Incompleto:** El caso no se terminó por algún motivo.

Es fundamental incluir observaciones y evidencia visual, como capturas de pantalla, para facilitar la revisión y corrección de errores.

### **Buenas Prácticas en Ejecución**

Para asegurar la calidad de las pruebas manuales, se aplican buenas prácticas como:

- Probar diferentes tipos de datos: válidos, inválidos y límites.
- Documentar los pasos y resultados de manera clara.
- Asegurar la reproducibilidad para que otros puedan repetir el proceso.
- Mantener comunicación efectiva con el equipo de desarrollo.

Estas prácticas permiten identificar errores y mejorar el producto de manera eficiente.

### **Herramientas para Pruebas Manuales**

Durante el curso se utilizaron herramientas como:

- Documentos de casos de prueba en formato Excel y Word.
- Capturas de pantalla para evidenciar resultados.
- Videos cortos mostrando la ejecución.
- Logs del sistema para analizar el comportamiento.

El uso de estas herramientas facilita la documentación y el reporte de defectos.

---

## **Capítulo 6: Reportes de Defectos de Software**

El reporte de defectos es una actividad crítica para documentar y comunicar los errores encontrados durante el proceso de pruebas.

### **¿Qué es un Reporte de Defectos?**

Un reporte de defectos es un documento que describe de manera clara y precisa un error encontrado en el software, permitiendo su análisis y corrección por parte del equipo de desarrollo. Su importancia radica en la capacidad de rastrear, priorizar y resolver problemas de manera eficiente.

### **Componentes de un Reporte de Defectos**

Los elementos esenciales de un reporte de defectos incluyen:

- **ID del defecto:** Identificador único.
- **Título/Resumen:** Breve descripción del error.
- **Descripción:** Detalle claro del problema.
- **Qué se esperaba vs. qué sucedió:** Comparación entre el comportamiento esperado y el real.
- **Pasos para reproducir:** Secuencia detallada para replicar el error.
- **Capturas de pantalla:** Evidencia visual.
- **Entorno:** Información sobre navegador, sistema operativo y versión.
- **Severidad:** Impacto en el sistema (Crítico, Mayor, Menor).
- **Prioridad:** Urgencia de la corrección.
- **Reportado por:** Nombre del tester.
- **Fecha:** Día en que se reportó.

Esta estructura facilita la comunicación y el seguimiento de los errores.

### **Cómo Describir un Error de Forma Clara**

Para asegurar la efectividad del reporte, se recomienda:

- Utilizar lenguaje preciso y específico.
- Evitar ambigüedades y suposiciones.
- Incluir evidencia visual y pasos detallados.
- Ser objetivo y descriptivo.

Esto permite al equipo de desarrollo entender rápidamente el problema y trabajar en su solución.

### **Formatos Estándar**

Durante el curso se revisaron los formatos IEEE 829 y ISO/IEC/IEEE 29119, que establecen las directrices para la documentación y gestión de pruebas y defectos.

- **IEEE 829:** Define la estructura de reportes y casos de prueba.
- **ISO/IEC/IEEE 29119:** Amplía los procesos y requisitos para testing.

Ambos estándares son reconocidos internacionalmente y aseguran la calidad y trazabilidad de la documentación.

### **Ciclo de Vida de un Defecto**

Los defectos pasan por diferentes estados:

- **Abierto:** Cuando se reporta el error.
- **En progreso:** El equipo trabaja en la corrección.
- **Resuelto:** El defecto ha sido corregido.
- **Cerrado:** Se verifica la solución y se cierra el reporte.
- **Reabierto:** Si el error persiste tras la corrección.

Esta gestión permite un seguimiento eficiente y evita que los errores pasen desapercibidos.

---

## **Capítulo 7: Buenas Prácticas en Testing**

Las buenas prácticas en testing permiten mejorar la calidad de las pruebas y asegurar la efectividad del proceso.

### **Datos de Prueba Diversificados**

Es fundamental utilizar diferentes tipos de datos en las pruebas:

- **Datos válidos:** Información que cumple con los requisitos.
- **Datos inválidos:** Datos que no cumplen con las reglas.
- **Datos límite:** Valores en los extremos permitidos.

Ejemplo práctico: Probar un campo de edad con valores 0, 99 (límites), texto (inválido) y valores intermedios (válido).

### **Reproductibilidad**

La capacidad de reproducir una prueba es esencial para asegurar que los errores puedan ser replicados y corregidos por cualquier miembro del equipo. Se logra mediante:

- Documentación clara y detallada.
- Uso de pasos precisos y datos específicos.
- Inclusión de evidencia visual.

Esto facilita la colaboración y el seguimiento de los defectos.

### **Comunicación con el Equipo**

Un buen tester debe mantener una comunicación efectiva con el equipo de desarrollo, reportando errores de manera clara, proporcionando feedback y colaborando en la solución de problemas. La retroalimentación constante mejora el producto y fortalece el trabajo en equipo.

### **Gestión de Pruebas**

La planificación, ejecución y seguimiento de las pruebas son actividades clave para asegurar la calidad. Se utilizan métricas como la cobertura de pruebas, el número de defectos encontrados y el tiempo de corrección para medir la efectividad del proceso.

### **Eficiencia en Testing**

La automatización de pruebas permite ejecutar casos de manera rápida y repetitiva, mientras que las pruebas manuales son esenciales para validar aspectos complejos y la experiencia del usuario. Saber cuándo aplicar cada tipo de prueba es fundamental para optimizar recursos y tiempo.

---

## **Capítulo 8: Estándares y Formatos Certificados**

El uso de estándares internacionales garantiza la calidad y la aceptación de los procesos de testing en cualquier organización.

### **Estándar IEEE 829**

- **Historia:** Creado para documentar procesos y reportes de pruebas.
- **Objetivos:** Estandarizar la documentación y asegurar la trazabilidad.
- **Componentes:** Test Plan, Test Design, Test Case, Test Incident.
- **Estructura:** Define el formato de cada documento.

### **Estándar ISO/IEC/IEEE 29119**

- **Procesos:** Amplía las actividades de testing y gestión de defectos.
- **Requerimientos:** Establece criterios de calidad y documentación.
- **Ventajas:** Facilita la comparación y aceptación internacional.

### **Comparativa de Estándares**

Ambos estándares comparten el objetivo de mejorar la calidad y trazabilidad, pero ISO/IEC/IEEE 29119 es más amplio y actual. Se utiliza IEEE 829 en proyectos específicos y el nuevo estándar en empresas que buscan certificaciones internacionales.

### **Material Multimedia en Formatos**

El uso de capturas de pantalla, videos y diagramas en la documentación facilita la comprensión y la resolución de errores, aportando evidencia clara y objetiva del proceso de testing.

---

## **Capítulo 9: Experiencias Prácticas del Curso**

El aprendizaje en el curso se basó en la aplicación práctica de los conceptos, trabajando en equipo y enfrentando desafíos reales.

### **Actividades Realizadas**

- Presentaciones de los 20 tipos de pruebas.
- Diseño de casos de prueba para sistemas reales.
- Ejecución manual y automatizada de pruebas.
- Elaboración de reportes de defectos siguiendo estándares.

### **Proyectos del Curso**

- **Primer avance:** Propuesta de software y definición de requisitos.
- **Segundo avance:** Documentación y mejora de procesos.
- **Tercer avance:** Pruebas manuales y reporte de defectos.
- **Documento final:** Integración de todos los elementos y aplicación de estándares.

### **Dinámicas por Equipos**

El trabajo colaborativo permitió distribuir roles entre analista, tester y desarrollador. Se enfrentaron desafíos como la comunicación, la coordinación y la gestión de tiempos, aprendiendo a resolver problemas y mejorar la calidad del producto.

### **Aplicación de Estándares**

Se aplicaron los formatos IEEE 829 e ISO/IEC/IEEE 29119 en la documentación, mejorando la claridad, la trazabilidad y la aceptación de los reportes. Las mejoras realizadas permitieron una gestión más eficiente de los defectos y una mejor comunicación con el equipo.

---

## **Conclusiones**

El curso de Pruebas de Software permitió adquirir conocimientos y habilidades esenciales para el desarrollo profesional en la industria tecnológica. Los temas más importantes incluyen la definición y tipos de pruebas, el diseño de casos, la ejecución manual y automatizada, la gestión de defectos y la aplicación de estándares internacionales.

La comprensión sobre testing cambió radicalmente, pasando de una visión básica a una perspectiva integral y profesional. Se aprendió la importancia de documentar, comunicar y colaborar en equipo para mejorar la calidad del producto y la satisfacción del usuario.

La demanda laboral de testers y especialistas en QA continúa creciendo, siendo una de las áreas con mayor proyección en el campo tecnológico. Las habilidades adquiridas, como el diseño de casos, la ejecución eficiente y el reporte claro de defectos, son fundamentales para destacar en la industria.

Como reflexión personal, se identifican fortalezas en la capacidad de análisis, la documentación y la comunicación, así como áreas de mejora en la automatización y el uso de nuevas herramientas. Los próximos pasos incluyen especializarse en testing automatizado, aprender nuevas plataformas y obtener certificaciones reconocidas.

Se recomienda a los futuros testers profundizar en el uso de herramientas de automatización, estudiar los estándares internacionales y buscar especializaciones en áreas como seguridad, rendimiento y usabilidad, para ampliar sus oportunidades y aportar mayor valor a la industria.

---

## **Glosario Técnico**

1. **Caso de Prueba:** Documento que describe pasos para verificar una funcionalidad.
2. **Defecto/Bug:** Diferencia entre comportamiento esperado y real.
3. **Cobertura de Pruebas:** Porcentaje de código evaluado por pruebas.
4. **Regression Testing:** Pruebas para validar que cambios no afecten funciones existentes.
5. **Test Plan:** Estrategia y alcance de pruebas.
6. **Validación:** Comprobación de requisitos del usuario.
7. **Verificación:** Revisión de especificaciones técnicas.
8. **QA (Quality Assurance):** Aseguramiento de calidad.
9. **Black Box Testing:** Pruebas sin conocer el código interno.
10. **White Box Testing:** Pruebas con acceso al código fuente.
11. **Smoke Testing:** Pruebas rápidas de funcionalidad básica.
12. **Stress Testing:** Pruebas bajo condiciones extremas.
13. **Performance Testing:** Evaluación de velocidad y eficiencia.
14. **Security Testing:** Análisis de vulnerabilidades.
15. **Usability Testing:** Evaluación de facilidad de uso.
16. **Acceptance Testing:** Pruebas finales antes de lanzamiento.
17. **Unit Testing:** Evaluación de componentes individuales.
18. **Integration Testing:** Pruebas de interacción entre módulos.
19. **Boundary Testing:** Pruebas en los límites de valores permitidos.
20. **End-to-End Testing:** Pruebas del flujo completo del sistema.
21. **Test Case ID:** Identificador único de un caso de prueba.
22. **Precondición:** Estado necesario antes de ejecutar una prueba.
23. **Datos de Entrada:** Información utilizada en la prueba.
24. **Resultado Esperado:** Comportamiento esperado por el sistema.
25. **Resultado Actual:** Comportamiento real obtenido.
26. **Severidad:** Nivel de impacto del defecto.
27. **Prioridad:** Urgencia de corrección.
28. **Test Incident Report:** Documento de error encontrado.
29. **Test Suite:** Conjunto de casos de prueba.
30. **Test Execution:** Proceso de ejecutar pruebas.
31. **Reproducibilidad:** Capacidad de repetir una prueba.
32. **Test Log:** Registro de resultados y observaciones.
33. **Test Environment:** Entorno donde se realizan pruebas.
34. **Defect Lifecycle:** Estados por los que pasa un defecto.
35. **Test Data:** Información utilizada para pruebas.
36. **Exploratory Testing:** Pruebas sin guion previo.
37. **Sanity Testing:** Pruebas rápidas de correcciones específicas.
38. **Alpha Testing:** Pruebas internas previas al lanzamiento.
39. **Beta Testing:** Pruebas externas con usuarios reales.
40. **Penetration Testing:** Pruebas simulando ataques externos.
41. **ISO/IEC/IEEE 29119:** Estándar internacional de testing.
42. **IEEE 829:** Formato de documentación de pruebas.
43. **Automated Testing:** Pruebas ejecutadas por herramientas automáticas.
44. **Manual Testing:** Pruebas realizadas por una persona.
45. **Defect Tracking Tool:** Herramienta para gestionar errores.

---

## **Referencias**

- Presentaciones y materiales del curso "Pruebas de Software 27CV", Universidad Politécnica de Quintana Roo.
- Estándares IEEE 829 e ISO/IEC/IEEE 29119.
- Experiencias prácticas y proyectos colaborativos realizados durante el semestre.
- Documentación técnica generada en equipos.
- Recursos multimedia y herramientas utilizadas en pruebas manuales.

---

