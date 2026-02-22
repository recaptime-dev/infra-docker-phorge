<?php

/*
 * Portions of this Preamble file is made with assistance from Gemini
 * via the Google Gemini webapp. If you want to tweak this, you would
 * edit this and rebuild yourself or mount this file at runtime (not
 * recommended).
 */

// Trust the X-Forwarded-Host provided by Cloud Workstations and friends
if ($workstationHost = $_SERVER['HTTP_X_FORWARDED_HOST'] ?? null) {
    $_SERVER['HTTP_HOST'] = $workstationHost;
    $_SERVER['HTTPS'] = 'on';
} else {
    // Ensure standard Phorge behavior
    if (getenv("SSL_TYPE") === "external") {
        $_SERVER['HTTPS'] = 'on';
    }

    if (getenv("PHORGE_FORCE_HOST") === "true") { 
        preamble_trust_x_forwarded_for_header(3);
        $_SERVER["HTTP_HOST"] = getenv("PHORGE_HOST") ?: "phorge.localhost"; 
    }
}