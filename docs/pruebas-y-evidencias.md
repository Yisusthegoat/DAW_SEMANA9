# Pruebas y evidencias

## Estado inicial

**Pruebas manuales del estudiante: pendientes.** No se han tomado capturas ni se presentan evidencias ficticias. Guarda tus capturas reales en `evidencias/`.

## Verificación automatizada de Codex

Ejecutada el 28 de octubre de 2026 en `D:\xampp\htdocs\DAW_SEMANA9`:

| Comprobación | Resultado |
|---|---|
| Sintaxis de config.php, procesar.php y resumen.php con D:\xampp\php\php.exe -l | Los tres sin errores; PHP CLI 8.2.12 |
| GET http://localhost/DAW_SEMANA9/php/lab09/ | 200 |
| GET resumen.php sin inscripción | 200 y mensaje de ausencia |
| GET / PUT a procesar.php | 405; Allow: POST comprobado en GET |
| POST sin campos y nombre con espacios | 400 |
| POST con correo inválido o taller manipulado | 400 |
| Nombre de 101 caracteres y correo de 255 | 400 |
| Parámetros PHP en forma de arreglo para nombre, correo y taller | 400 sin avisos |
| POST válido con cada uno de los tres talleres | 302, Location: resumen.php; GET posterior 200 con datos |
| Nombre con etiquetas, comillas, ampersand y acento | Mostrado escapado como texto en la respuesta HTML |
| Recarga del resumen con la misma cookie | 200 y mismos datos |
| Envío inválido después de inscripción válida | Conserva la inscripción anterior |
| Resumen con una cookie nueva | Mensaje de ausencia |
| CSS por HTTP | 200 |
| Rutas de href/action locales y CSS de ambas versiones | Destinos existentes y CSS idénticos |
| WEB-INF/web.xml | XML bien formado; bienvenida index.jsp. Validación del esquema y despliegue pendientes |
| JDK | java y javac 26.0.1; JAVA_HOME sin definir |
| Tomcat encontrado en XAMPP | 8.5.96; no se utilizó para este proyecto Jakarta |
| JSP en Tomcat 10.x | **Pendiente: no se probó ejecución ni compilación en ese contenedor** |

Se completaron **26 solicitudes HTTP de comprobación PHP** mediante un cliente local, sin cambiar la configuración de Apache. No equivalen a una revisión visual del navegador. Las peticiones usaron cookies de prueba, no la sesión del estudiante.

## Checklist manual para ambas versiones

Usa PHP ahora y repite cada paso en JSP después de desplegarlo en Tomcat 10.x.

- [ ] Abrir el formulario: GET 200, etiquetas, estilos y selector visibles.
- [ ] Revisar en móvil y escritorio que no haya desbordamiento horizontal.
- [ ] Recorrer campos y botón con Tab; comprobar foco visible y contraste.
- [ ] Enviar datos correctos para cada taller; comprobar confirmación con datos exactos.
- [ ] Enviar campos vacíos; observar HTML required y después probar el servidor sin esos controles.
- [ ] Enviar correo inválido; comprobar error 400 del servidor.
- [ ] Manipular taller con un valor que no existe: 400.
- [ ] Probar límites: nombre de 100 y 101 caracteres; correo válido y correo demasiado largo.
- [ ] Probar nombre `José & Ana <script>alert("x")</script>`: debe aparecer como texto, sin ejecutar código.
- [ ] Abrir procesar directamente por GET: 405 y Allow: POST.
- [ ] Probar otros métodos, por ejemplo PUT y OPTIONS: 405 y Allow: POST.
- [ ] Enviar POST válido: 302 con Location al resumen, seguido de GET 200.
- [ ] Actualizar el resumen: conserva inscripción y no reenvía POST.
- [ ] Enviar datos inválidos tras una inscripción válida: el resumen anterior permanece.
- [ ] Abrir resumen en ventana privada sin inscripción: mensaje de ausencia, sin avisos.
- [ ] Inscribirse en PHP y abrir JSP sin haberse inscrito allí: no comparten datos.

## DevTools → Network

