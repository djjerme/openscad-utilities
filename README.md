# OpenSCAD Utilities

This folder contains a small OpenSCAD utility setup for parametric architectural parts.

## Included files

- `architectural_openings.scad`: parametric window and door modules
- `openscad.cmd`: workspace-local launcher for the portable OpenSCAD install
- `setup-openscad.ps1`: downloads and installs the local OpenSCAD runtime into `tools/OpenSCAD`
- `.gitignore`: keeps the downloaded OpenSCAD binaries out of source control

## Quick start

Run OpenSCAD from this folder:

```powershell
.\openscad.cmd --version
```

Reinstall the local OpenSCAD runtime if needed:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-openscad.ps1
```

## Notes

- The portable OpenSCAD runtime is intentionally kept out of git.
- The launcher and installer are written to work after moving this folder to another location.
