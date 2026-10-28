# Inscripción a talleres universitarios · Semana 09

Práctica de Desarrollo de Aplicaciones Web: dos aplicaciones pequeñas y equivalentes en PHP y JSP. Permiten registrar nombre completo, correo y uno de tres talleres; validan en servidor, guardan la última inscripción en sesión y muestran una confirmación. No usan base de datos ni dependencias externas.

## Requisitos y entorno comprobado

- Windows, editor como Visual Studio Code y navegador con DevTools.
- Apache y PHP 8.2+; instalación prevista: `D:\xampp`.
- JSP: JDK 17+ y Apache Tomcat 10.x compatible con el JDK elegido; se recomienda Tomcat 10.1 con un JDK soportado.
- Comprobación local: PHP CLI 8.2.12 y Java/JDK 26.0.1 disponibles. `JAVA_HOME` no está definido.
- **El Tomcat incluido en este XAMPP es 8.5.96, no 10.x.** No desplegar allí este descriptor Jakarta. La ejecución JSP en Tomcat 10.x está pendiente.

## Estructura

```text
DAW_SEMANA9/
├── README.md
├── .gitignore
├── docs/
│   ├── comparacion-php-jsp.md
│   ├── pruebas-y-evidencias.md
│   └── uso-ia.md
├── evidencias/
│   └── .gitkeep
├── php/lab09/
│   ├── index.html
│   ├── config.php
│   ├── procesar.php
│   ├── resumen.php
│   └── assets/styles.css
└── jsp/lab09/
    ├── index.jsp
    ├── procesar.jsp
    ├── resumen.jsp
    ├── WEB-INF/web.xml
    └── assets/styles.css
```

## Ejecutar PHP

1. Conserva este repositorio en `D:\xampp\htdocs\DAW_SEMANA9`.
2. Abre `D:\xampp\xampp-control.exe` y pulsa **Start** en Apache (puerto 80).
3. La guía también indica iniciar MySQL desde ese panel. Esta aplicación no lo utiliza: puede ejecutarse sin MySQL.
4. Abre **http://localhost/DAW_SEMANA9/php/lab09/**.
5. Completa el formulario. El POST válido responde 302 y el navegador solicita el resumen por GET.

No uses Live Server para PHP ni JSP: sirve archivos estáticos, no ejecuta sus motores. Tampoco abras los archivos directamente con `file://`.

Validar sintaxis desde PowerShell en la raíz:

```powershell
& D:\xampp\php\php.exe -l php\lab09\config.php
& D:\xampp\php\php.exe -l php\lab09\procesar.php
& D:\xampp\php\php.exe -l php\lab09\resumen.php
```

## Desplegar JSP por separado

1. Comprueba el JDK y la variable desde PowerShell:

   ```powershell
   java -version
   javac -version
   $env:JAVA_HOME
   ```

2. Comprueba la versión real de Tomcat en `RELEASE-NOTES` o con `bin\version.bat`. El Tomcat de XAMPP puede ser anterior a 10.x. Usa una instalación de Tomcat 10.x compatible; este proyecto no instala programas ni modifica servicios o variables globales.
3. Ejemplo para una instalación **ya disponible** en `D:\servidores\apache-tomcat-10.1`: ajusta la ruta a tu instalación. Si necesita `JAVA_HOME`, defínelo solo en esta consola (debe apuntar al JDK, sin `\bin`):

   ```powershell
   $env:JAVA_HOME = 'C:\Program Files\Java\jdk-26.0.1'
   $tomcatPractica = 'D:\servidores\apache-tomcat-10.1'
   & "$tomcatPractica\bin\version.bat"
   ```

   Comprueba que esa versión de Tomcat admita tu JDK; si no, usa un JDK compatible 17+.
4. Antes de reemplazar un despliegue activo, detén ese Tomcat con `bin\shutdown.bat` y confirma en su consola/logs que se ha detenido. Conserva cualquier despliegue previo de `lab09` antes de copiar. No sobrescribas otra aplicación con ese nombre.
5. Con Tomcat detenido y sin una aplicación previa `lab09`, copia desde la raíz del repositorio:

   ```powershell
   Copy-Item -LiteralPath .\jsp\lab09 -Destination "$tomcatPractica\webapps\lab09" -Recurse
   & "$tomcatPractica\bin\startup.bat"
   ```

6. Abre **http://localhost:8080/lab09/**. Confirma que el puerto 8080 esté libre y revisa los logs de arranque.
7. Para ver errores de arranque directamente, puedes usar `bin\catalina.bat run` en lugar de `startup.bat`, sin iniciar dos instancias. Detén la ejecución de consola con Ctrl+C.

Apache/XAMPP ejecuta PHP; Tomcat ejecuta JSP. Copiar JSP a htdocs no lo ejecuta.

## Flujo, responsabilidades y límites

`index → POST procesar → 302 → GET resumen`. El formulario recoge datos, el procesador controla método y validación, y el resumen presenta la sesión. `config.php` centraliza la lista y configuración PHP. Esta separación se relaciona con MVC, pero **no es un MVC completo**: no hay un modelo separado ni controlador frontal; JSP usa scriptlets cortos con finalidad pedagógica.

Las aplicaciones tienen la misma apariencia y flujo: nombre de 1 a 100 caracteres, correo de hasta 254 y taller en lista permitida. PHP usa `FILTER_VALIDATE_EMAIL`; JSP valida el formato habitual mediante una expresión regular. No son validadores RFC idénticos: algunos correos poco habituales (por ejemplo, local-part entre comillas) pueden diferir. Ninguna versión verifica existencia del buzón. Los límites HTML pueden contar caracteres suplementarios de forma diferente al servidor.

PHP almacena una inscripción en `$_SESSION`; JSP, en `session.setAttribute()`. Se conserva al actualizar el resumen mientras siga viva la sesión y su cookie. Una nueva inscripción válida reemplaza la anterior. Sin cookie o al expirar la sesión aparece el mensaje de ausencia. Un envío inválido no modifica una inscripción válida anterior. PHP y Tomcat gestionan sesiones independientes, sin compartir datos automáticamente.

## Documentación y entrega

- [Comparación y fuentes oficiales](docs/comparacion-php-jsp.md)
- [Pruebas y capturas pendientes](docs/pruebas-y-evidencias.md)
- [Registro honesto del uso de IA](docs/uso-ia.md)

La guía exige 70 % de lógica y configuración manual. Esta generación completa por Codex **no acredita ese porcentaje**. Revisa el registro de IA antes de presentar la práctica.

No se han hecho commits ni push. Tras revisar y completar tus evidencias, puedes ejecutar tú:

```powershell
git status
git add README.md .gitignore docs evidencias php jsp
git commit -m "Implementa práctica Semana 09 en PHP y JSP"
git remote -v
# Si aún no existe origin, configura la URL real de tu repositorio:
# git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git
git branch --show-current
# Sustituye TU_RAMA por la salida anterior:
# git push -u origin TU_RAMA
```

