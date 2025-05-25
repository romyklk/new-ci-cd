<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class HomeController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(): Response
    {

        return $this->render('home/index.html.twig', [
            'controller_name' => 'HomeController',
        ]);
    }

    #[Route('/about', name: 'app_about')]
    public function about(): Response
    {
        return $this->render('home/about.html.twig', [
            'title' => 'À propos de nous',
            'description' => 'Page de présentation de notre application',
        ]);
    }

    #[Route('/contact', name: 'app_contact')]
    public function contact(): Response
    {
        return $this->render('home/contact.html.twig', [
            'title' => 'Contactez-nous',
            'email' => 'contact@example.com',
        ]);
    }

    #[Route('/services', name: 'app_services')]
    public function services(): Response
    {
        $services = [
            'Développement web',
            'Intégration continue',
            'Déploiement automatisé',
            'Formation technique',
        ];

        return $this->render('home/services.html.twig', [
            'title' => 'Nos services',
            'services' => $services,
        ]);
    }

    #[Route('/api/status', name: 'app_api_status')]
    public function apiStatus(): Response
    {
        $status = [
            'status' => 'OK',
            'version' => '1.0.0',
            'timestamp' => new \DateTime(),
            'environment' => $_ENV['APP_ENV'] ?? 'dev',
        ];

        return $this->json($status);
    }

    #[Route('/dashboard', name: 'app_dashboard')]
    public function dashboard(): Response
    {
        $stats = [
            'users_count' => 150,
            'projects_count' => 25,
            'deployments_today' => 8,
            'uptime' => '99.9%',
        ];

        return $this->render('home/dashboard.html.twig', [
            'title' => 'Tableau de bord',
            'stats' => $stats,
        ]);
    }
}
