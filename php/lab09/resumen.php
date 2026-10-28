<?php
declare(strict_types=1);
require_once __DIR__ . '/config.php';
$inscripcion = $_SESSION['inscripcion'] ?? null;
?>
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
    <?php if (is_array($inscripcion)): ?>
      <span class="badge">Inscripción confirmada</span>
      <h1>¡Ya eres parte!</h1>
      <p class="intro">Estos son los datos de tu inscripción al taller.</p>
      <dl class="summary">
        <dt>Nombre completo</dt><dd><?= escapar($inscripcion['nombre']) ?></dd>
        <dt>Correo electrónico</dt><dd><?= escapar($inscripcion['correo']) ?></dd>
        <dt>Taller</dt><dd><?= escapar(TALLERES[$inscripcion['taller']]) ?></dd>
      </dl>
      <p class="footnote">Puedes actualizar esta página: los datos se mantienen en tu sesión. Una nueva inscripción reemplaza la anterior.</p>
    <?php else: ?>
      <span class="badge">Un paso por comenzar</span>
      <h1>Aún no te has inscrito.</h1>
      <p class="intro">Completa el formulario para elegir tu taller universitario.</p>
    <?php endif; ?>
    <a class="button" href="index.html">Volver al formulario</a>
  </main>
</body>
</html>

