# Makefile pour la gestion de l'environnement Docker

.PHONY: help build up down restart logs clean install test

# Variables
DOCKER_COMPOSE = docker-compose
APP_CONTAINER = first-ci-cd-web-1
DB_CONTAINER = first-ci-cd-db-1
PHPMYADMIN_CONTAINER = first-ci-cd-phpmyadmin-1

help: ## Affiche cette aide
	@echo "Commandes disponibles :"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Construit les images Docker
	$(DOCKER_COMPOSE) build --no-cache

up: ## Démarre tous les services
	$(DOCKER_COMPOSE) up -d

down: ## Arrête tous les services
	$(DOCKER_COMPOSE) down

restart: ## Redémarre tous les services
	$(DOCKER_COMPOSE) restart

logs: ## Affiche les logs de tous les services
	$(DOCKER_COMPOSE) logs -f

logs-web: ## Affiche les logs du service Web
	$(DOCKER_COMPOSE) logs -f web

logs-db: ## Affiche les logs du service MySQL
	$(DOCKER_COMPOSE) logs -f db

logs-phpmyadmin: ## Affiche les logs du service phpMyAdmin
	$(DOCKER_COMPOSE) logs -f phpmyadmin

shell: ## Ouvre un shell dans le conteneur Web
	docker exec -it $(APP_CONTAINER) /bin/bash

shell-web: ## Ouvre un shell dans le conteneur Web
	docker exec -it $(APP_CONTAINER) /bin/bash

shell-db: ## Ouvre un shell MySQL
	docker exec -it $(DB_CONTAINER) mysql -u root -p

shell-db-user: ## Ouvre un shell MySQL avec l'utilisateur app
	docker exec -it $(DB_CONTAINER) mysql -u app_user -p app_db

enter: shell ## Alias pour rentrer dans le container web

# Commandes Docker
ps: ## Affiche les containers en cours d'exécution
	$(DOCKER_COMPOSE) ps

status: ## Affiche le statut des conteneurs
	$(DOCKER_COMPOSE) ps

images: ## Affiche les images Docker
	docker images

networks: ## Affiche les réseaux Docker
	docker network ls

volumes: ## Affiche les volumes Docker
	docker volume ls

clean: ## Nettoie les ressources Docker inutilisées
	docker system prune -f

# Commandes Symfony
composer-install: ## Installe les dépendances Composer
	docker exec -it $(APP_CONTAINER) composer install

composer-update: ## Met à jour les dépendances Composer
	docker exec -it $(APP_CONTAINER) composer update

sf-console: ## Accès à la console Symfony (usage: make sf-console CMD="votre-commande")
	docker exec -it $(APP_CONTAINER) php bin/console $(CMD)

sf-cache-clear: ## Vide le cache Symfony
	docker exec -it $(APP_CONTAINER) php bin/console cache:clear

sf-cache-warmup: ## Réchauffe le cache Symfony
	docker exec -it $(APP_CONTAINER) php bin/console cache:warmup

# Commandes de base de données
db-create: ## Crée la base de données
	docker exec -it $(APP_CONTAINER) php bin/console doctrine:database:create --if-not-exists

db-drop: ## Supprime la base de données
	docker exec -it $(APP_CONTAINER) php bin/console doctrine:database:drop --force --if-exists

db-schema-update: ## Met à jour le schéma de la base de données
	docker exec -it $(APP_CONTAINER) php bin/console doctrine:schema:update --force

make-migration: ## Génère une migration
	docker exec -it $(APP_CONTAINER) php bin/console make:migration

migrate: ## Exécute les migrations
	docker exec -it $(APP_CONTAINER) php bin/console doctrine:migrations:migrate --no-interaction

# Commandes utiles
install: composer-install ## Installe le projet

init: build up install ## Initialisation complète du projet
	@echo "🎉 Projet initialisé avec succès !"
	@echo "📱 Application : http://localhost:8080"
	@echo "🗄️  phpMyAdmin : http://localhost:8081"

# Commandes de test
test: ## Lance les tests PHPUnit
	docker exec -it $(APP_CONTAINER) php bin/phpunit

# Commandes pour les variables d'environnement
show-env: ## Affiche les variables d'environnement chargées
	@echo "Variables depuis ./app/.env:"
	@cat ./app/.env | grep -E "^[A-Z_]+"
	@echo "\nVariables depuis ./.env.docker:"
	@cat ./.env.docker | grep -E "^[A-Z_]+"

