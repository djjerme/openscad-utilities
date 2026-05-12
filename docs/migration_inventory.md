# Migration Inventory

This document tracks which existing projects should move window and door logic into `architectural_openings.scad`, and which behaviors should stay local until they are proven reusable.

## Working rules

1. Use the shared library for repeated opening geometry.
2. Keep project-specific wall framing, siding, panel tongues, recess pockets, and print-specific structure inside the project.
3. Only add new library behavior when a real project migration needs it.
4. Prefer small migrations with render validation instead of broad rewrites.
5. Promote a pattern into the library after it appears in at least two projects or is clearly becoming a standard.

## Relative library paths

- Projects directly under `My Designs` can usually use:

```scad
use <../utilities/architectural_openings.scad>;
```

- Projects under `My Designs\<project>\scad` can usually use:

```scad
use <../../utilities/architectural_openings.scad>;
```

## Candidate projects

### Mill Complex

Primary file:
- `Mill Complex/scad/mill_complex_wall_v11.scad`

Observed opening modules:
- `door_panel_v2(...)`
- `window_wall_v2(...)`
- `window_sash_v2(...)`
- `rear_mill_window_panel_v1(...)`
- `rear_mill_loading_door_panel_v1(...)`
- `rear_mill_utility_panel_v1(...)`

Assessment:
- Best first migration target.
- The file already separates wall panels and opening behavior into modules.
- The current shared library is not yet a direct drop-in because `mill_complex_wall_v11.scad` mixes opening cutouts with structural framing members and panel-specific geometry.

Current status:
- `front_face_frame_v1(...)` has been migrated to a shared `opening_face_frame_local(...)` helper.
- `window_sash_v2(...)` has been migrated to a shared `window_sash_grid_local(...)` helper.
- Wall framing, studs, grooves, and panel tongues remain local to avoid forcing Mill Complex structure into the shared library.

Likely migration approach:
- Keep panel shells, studs, tongues, and grooves local.
- Replace duplicated opening-specific pieces incrementally.
- If needed, add lower-level helpers to the shared library for:
  - rectangular window cutouts
  - face trim around openings
  - sash or mullion inserts
  - simple door opening helpers

### Inko Shop

Primary file:
- `Inko Shop/western_shop_from_123Export.scad`

Observed opening logic:
- inline front and rear door cutouts
- transom cutouts and trim
- `mullion_grid(...)`
- side window cutouts and trim

Assessment:
- Good second migration target.
- Openings are cleaner and more decorative than Mill Complex, but the transom layout is a special case.
- This project suggests future reuse candidates for trim-only and mullion-grid helpers, not necessarily whole-window replacement.

Likely migration approach:
- Keep the facade composition local.
- Reuse the shared library only when we have helpers for trim, sill, and mullion layout that match the storefront style.

### Section House

Primary files:
- `Section House/west_fork_section_rigging_shed.scad`
- `Section House/west_fork_section_rigging_shed_recessed.scad`

Observed opening logic:
- `small_window_trim(...)`
- `sliding_door(...)`
- `recessed_personnel_door(...)`
- direct cutouts for windows and doors

Assessment:
- Mixed migration target.
- The small window trim is a likely candidate for future reuse.
- The sliding door and recessed personnel door are highly style-specific and should stay local unless another project needs the same behavior.

Current status:
- `small_window_trim(...)` has been migrated to a shared `window_face_trim_local(...)` helper.
- The helper was validated against both shed variants.
- Non-recessed wall solids kept matching bounding boxes and volumes after migration.
- Recessed and sliding door logic remains local for now.

Likely migration approach:
- Reuse only the rectangular window/door basics if they match.
- Keep recessed pockets and sliding door detailing local for now.

## Current recommendation

Start with `Mill Complex/scad/mill_complex_wall_v11.scad`.

Reason:
- It is the latest active wall file.
- It has the clearest opening modules.
- It will tell us which lower-level helpers are genuinely missing from `architectural_openings.scad` without forcing decorative storefront or recessed-door assumptions into the library.