1. Abre F12 → **Network** y activa **Preserve log** antes de enviar.
2. Envía el formulario; selecciona la solicitud a procesar.
3. En **Headers** comprueba Request Method POST y el estado 302 o 400.
4. En **Payload / Form Data** revisa nombre, correo y taller. No compartas datos personales reales en las capturas.
5. En **Response Headers** revisa Location en el 302 y Allow: POST en el 405.
6. Selecciona la petición siguiente al resumen: GET 200. Conservar el log evita perder el 302 al navegar.
7. Revisa Set-Cookie y el envío posterior de Cookie. Application/Storage → Cookies permite inspeccionar LAB09PHP o JSESSIONID.
8. Actualiza el resumen y verifica que se repite GET, sin POST.

## Validación del servidor sin controles HTML

Desde la consola de DevTools, en el origen de la aplicación, ejecuta lo siguiente. En JSP cambia el destino a `procesar.jsp`.

```javascript
fetch('procesar.php', {
  method: 'POST',
  body: new URLSearchParams({
    nombre: '',
    correo: 'correo-invalido',
    taller: 'taller-manipulado'
  })
}).then(async r => console.log(r.status, await r.text()));
```

Esta solicitud evita required y type=email del formulario; debe devolver 400 y errores claros. Repite cambiando **solo un campo por vez** para identificar cada regla. Puedes editar temporalmente el DOM desde DevTools para quitar required o cambiar el valor del selector, sin editar los archivos del proyecto.

Para comprobar otros métodos:

```javascript
fetch('procesar.php', { method: 'PUT' })
  .then(r => console.log(r.status, r.headers.get('Allow')));
```

En un POST válido, fetch sigue redirecciones por defecto: revisa el 302 en Network; el estado final devuelto al código suele ser 200.

## Detalle de Tomcat y métodos

Jasper normalmente genera su propio tratamiento de OPTIONS y otros métodos antes del scriptlet. Por eso procesar.jsp usa `isErrorPage="true"`: permite que el código de esta práctica controle todos los métodos y responda 405 con Allow: POST. No se configura como destino de errores en web.xml y no utiliza el objeto exception. Esta decisión se comprobó en el [generador oficial de Jasper 10.1](https://raw.githubusercontent.com/apache/tomcat/10.1.x/java/org/apache/jasper/compiler/Generator.java); **su comportamiento real en el despliegue sigue pendiente de probar**.

## Logs en Windows

- Apache: `D:\xampp\apache\logs\access.log` para método, ruta y estado; `D:\xampp\apache\logs\error.log` para errores. Si tu instalación cambió la ubicación, consulta su configuración.
- Tomcat: revisa la consola de arranque y los archivos en `%CATALINA_BASE%\logs` (o la carpeta logs de la instancia).
- Son habituales `catalina.AAAA-MM-DD.log`, `localhost.AAAA-MM-DD.log` y, si AccessLogValve está habilitado, `localhost_access_log.AAAA-MM-DD.txt`.
- En Windows **no se debe asumir que existe catalina.out**. Con `bin\catalina.bat run` puedes ver la salida en la consola.
- Comprueba errores de compilación JSP, versión de Java, puertos ocupados y contexto lab09. No desactives logs ni borres trazas para ocultar fallos.

## Capturas que debes tomar

1. Versiones de PHP, Java y Tomcat; servidores iniciados sin errores.
2. Estructura del proyecto en VS Code.
3. Formulario PHP en escritorio y móvil.
4. Confirmación PHP con nombre, correo y taller de prueba.
5. Network con POST 302 y GET del resumen 200.
6. POST inválido 400 y su página de errores.
7. GET al procesador 405 con Allow: POST.
8. Prueba de caracteres especiales y persistencia al recargar.
9. Formulario, confirmación y los mismos estados HTTP en JSP/Tomcat 10.x.
10. Fragmentos relevantes de logs, sin datos sensibles.
11. Repositorio GitHub, una vez que tú lo publiques.

**Pendientes:** todas las capturas, revisión visual y de teclado, pruebas manuales del estudiante y el flujo completo JSP en Tomcat 10.x.