# Commandes Docker supplémentaires
ps: ## Affiche les containers en cours d'exécution
	docker ps

images: ## Affiche les images Docker
	docker images

networks: ## Affiche les réseaux Docker
	docker network ls

volumes: ## Affiche les volumes Docker
	docker volume ls

inspect-web: ## Inspecte le container web
	docker inspect $(APP_CONTAINER)

inspect-db: ## Inspecte le container base de données
	docker inspect $(DB_CONTAINER)

# Commandes de développement Symfony
composer-install: ## Installe les dépendances Composer
	docker exec -it $(APP_CONTAINER) composer install

composer-update: ## Met à jour les dépendances Composer
	docker exec -it $(APP_CONTAINER) composer update

composer-require: ## Installe un package Composer (usage: make composer-require PACKAGE=nom-du-package)
	docker exec -it $(APP_CONTAINER) composer require $(PACKAGE)

sf-console: ## Accède à la console Symfony (usage: make sf-console CMD="votre-commande")
	docker exec -it $(APP_CONTAINER) php bin/console $(CMD)

sf-cache-clear: ## Vide le cache Symfony
	docker exec -it $(APP_CONTAINER) php bin/console cache:clear

sf-cache-warmup: ## Réchauffe le cache Symfony
	docker exec -it $(APP_CONTAINER) php bin/console cache:warmup

sf-make-controller: ## Crée un controller Symfony (usage: make sf-make-controller NAME=NomController)
	docker exec -it $(APP_CONTAINER) php bin/console make:controller $(NAME)

sf-make-entity: ## Crée une entité Symfony (usage: make sf-make-entity NAME=NomEntity)
	docker exec -it $(APP_CONTAINER) php bin/console make:entity $(NAME)

# Commandes de base de données
db-create: ## Crée la base de données
	docker exec -it $(APP_CONTAINER) php bin/console doctrine:database:create --if-not-exists

db-drop: ## Supprime la base de données
	docker exec -it $(APP_CONTAINER) php bin/console doctrine:database:drop --force --if-exists

db-schema-update: ## Met à jour le schéma de la base de données
	docker exec -it $(APP_CONTAINER) php bin/console doctrine:schema:update --force

db-schema-validate: ## Valide le schéma de la base de données
	docker exec -it $(APP_CONTAINER) php bin/console doctrine:schema:validate

make-migration: ## Génère une migration
	docker exec -it $(APP_CONTAINER) php bin/console make:migration

# Commandes Symfony pour la gestion des utilisateurs
create-user: ## Crée un nouvel utilisateur (usage: make create-user USERNAME=nom PASSWORD=motdepasse)
	docker exec -it $(APP_CONTAINER) php bin/console app:create-user $(USERNAME) $(PASSWORD)

delete-user: ## Supprime un utilisateur (usage: make delete-user USERNAME=nom)
	docker exec -it $(APP_CONTAINER) php bin/console app:delete-user $(USERNAME)

list-users: ## Liste tous les utilisateurs
	docker exec -it $(APP_CONTAINER) php bin/console app:list-users

# Commandes pour la gestion des rôles
create-role: ## Crée un nouveau rôle (usage: make create-role ROLE=nom)
	docker exec -it $(APP_CONTAINER) php bin/console app:create-role $(ROLE)

delete-role: ## Supprime un rôle (usage: make delete-role ROLE=nom)
	docker exec -it $(APP_CONTAINER) php bin/console app:delete-role $(ROLE)

list-roles: ## Liste tous les rôles
	docker exec -it $(APP_CONTAINER) php bin/console app:list-roles

# Commandes pour la gestion des permissions
create-permission: ## Crée une nouvelle permission (usage: make create-permission PERMISSION=nom)
	docker exec -it $(APP_CONTAINER) php bin/console app:create-permission $(PERMISSION)

delete-permission: ## Supprime une permission (usage: make delete-permission PERMISSION=nom)
	docker exec -it $(APP_CONTAINER) php bin/console app:delete-permission $(PERMISSION)

list-permissions: ## Liste toutes les permissions
	docker exec -it $(APP_CONTAINER) php bin/console app:list-permissions

# Commandes pour la gestion des sessions
list-sessions: ## Liste toutes les sessions
	docker exec -it $(APP_CONTAINER) php bin/console app:list-sessions

invalidate-session: ## Invalide une session (usage: make invalidate-session SESSION_ID=id)
	docker exec -it $(APP_CONTAINER) php bin/console app:invalidate-session $(SESSION_ID)

