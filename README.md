# GlowShape 🌟
[FR](README_fr.md) - EN

## Introduction
GlowShape is an open-source project that allows you to create your own lithophanies.
> A lithophane is a thin plaque of translucent material, normally porcelain, which has been moulded to varying thickness, such that when lit from behind the different thicknesses show as different shades, forming an image. Only when lit from behind does the image display properly.
> 
> Wikipedia - [https://en.wikipedia.org/wiki/Lithophane](https://en.wikipedia.org/wiki/Lithophane)

Thanks to 3D printers using various materials such as resin or filament, it is now possible to create lithophanies. This software, GlowShape, has been developed with the aim of simplifying this process.

GlowShape offers the ability to create flat lithophanies or cylinder-shaped ones (particularly suitable for use as candle holders) from a color or black-and-white image. It also provides a range of basic parameters to customize the final result.

## Technology
GlowShape utilizes [Godot 4](https://godotengine.org/) (pronounced "go-dough", [/ɡɔ.do/](http://ipa-reader.xyz/?text=%2F%C9%A1%C9%94.do%2F&voice=Joey)), an open-source game engine. The code used for scripting is in **GDScript** (more efficient than C# at the time of writing).

GlowShape runs on Linux (developed on Ubuntu 🐧), Windows (untested), Mac (untested), and WebAssembly (untested).

## Usage
### Running the program
Two methods are possible:
1. Download the version corresponding to your OS from the "[export](export/)" folder (if available).
2. Clone (or download) the project, then run it from Godot.

### Commands
- Left click (3D view): Rotation
- Right click (3D view): Translation
- `R` key: Reset 3D view

### Interface
#### Lithophane
##### Main Settings
The first element of the interface allows you to select the image file used to generate the lithophane. The image should not exceed 16384×16384 pixels. It is advisable not to load images with excessive resolution, both for the application's performance and for the generation of final files (see Image settings - resolution).

The "Shape" represents the basic form used to generate the lithophane.

"Show image" displays the original image in the 3D view.

##### Image Settings
"Resolution" is one of the most important parameters. It divides the resolution of your original image. By default, the program generates 1 vertex per pixel of the source image, which can quickly produce very large and overly detailed final files.

"Color" reverses the colors of the base image (light colors become dark on the lithophane, and vice versa for dark colors).

"Flip" applies a mirror effect (horizontal and/or vertical) to the source image.

##### Shape Settings
These parameters are specific to the selected basic shape in "Main Settings".

###### Flat
"Width" and "Height" control the width and height of the lithophane, respectively (in mm). The proportion of the source image is automatically preserved.

###### Candle Holder
"Height" and "Inner diameter" respectively control the height and internal diameter of the lithophane (in mm). The proportion of the source image is automatically preserved.

"Base height" represents the thickness of the "base" of the candle holder (in mm).

##### Lithophane Settings
"Min thickness" and "Max thickness" define the thickness values of the "light" and "dark" areas (in mm).

### Settings
This section allows you to customize the software settings.

"Rotation factor": controls the mouse sensitivity when rotating the 3D view.

"Translation factor": adjusts the mouse sensitivity when translating the 3D view.

"Zoom factor": sets the mouse sensitivity when zooming in/out of the 3D view.

"Object color": defines the color of the lithophane in the 3D view.


## TO DO
- [ ] Shapes
  - [ ] Concave
  - [ ] Convex
  - [ ] Cube
  - [ ] Vase (configurable)

- [ ] Options
  - [ ] Top border
  - [ ] Bottom border

- [ ] Export
  - [ ] STEP file
  - [ ] Optimize STL file

- [ ] Miscellaneous
  - [ ] Test Windows version
  - [ ] Test Mac version
  - [ ] Test WebAssembly version
  - [ ] Host WebAssembly on GitHub (if possible)
  - [ ] Use GitHub releases
