<?php
declare(strict_types=1);
require_once __DIR__ . '/config.php';

$errores = [];
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    header('Allow: POST');
    $errores[] = 'Este enlace recibe únicamente formularios enviados por POST.';
} else {
    // FILTER_REQUIRE_SCALAR rechaza entradas como nombre[]=valor.
    $nombre = filter_input(INPUT_POST, 'nombre', FILTER_UNSAFE_RAW, FILTER_REQUIRE_SCALAR);
    $correo = filter_input(INPUT_POST, 'correo', FILTER_UNSAFE_RAW, FILTER_REQUIRE_SCALAR);
    $taller = filter_input(INPUT_POST, 'taller', FILTER_UNSAFE_RAW, FILTER_REQUIRE_SCALAR);
    $nombre = is_string($nombre) ? trim($nombre) : '';
    $correo = is_string($correo) ? trim($correo) : '';
    $taller = is_string($taller) ? trim($taller) : '';

    // Contar caracteres UTF-8 sin requerir extensiones adicionales.
    $longitud = preg_match_all('/./us', $nombre);
    if ($nombre === '' || $longitud === false || $longitud > 100) {
        $errores[] = 'Escribe un nombre de entre 1 y 100 caracteres.';
    }
    if (strlen($correo) > 254 || !filter_var($correo, FILTER_VALIDATE_EMAIL)) {
        $errores[] = 'Escribe un correo electrónico válido de hasta 254 caracteres.';
    }
    if (!array_key_exists($taller, TALLERES)) {
        $errores[] = 'Selecciona uno de los talleres disponibles.';
    }
    if (!$errores) {
        $_SESSION['inscripcion'] = ['nombre' => $nombre, 'correo' => $correo, 'taller' => $taller];
        header('Location: resumen.php', true, 302);
        exit;
    }
    http_response_code(400);
}
?>
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
        <?php foreach ($errores as $error): ?>
          <li><?= escapar($error) ?></li>
        <?php endforeach; ?>
      </ul>
    </div>
    <a class="button" href="index.html">Volver al formulario</a>
  </main>
</body>
</html>