# Commandes pour la gestion des tokens
generate-token: ## Génère un nouveau token (usage: make generate-token USERNAME=nom)
	docker exec -it $(APP_CONTAINER) php bin/console app:generate-token $(USERNAME)

revoke-token: ## Révoque un token (usage: make revoke-token TOKEN=valeur)
	docker exec -it $(APP_CONTAINER) php bin/console app:revoke-token $(TOKEN)

list-tokens: ## Liste tous les tokens
	docker exec -it $(APP_CONTAINER) php bin/console app:list-tokens

# Commandes pour la gestion des emails
send-test-email: ## Envoie un email de test (usage: make send-test-email TO=adresse@example.com)
	docker exec -it $(APP_CONTAINER) php bin/console app:send-test-email $(TO)

list-emails: ## Liste tous les emails envoyés
	docker exec -it $(APP_CONTAINER) php bin/console app:list-emails

# Commandes pour la gestion des fichiers
upload-file: ## Télécharge un fichier (usage: make upload-file PATH=chemin/vers/fichier)
	docker cp $(APP_CONTAINER):/var/www/html/$(PATH) .

download-file: ## Télécharge un fichier depuis le conteneur (usage: make download-file PATH=chemin/vers/fichier)
	docker cp $(PATH) $(APP_CONTAINER):/var/www/html/

delete-file: ## Supprime un fichier (usage: make delete-file PATH=chemin/vers/fichier)
	docker exec -it $(APP_CONTAINER) rm -f /var/www/html/$(PATH)

# Commandes pour la gestion des répertoires
create-dir: ## Crée un répertoire (usage: make create-dir PATH=chemin/vers/repertoire)
	docker exec -it $(APP_CONTAINER) mkdir -p /var/www/html/$(PATH)

delete-dir: ## Supprime un répertoire (usage: make delete-dir PATH=chemin/vers/repertoire)
	docker exec -it $(APP_CONTAINER) rm -rf /var/www/html/$(PATH)

# Commandes pour la gestion des configurations
list-config: ## Liste les fichiers de configuration
	docker exec -it $(APP_CONTAINER) ls -l /var/www/html/config/

edit-config: ## Édite un fichier de configuration (usage: make edit-config FILE=nom-du-fichier)
	docker exec -it $(APP_CONTAINER) nano /var/www/html/config/$(FILE)

# Commandes pour la gestion des logs
tail-logs: ## Affiche les dernières lignes des logs (usage: make tail-logs SERVICE=nom-du-service)
	docker exec -it $(APP_CONTAINER) tail -n 50 /var/www/html/var/log/$(SERVICE).log

rotate-logs: ## Effectue une rotation des logs
	docker exec -it $(APP_CONTAINER) php bin/console log:rotate

# Commandes pour la gestion des tâches cron
list-cron: ## Liste les tâches cron
	docker exec -it $(APP_CONTAINER) crontab -l

edit-cron: ## Édite les tâches cron
	docker exec -it $(APP_CONTAINER) crontab -e

# Commandes pour la gestion des environnements
set-env: ## Définit une variable d'environnement (usage: make set-env KEY=valeur)
	docker exec -it $(APP_CONTAINER) /bin/bash -c "echo 'export $(KEY)=valeur' >> /var/www/html/.env"

unset-env: ## Supprime une variable d'environnement (usage: make unset-env KEY=valeur)
	docker exec -it $(APP_CONTAINER) /bin/bash -c "sed -i '/^export $(KEY)=/d' /var/www/html/.env"

# Commandes pour la gestion des performances
cache-clear: ## Vide le cache de l'application
	docker exec -it $(APP_CONTAINER) php bin/console cache:clear

opcache-status: ## Affiche l'état d'OPcache
	docker exec -it $(APP_CONTAINER) php -r "opcache_get_status();"

opcache-clear: ## Vide le cache d'OPcache
	docker exec -it $(APP_CONTAINER) php -r "opcache_reset();"

