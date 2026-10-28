# PHP y JSP: comparación técnica

Fuentes oficiales consultadas el 28 de octubre de 2026. Las descripciones corresponden al modelo habitual de ejecución; la memoria y el rendimiento concretos dependen del despliegue.

| Aspecto | PHP | JSP sobre Tomcat |
|---|---|---|
| Ciclo de vida | El motor analiza y compila el script a opcodes, lo ejecuta y produce salida. Con OPcache activo, reutiliza bytecode válido en lugar de analizarlo en cada petición. [1] | Traducción de JSP a servlet Java, compilación, carga e instanciación, inicialización, servicio de solicitudes y destrucción. Jasper puede recompilar páginas modificadas. [2][3] |
| Memoria | Las variables normales pertenecen a la solicitud; no son almacenamiento persistente. Procesos del servidor y cachés pueden sobrevivirla. [1][4] | La JVM, clases y servlet pueden permanecer cargados. Objetos no alcanzables son candidatos a recolección de basura; atributos de sesión duran según la sesión. [3][5] |
| Despliegue | Scripts bajo el directorio servido por Apache con PHP configurado. | Directorio de aplicación o WAR en webapps del contenedor. Debe coincidir la generación Jakarta del descriptor con Tomcat. [6] |
| Escalabilidad | Puede distribuir peticiones entre trabajadores/servidores; las sesiones requieren estrategia compartida o afinidad si se usan varios nodos. | Puede distribuir solicitudes entre hilos/nodos; también necesita estrategia de sesión. No es automáticamente más escalable por usar Java. [5][7] |
| Sesiones | session_start() recupera datos mediante un identificador, usualmente en cookie; el manejador predeterminado guarda archivos. [4] | HttpSession asocia atributos al identificador del cliente; contenedor administra vigencia e invalidación. [5] |
| Renderizado | El servidor genera HTML y lo envía al navegador. | El servlet generado produce HTML en el servidor. El navegador recibe el resultado, no ejecuta Java/JSP. [3] |

## Etapas de JSP y reutilización

La traducción convierte la plantilla a una clase servlet; la compilación genera bytecode. El contenedor carga e instancia esa clase e invoca `jspInit()` una vez por instancia. Cada solicitud ejecuta `_jspService()`, que genera la respuesta. Al retirar la instancia, llama a `jspDestroy()`. La traducción y compilación pueden adelantarse al despliegue; no se repiten obligatoriamente en cada petición. Clase e instancia se reutilizan mientras el contenedor las conserve, salvo cambios, recarga o reinicio. [2][3]

Una instancia puede atender solicitudes concurrentes. Por ello, las entradas del formulario son variables locales del scriptlet y no campos mutables declarados con `<%!`. El único método declarado aquí es el escape sin estado. [3]

## PHP: análisis, ejecución y salida

La petición llega a Apache y su integración con PHP. El motor prepara los opcodes (o recupera los ya preparados con OPcache), ejecuta validaciones y sesión, y envía cabeceras y HTML. OPcache guarda bytecode, no la inscripción del usuario ni una página final universal. No se ha comprobado que OPcache esté habilitado en este Apache. [1]

## HTTP y estado

HTTP es un protocolo sin estado: cada petición se interpreta por separado. La sesión enlaza peticiones mediante un identificador, normalmente una cookie, y permite recuperar datos guardados en el servidor. [4][5][8]

Aquí el POST válido guarda datos y devuelve 302; el navegador hace GET al resumen. Al recargar se repite ese GET, evitando volver a enviar el formulario. PHP usa la cookie LAB09PHP; Tomcat suele usar JSESSIONID. Son sesiones independientes aun cuando ambos servidores se abren en localhost.

## Scriptlets, EL y JSTL

Los scriptlets permiten ver Java directamente dentro de JSP y se han mantenido cortos por el objetivo pedagógico. En aplicaciones más grandes conviene procesar en servlets/clases y presentar con EL/JSTL. EL facilita acceder a atributos y expresiones; JSTL aporta etiquetas para condiciones, iteración y salida. **EL por sí sola no garantiza escape HTML**: imprimir un atributo no equivale a sanitizarlo. JSTL `c:out` ofrece escape XML de forma predeterminada. Aquí se usa una función explícita de escape y no se requieren bibliotecas JSTL externas. [3][9]

## Fuentes

1. [PHP: OPcache](https://www.php.net/manual/en/book.opcache.php).
2. [Tomcat 10.1: Jasper](https://tomcat.apache.org/tomcat-10.1-doc/jasper-howto.html).
3. [Jakarta Server Pages 3.1](https://jakarta.ee/specifications/pages/3.1/jakarta-server-pages-spec-3.1).
4. [PHP: uso básico de sesiones](https://www.php.net/manual/en/session.examples.basic.php).
5. [Jakarta Servlet 6.0: especificación](https://jakarta.ee/specifications/servlet/6.0/jakarta-servlet-spec-6.0.html).
6. [Tomcat 10.1: despliegue](https://tomcat.apache.org/tomcat-10.1-doc/deployer-howto.html).
7. [Tomcat 10.1: clúster](https://tomcat.apache.org/tomcat-10.1-doc/cluster-howto.html).
8. [RFC 9110: HTTP Semantics, sección 3.3](https://www.rfc-editor.org/rfc/rfc9110.html#section-3.3).
9. [Jakarta Tags: c:out y escapeXml](https://jakarta.ee/specifications/tags/2.0/tagdocs/c/out).

Las fuentes respaldan el modelo conceptual; no sustituyen ejecutar el proyecto en el servidor objetivo. No se realizaron mediciones de rendimiento.

