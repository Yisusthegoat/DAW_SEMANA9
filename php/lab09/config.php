<?php
declare(strict_types=1);

// Compartido: abrir la sesión antes de enviar contenido o cabeceras de redirección.
session_name('LAB09PHP');
session_start();
header('Content-Type: text/html; charset=UTF-8');

const TALLERES = [
    'php' => 'Desarrollo Web con PHP',
    'java' => 'Desarrollo Web con Java',
    'redes' => 'Redes y Comunicaciones',
];

function escapar(string $valor): string
{
    return htmlspecialchars($valor, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

