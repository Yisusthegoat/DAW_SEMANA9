<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.Map" %>
<%!
    // Escape para texto HTML; EL sola no realiza este escape automáticamente.
    private String escapar(String valor) {
        return valor.replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#039;");
    }
%>
<%
    Object datos = session.getAttribute("inscripcion");
    Map<?, ?> inscripcion = datos instanceof Map ? (Map<?, ?>) datos : null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Tu inscripción | Campus</title>
  <link rel="stylesheet" href="assets/styles.css">
</head>
<body>
  <main class="card">
    <p class="eyebrow">CAMPUS · TALLERES UNIVERSITARIOS</p>
    <% if (inscripcion != null) { %>
      <span class="badge">Inscripción confirmada</span>
      <h1>¡Ya eres parte!</h1>
      <p class="intro">Estos son los datos de tu inscripción al taller.</p>
      <dl class="summary">
        <dt>Nombre completo</dt><dd><%= escapar(String.valueOf(inscripcion.get("nombre"))) %></dd>
        <dt>Correo electrónico</dt><dd><%= escapar(String.valueOf(inscripcion.get("correo"))) %></dd>
        <dt>Taller</dt><dd><%= escapar(String.valueOf(inscripcion.get("taller"))) %></dd>
      </dl>
      <p class="footnote">Puedes actualizar esta página: los datos se mantienen en tu sesión. Una nueva inscripción reemplaza la anterior.</p>
    <% } else { %>
      <span class="badge">Un paso por comenzar</span>
      <h1>Aún no te has inscrito.</h1>
      <p class="intro">Completa el formulario para elegir tu taller universitario.</p>
    <% } %>
    <a class="button" href="index.jsp">Volver al formulario</a>
  </main>
</body>
</html>

