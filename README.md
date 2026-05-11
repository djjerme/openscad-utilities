# OpenSCAD Utilities

This repository contains a portable OpenSCAD setup plus a small parametric library for architectural openings such as windows and doors.

OpenSCAD does not have classes, so the library is built around reusable modules with named parameters. The main entry points are `window_unit(...)` and `door_unit(...)`.

## Repository layout

- `architectural_openings.scad`: reusable library with window and door modules
- `examples/demo_scene.scad`: quick preview scene using the built-in `demo_scene()` module
- `examples/custom_openings.scad`: simple example showing direct calls to `window_unit(...)` and `door_unit(...)`
- `openscad.cmd`: local launcher for the portable OpenSCAD runtime
- `setup-openscad.ps1`: downloads and installs OpenSCAD into `tools/OpenSCAD`

## Quick start

Install the local OpenSCAD runtime if needed:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-openscad.ps1
```

Confirm the local launcher works:

```powershell
.\openscad.cmd --version
```

Preview the example scene in the OpenSCAD GUI:

```powershell
.\openscad.cmd .\examples\demo_scene.scad
```

Or render it from the command line:

```powershell
.\openscad.cmd -o .\build\demo_scene.stl .\examples\demo_scene.scad
```

## Library usage

Use the library from another `.scad` file:

```scad
use <architectural_openings.scad>;

window_unit(
    width = 54,
    depth = 5,
    height = 64,
    pane_cols = 3,
    pane_rows = 2,
    mullions = true,
    has_sill = true,
    has_apron = true
);
```

Example door call:

```scad
use <architectural_openings.scad>;

door_unit(
    width = 42,
    depth = 2,
    height = 84,
    include_frame = true,
    functional = true,
    open_angle = 28,
    hinge = "left",
    decorative = true
);
```

## Notes

- The portable OpenSCAD runtime is intentionally excluded from git.
- Generated geometry and preview outputs are ignored through `.gitignore`.
- The launcher and installer are written to keep working after moving this folder.
