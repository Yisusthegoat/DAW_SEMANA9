<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" isErrorPage="true" %>
<%-- En Jasper, permite que este scriptlet controle también OPTIONS/PUT y devuelva Allow: POST.
     No se registra como página de errores en web.xml. --%>
<%@ page import="java.util.ArrayList,java.util.List,java.util.Map" %>
<%!
    // Escape para texto HTML; EL sola no realiza este escape automáticamente.
    private String escapar(String valor) {
        return valor.replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#039;");
    }
%>
<%
    // Scriptlet pedagógico: toda decisión y redirección sucede antes del HTML.
    request.setCharacterEncoding("UTF-8");
    List<String> errores = new ArrayList<>();
    Map<String, String> talleres = Map.of(
        "php", "Desarrollo Web con PHP",
        "java", "Desarrollo Web con Java",
        "redes", "Redes y Comunicaciones");
    if (!"POST".equals(request.getMethod())) {
        response.setStatus(405);
        response.setHeader("Allow", "POST");
        errores.add("Este enlace recibe únicamente formularios enviados por POST.");
    } else {
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String taller = request.getParameter("taller");
        nombre = nombre == null ? "" : nombre.trim();
        correo = correo == null ? "" : correo.trim();
        taller = taller == null ? "" : taller.trim();
        if (nombre.isEmpty() || nombre.codePointCount(0, nombre.length()) > 100) {
            errores.add("Escribe un nombre de entre 1 y 100 caracteres.");
        }
        // Formato habitual de correo; no verifica que el buzón exista.
        String patronCorreo = "^[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$";
        if (correo.length() > 254 || !correo.matches(patronCorreo)
                || correo.indexOf('@') > 64) {
            errores.add("Escribe un correo electrónico válido de hasta 254 caracteres.");
        }
        if (!talleres.containsKey(taller)) {
            errores.add("Selecciona uno de los talleres disponibles.");
        }
        if (errores.isEmpty()) {
            session.setAttribute("inscripcion", Map.of(
                "nombre", nombre, "correo", correo, "taller", talleres.get(taller)));
            response.sendRedirect("resumen.jsp"); // HTTP 302.
            return;
        }
        response.setStatus(400);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Revisa tu inscripción | Campus</title>
  <link rel="stylesheet" href="assets/styles.css">
</head>
<body>
  <main class="card">
    <p class="eyebrow">CAMPUS · TALLERES UNIVERSITARIOS</p>
    <span class="badge">Revisemos los datos</span>
    <h1>No pudimos completar tu inscripción.</h1>
    <div class="notice error" role="alert">
      <ul>
        <% for (String error : errores) { %>
          <li><%= escapar(error) %></li>
        <% } %>
      </ul>
    </div>
    <a class="button" href="index.jsp">Volver al formulario</a>
  </main>
</body>
</html>

