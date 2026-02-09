# pironman_dashboard
[![Licence : GPL v2+](https://img.shields.io/badge/Licence-GPL%20v2%2B-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Raspberry%20Pi%205-C51A4A.svg)](https://www.raspberrypi.com/)
[![Architecture](https://img.shields.io/badge/Arch-ARM64%20%28aarch64%29-lightgrey.svg)](#)
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20sh-brightgreen.svg)](https://www.gnu.org/software/bash/)
[![OS](https://img.shields.io/badge/OS-Raspberry%20Pi%20OS%20%7C%20Debian-lightgrey.svg)](#)
[![Version](https://img.shields.io/badge/version-1.0.1-blue.svg)](#)


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
git clone https://github.com/mp-weblab/pironman_dashboard.git
cd pironman-dashboard
chmod +x pironman_dashboard.sh
