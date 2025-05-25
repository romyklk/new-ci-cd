<?php

declare(strict_types=1);

use PhpCsFixer\Config;
use PhpCsFixer\Finder;

// Création du Finder qui cible les dossiers à analyser : src, tests et config
$finder = Finder::create()
    ->in(__DIR__ . '/src')
    ->in(__DIR__ . '/tests')
    ->in(__DIR__ . '/config');

// Création d’une nouvelle instance Config
return (new Config())
    // Autorise les règles risquées (qui peuvent modifier le comportement du code)
    ->setRiskyAllowed(true)
    // Définit les règles à appliquer pour le formatage et la qualité du code
    ->setRules([
        '@Symfony' => true, // Applique les règles de codage officielles Symfony (basées sur PSR standards)
        '@PSR12' => true,                 // Applique le standard de codage PSR-12
        'strict_param' => true,           // Forcer les paramètres à être stricts
        'array_syntax' => ['syntax' => 'short'], // Utilise la syntaxe courte [] pour les tableaux
        'no_unused_imports' => true,     // Supprime automatiquement les imports inutilisés (use ...)
        'phpdoc_no_empty_return' => true, // Interdit les retours vides @return dans les PHPDoc
        'no_trailing_comma_in_singleline' => true, // Supprime la virgule finale dans les tableaux ou arguments sur une seule ligne
        'single_quote' => true,           // Force l’usage des simples quotes pour les chaînes (sauf si besoin d’interpolation)
        'ordered_imports' => true,        // Trie les imports par ordre alphabétique
        'no_whitespace_in_blank_line' => true, // Supprime les espaces inutiles dans les lignes vides
        'linebreak_after_opening_tag' => true, // Force un saut de ligne après la balise d’ouverture PHP
        'no_extra_blank_lines' => true,   // Supprime les lignes vides superflues
        'concat_space' => false,          // Désactive la règle de formatage des espaces de concaténation
        'class_attributes_separation' => [
            'elements' => ['method' => 'one'],
        ], // Sépare les méthodes par une ligne vide
        'no_whitespace_before_comma_in_array' => true,      // Pas d’espace avant les virgules dans les tableaux
    ])
    // Applique le Finder défini pour cibler les fichiers concernés
    ->setFinder($finder);