# Commandes pour la gestion des mises à jour
update-symfony: ## Met à jour Symfony vers la dernière version mineure
	docker exec -it $(APP_CONTAINER) composer update symfony/*

upgrade-symfony: ## Met à jour Symfony vers la dernière version majeure
	docker exec -it $(APP_CONTAINER) composer require symfony/symfony:^6.0 --update-with-dependencies

# Commandes pour la gestion des dépendances
check-dependencies: ## Vérifie les dépendances obsolètes
	docker exec -it $(APP_CONTAINER) composer outdated

remove-unused-dependencies: ## Supprime les dépendances inutilisées
	docker exec -it $(APP_CONTAINER) composer remove $(shell composer show --unused | awk '{print $$1}')

# Commandes pour la gestion des assets
install-assets: ## Installe les assets (CSS, JS, images)
	docker exec -it $(APP_CONTAINER) php bin/console assets:install

dump-assets: ## Génère le fichier de manifeste des assets
	docker exec -it $(APP_CONTAINER) php bin/console assetic:dump

# Commandes pour la gestion des traductions
extract-translations: ## Extrait les traductions vers des fichiers XLIFF
	docker exec -it $(APP_CONTAINER) php bin/console translation:extract

update-translations: ## Met à jour les traductions
	docker exec -it $(APP_CONTAINER) php bin/console translation:update

# Commandes pour la gestion des tests
run-tests: ## Exécute les tests PHPUnit
	docker exec -it $(APP_CONTAINER) php bin/phpunit

code-coverage: ## Génère le rapport de couverture de code
	docker exec -it $(APP_CONTAINER) php bin/phpunit --coverage-html=coverage/

# Commandes pour la gestion des backups
backup-db: ## Sauvegarde la base de données
	docker exec -it $(DB_CONTAINER) /usr/bin/mysqldump -u app_user -p app_db > backup.sql

restore-db: ## Restaure la base de données à partir d'une sauvegarde
	docker exec -i $(DB_CONTAINER) /usr/bin/mysql -u app_user -p app_db < backup.sql

# Commandes pour la gestion des déploiements
deploy: ## Déploie l'application sur le serveur de production
	scp -r ./* user@production-server:/path/to/your/app
	ssh user@production-server "cd /path/to/your/app && docker-compose up -d --build"

rollback: ## Annule le dernier déploiement
	ssh user@production-server "cd /path/to/your/app && git checkout . && docker-compose down -v"

# Commandes pour la gestion des notifications
send-slack-notification: ## Envoie une notification sur Slack (usage: make send-slack-notification MESSAGE="Votre message")
	curl -X POST -H 'Content-type: application/json' --data '{"text":"$(MESSAGE)"}' https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX

send-email-notification: ## Envoie une notification par email (usage: make send-email-notification TO=adresse@example.com SUBJECT="Sujet" BODY="Corps du message")
	echo "$(BODY)" | mail -s "$(SUBJECT)" $(TO)

# Commandes pour la gestion des services externes
check-service-status: ## Vérifie l'état d'un service externe (usage: make check-service-status SERVICE=nom-du-service)
	curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/$(SERVICE)/status

restart-service: ## Redémarre un service externe (usage: make restart-service SERVICE=nom-du-service)
	curl -X POST http://localhost:8080/$(SERVICE)/restart

# Commandes pour la gestion des tâches planifiées
schedule-task: ## Planifie une tâche (usage: make schedule-task COMMAND="votre-commande" CRON="* * * * *")
	echo "$(CRON) $(COMMAND)" | docker exec -i $(APP_CONTAINER) crontab -

unschedule-task: ## Déplanifie une tâche (usage: make unschedule-task COMMAND="votre-commande")
	docker exec -it $(APP_CONTAINER) crontab -l | grep -v "$(COMMAND)" | docker exec -i $(APP_CONTAINER) crontab -

# Commandes pour la gestion des environnements de développement
setup-dev-env: ## Configure l'environnement de développement
	docker-compose -f docker-compose.dev.yml up -d

teardown-dev-env: ## Détruit l'environnement de développement
	docker-compose -f docker-compose.dev.yml down -v

# Commandes pour la gestion des environnements de test
setup-test-env: ## Configure l'environnement de test
	docker-compose -f docker-compose.test.yml up -d

teardown-test-env: ## Détruit l'environnement de test
	docker-compose -f docker-compose.test.yml down -v

# Commandes pour la gestion des environnements de production
setup-prod-env: ## Configure l'environnement de production
	docker-compose -f docker-compose.prod.yml up -d

teardown-prod-env: ## Détruit l'environnement de production
	docker-compose -f docker-compose.prod.yml down -v

status: ## Affiche le statut des conteneurs
	$(DOCKER_COMPOSE) ps

init: build up install migration ## Initialisation complète du projet
	@echo "🎉 Projet initialisé avec succès !"
	@echo "📱 Application : http://localhost:8080"
	@echo "🗄️  phpMyAdmin : http://localhost:8081"
