<?php
$name = $_ENV['APP_NAME'] ?? 'Application name not found!';
echo "<h1>Hello! It's application '{$name}' and server is working!</h1>";
