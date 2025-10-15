# pironman_dashboard
Un tableau de bord en bash, conçu pour afficher en temps réel les statistiques du Raspberry Pi 5 équipé d’un boîtier Pironman 5.

## Fonctionnalités

- Affiche l’adresse IP locale
- Température CPU avec code couleur dynamique
- Statut du ventilateur du boîtier Pironman (`ON` / `OFF`)
- Utilisation CPU par cœur (barres animées en caractères `⣿`)
- Utilisation de la RAM
- Couleurs dynamiques et affichage style *btop*
- Rafraîchissement automatique (1 seconde)

---
## Installation

```bash
git clone https://github.com/Crabouille777/pironman-dashboard.git
cd pironman-dashboard
chmod +x pironman_dashboard.sh
