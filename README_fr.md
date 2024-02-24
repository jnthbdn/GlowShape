# GlowShape 🌟
FR - [EN](README.md)

## Introduction
GlowShape est un projet open-source, vous permettant de créer vos propore litophanie.
> Une lithophanie est une œuvre gravée ou moulée en porcelaine très fine et translucide qui ne peut être vue clairement que rétro-éclairée par une source de lumière. Il s'agit d'une représentation ou une scène en intaille qui apparaît « en grisaille » (en niveaux de gris).  
> 
> Wikipedia - [https://fr.wikipedia.org/wiki/Lithophanie](https://fr.wikipedia.org/wiki/Lithophanie)

Grâce aux imprimantes 3D utilisant divers matériaux comme la résine ou le filament, il est désormais envisageable de créer des lithophanies. C'est dans le but de simplifier ce processus que ce logiciel, GlowShape, a été développé.

GlowShape offre la possibilité de créer des lithophanies plates ou en forme de cylindre (particulièrement adaptées pour être utilisées comme bougeoirs) à partir d'une image en couleur ou en noir et blanc. Il propose également toute une gamme de paramètres de base pour personnaliser le résultat final.

## Technologie
GlowShape utilise le [Godot 4](https://godotengine.org/) (prononcer "go - doh", [/ɡɔ.do/](http://ipa-reader.xyz/?text=%2F%C9%A1%C9%94.do%2F&voice=Mathieu)), un moteur de jeu open-source. Le langage utilisé pour les scripts est **GDScript** (plus performant que C# au moment de l'écriture).

GlowShape fonctione sur Linux (developé sur Ubuntu 🐧), Windows (non testé), Mac (non testé) et WebAssembly (non testé).

## Utilisation
### Lancer le programme
Deux méthodes sont possibles:
1. Télécherger la version qui correspondante à votre OS dans le dossier "export" (si disponible)
2. Cloner (ou télécharger) le projet, puis l'éxecuter depuis Godot

### Commande
- Clic gauche (vue 3D) : Rotation
- Clic droit (vue 3D) : Translation
- Touche `R`: Réinitialise la vue 3D

### Interface
#### Lithophanie
##### Main settings
Le premier élément de l'interface permet de choisir le fichier image utilisé pour générer la lithophanie. L'image ne doit pas dépasser 16384×16384 pixels. Il est déconseillé de charger des images avec une résolution excessive, tant pour les performances de l'application que pour la génération des fichiers finaux (voir Image settings - résolution).

La "Shape" représente la forme de base utilisée pour générer la lithophanie.

"Show image" affiche l'image d'origine dans la vue 3D.

##### Image settings
"Resolution" est l'un des paramètres les plus importants. Il permet de diviser la résolution de votre image d'origine. Par défaut, le programme générera 1 sommet par pixel de l'image source, ce qui peut rapidement produire des fichiers finaux très volumineux et trop détaillés.

"Color" inverse les couleurs de l'image de base (les couleurs claires deviennent foncées sur la lithophanie, et vice versa pour les couleurs sombres).

"Flip" applique un effet miroir (horizontal et/ou vertical) à l'image source.

##### Shape settings
Ces paramètres sont spécifiques à la forme de base sélectionnée dans les "Main settings".

###### Flat
"Width" et "Height" contrôlent respectivement la largeur et la hauteur de la lithophanie (en mm). La proportion de l'image source est automatiquement préservée.

###### Candle holder
"Height" et "Inner diameter" contrôlent respectivement la hauteur et le diamètre interne de la lithophanie (en mm). La proportion de l'image source est automatiquement préservée.

"Base height" représente l'épaisseur de la "base" du porte-bougie (en mm).

##### Lithophane settings
"Min thickness" et "Max thickness" définissent les valeurs d'épaisseur des zones "claires" et "sombres" (en mm).

#### Paramètres
Cette partie vous permet de personnaliser les réglages du logiciel.

"Rotation factor": contrôle la sensibilité de la souris lors de la rotation de la vue 3D.

"Translation factor": règle la sensibilité de la souris lors de la translation de la vue 3D.

"Zoom factor": ajuste la sensibilité de la souris lors du zoom/dézoom de la vue 3D.

"Object color": définit la couleur de la lithophanie dans la vue 3D.

## TO DO
- [ ] Formes
  - [ ] Concave
  - [ ] Convexe
  - [ ] Cube
  - [ ] Vase (paramétrable)

- [ ] Options
  - [ ] Bord supérieur
  - [ ] Bord inférieur


- [ ] Exportation
  - [ ] Fichier STEP
  - [ ] Optimiser fichier STL

- [ ] Divers
  - [ ] Tester version Windows
  - [ ] Tester version Mac
  - [ ] Tester version WebAssembly
  - [ ] Héberger WebAssembly sur GitHub (si possible)
  - [ ] Utiliser les release GitHub
