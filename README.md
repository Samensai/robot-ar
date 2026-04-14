# ROBOT::AR — Prototype v0.1

Prototype de jeu de combat de robots en réalité augmentée.

## Stack

- **Three.js r128** — rendu 3D
- **WebXR Device API** — AR (Android Chrome + ARCore uniquement)
- **PWA** — installable, fonctionne offline

## Déploiement sur GitHub Pages

```bash
# 1. Crée un nouveau repo GitHub (ex: robot-ar)
# 2. Clone et copie les fichiers
git init
git add .
git commit -m "feat: prototype AR solo v0.1"
git branch -M main
git remote add origin https://github.com/TON_USERNAME/robot-ar.git
git push -u origin main

# 3. Dans les settings du repo :
#    Settings → Pages → Source → Deploy from branch → main / root
```

Le site sera disponible sur : `https://TON_USERNAME.github.io/robot-ar/`

> ⚠️ WebXR AR nécessite HTTPS — GitHub Pages gère ça automatiquement.

## Compatibilité

| Plateforme | Mode |
|---|---|
| Android Chrome + ARCore | ✅ AR réel avec détection de surface |
| iPhone Safari | ⚠️ Mode 3D (WebXR AR non supporté) |
| Desktop Chrome | 🖥️ Mode 3D + clavier |

## Contrôles

| Contrôle | Action |
|---|---|
| Joystick (gauche) | Déplacer le robot |
| ROT L / ROT R | Pivoter |
| RESET | Remettre à l'origine |
| Flèches / WASD / ZQSD | Clavier (desktop) |

**Mode AR (Android)** : pointer la caméra vers une surface plane, puis appuyer sur `[ PLACER LE ROBOT ]`.

## Roadmap

- [x] v0.1 — Robot solo, déplacement, mode 3D fallback
- [ ] v0.2 — Multijoueur WebRTC P2P (2 joueurs, même réseau)
- [ ] v0.3 — Espace AR partagé (synchronisation des coordonnées)
- [ ] v0.4 — Build modulaire (pièces avec stats)
