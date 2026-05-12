/*
  Parametric architectural openings library for OpenSCAD.
  OpenSCAD does not support classes, so this file uses reusable modules
  with named parameters to provide a class-like API.
*/

$fn = 48;

function clamp(value, low, high) = min(max(value, low), high);
function inner_size(outer, border) = max(outer - (border * 2), 0.01);

module box_centered(size) {
    translate([-size[0] / 2, -size[1] / 2, 0]) cube(size);
}

module frame_ring(width, depth, height, thickness) {
    inner_w = inner_size(width, thickness);
    inner_h = inner_size(height, thickness);

    difference() {
        box_centered([width, depth, height]);
        translate([0, 0, thickness])
            box_centered([inner_w, depth + 0.2, inner_h]);
    }
}

module door_frame(width, depth, height, thickness, threshold_height = 0) {
    clear_width = inner_size(width, thickness);

    translate([-(width - thickness) / 2, 0, 0])
        box_centered([thickness, depth, height]);

    translate([(width - thickness) / 2, 0, 0])
        box_centered([thickness, depth, height]);

    translate([0, 0, height - thickness])
        box_centered([width, depth, thickness]);

    if (threshold_height > 0) {
        translate([0, 0, 0])
            box_centered([clear_width, depth, threshold_height]);
    }
}

module trim_piece(width, depth, height, z = 0) {
    translate([0, 0, z]) box_centered([width, depth, height]);
}

module glass_panel(width, depth, height, z = 0) {
    color([0.70, 0.88, 0.98, 0.45])
        translate([0, 0, z]) box_centered([width, depth, height]);
}

// Local-origin helpers are useful when a project already owns the wall shell
// and only wants shared opening geometry.
module opening_face_frame_local(width, height, frame_w = 3.2, frame_t = 0.9) {
    difference() {
        translate([-frame_w, -frame_t, -frame_w])
            cube([width + 2 * frame_w, frame_t, height + 2 * frame_w]);

        translate([0, -frame_t - 0.1, 0])
            cube([width, frame_t + 0.2, height]);
    }
}

module window_sash_grid_local(
    width,
    height,
    depth,
    frame_w = 1.8,
    mullion_w = 1.2,
    pane_cols = 2,
    pane_rows = 2
) {
    cols = max(floor(pane_cols), 1);
    rows = max(floor(pane_rows), 1);
    clear_w = max(width - 2 * frame_w, 0.01);
    clear_h = max(height - 2 * frame_w, 0.01);

    difference() {
        cube([width, depth, height]);

        translate([frame_w, -0.1, frame_w])
            cube([clear_w, depth + 0.2, clear_h]);
    }

    if (cols > 1) {
        for (i = [1 : cols - 1]) {
            x = frame_w + clear_w * i / cols - mullion_w / 2;
            translate([x, 0, frame_w])
                cube([mullion_w, depth, clear_h]);
        }
    }

    if (rows > 1) {
        for (i = [1 : rows - 1]) {
            z = frame_w + clear_h * i / rows - mullion_w / 2;
            translate([frame_w, 0, z])
                cube([clear_w, depth, mullion_w]);
        }
    }
}

module window_face_trim_local(
    width,
    height,
    frame_w = 2.0,
    frame_y = -2.0,
    frame_depth = 2.0,
    sill_width_extra = 1.0,
    sill_front_extra = 1.2,
    sill_height = 1.8,
    sill_drop = 1.2,
    mullion_y = -0.2,
    mullion_depth = 0.9,
    mullion_w = 1.5,
    pane_cols = 2,
    pane_rows = 2
) {
    cols = max(floor(pane_cols), 1);
    rows = max(floor(pane_rows), 1);

    translate([-frame_w, frame_y, -frame_w])
        cube([width + 2 * frame_w, frame_depth, frame_w]);

    translate([-frame_w, frame_y, height])
        cube([width + 2 * frame_w, frame_depth, frame_w]);

    translate([-frame_w, frame_y, -frame_w])
        cube([frame_w, frame_depth, height + 2 * frame_w]);

    translate([width, frame_y, -frame_w])
        cube([frame_w, frame_depth, height + 2 * frame_w]);

    translate([
        -sill_width_extra,
        frame_y - sill_front_extra,
        -frame_w - sill_drop
    ])
        cube([
            width + 2 * sill_width_extra,
            frame_depth + sill_front_extra,
            sill_height
        ]);

    if (cols > 1) {
        for (i = [1 : cols - 1]) {
            x = width * i / cols - mullion_w / 2;
            translate([x, mullion_y, 0])
                cube([mullion_w, mullion_depth, height]);
        }
    }

    if (rows > 1) {
        for (i = [1 : rows - 1]) {
            z = height * i / rows - mullion_w / 2;
            translate([0, mullion_y, z])
                cube([width, mullion_depth, mullion_w]);
        }
    }
}

module mullion_bar(length, thickness, depth, vertical = true, z = 0) {
    if (vertical) {
        translate([0, 0, z]) box_centered([thickness, depth, length]);
    } else {
        translate([0, 0, z]) box_centered([length, depth, thickness]);
    }
}

module decorative_door_panels(clear_width, slab_depth, clear_height, inset = 3, rail = 6) {
    panel_gap = rail;
    margin = rail * 1.2;
    panel_width = max((clear_width - margin * 2 - panel_gap) / 2, clear_width * 0.2);
    panel_height = max((clear_height - margin * 2 - panel_gap) / 2, clear_height * 0.2);
    emboss_depth = min(inset, slab_depth * 0.25);
    z_positions = [
        margin,
        margin + panel_height + panel_gap
    ];

    for (x_sign = [-1, 1]) {
        for (z_offset = z_positions) {
            x_offset = x_sign * (panel_width / 2 + panel_gap / 2);

            translate([x_offset, slab_depth / 2 - emboss_depth / 2, z_offset])
                difference() {
                    box_centered([panel_width, emboss_depth, panel_height]);
                    box_centered([
                        max(panel_width - rail * 2, 0.01),
                        emboss_depth + 0.1,
                        max(panel_height - rail * 2, 0.01)
                    ]);
                }
        }
    }
}

module door_leaf(
    width,
    depth,
    height,
    decorative = true,
    knob_radius = 1.2,
    knob_length = 2.2,
    knob_height = 36,
    knob_backset = 2.5
) {
    box_centered([width, depth, height]);

    if (decorative) {
        decorative_door_panels(
            clear_width = width * 0.82,
            slab_depth = depth,
            clear_height = height * 0.78
        );
    }

    knob_x = width / 2 - knob_backset;
    knob_z = clamp(knob_height, 6, height - 6);

    for (side = [-1, 1]) {
        translate([knob_x, side * (depth / 2 + knob_length / 2), knob_z])
            rotate([90, 0, 0])
                cylinder(h = knob_length, r = knob_radius, center = true);
    }
}

module window_unit(
    width = 48,
    depth = 5,
    height = 60,
    frame_thickness = 4,
    pane_cols = 2,
    pane_rows = 2,
    mullions = true,
    mullion_thickness = 1.25,
    has_sill = true,
    sill_height = 1.5,
    sill_projection = 2,
    has_apron = false,
    apron_height = 4,
    apron_thickness = 1,
    glass_thickness = 0.4
) {
    cols = max(floor(pane_cols), 1);
    rows = max(floor(pane_rows), 1);
    glass_width = inner_size(width, frame_thickness);
    glass_height = inner_size(height, frame_thickness);
    glass_z = frame_thickness;

    frame_ring(width, depth, height, frame_thickness);
    glass_panel(glass_width, glass_thickness, glass_height, glass_z);

    if (mullions && cols > 1) {
        pane_clear_w = glass_width / cols;

        for (i = [1 : cols - 1]) {
            x_pos = -glass_width / 2 + pane_clear_w * i;
            translate([x_pos, 0, frame_thickness])
                mullion_bar(glass_height, mullion_thickness, depth * 0.65, true);
        }
    }

    if (mullions && rows > 1) {
        pane_clear_h = glass_height / rows;

        for (i = [1 : rows - 1]) {
            z_pos = frame_thickness + pane_clear_h * i - mullion_thickness / 2;
            translate([0, 0, z_pos])
                mullion_bar(glass_width, mullion_thickness, depth * 0.65, false);
        }
    }

    if (has_sill) {
        trim_piece(
            width = width + frame_thickness * 0.5,
            depth = depth + sill_projection,
            height = sill_height,
            z = -sill_height
        );
    }

    if (has_apron) {
        trim_piece(
            width = width * 0.7,
            depth = apron_thickness,
            height = apron_height,
            z = -(has_sill ? sill_height : 0) - apron_height - 0.2
        );
    }
}

module door_unit(
    width = 36,
    depth = 2,
    height = 80,
    include_frame = true,
    frame_thickness = 3.5,
    functional = false,
    open_angle = 0,
    hinge = "left",
    decorative = true,
    reveal = 0.125,
    threshold_height = 1
) {
    clear_width = include_frame ? inner_size(width, frame_thickness) : width;
    clear_height = include_frame ? max(height - frame_thickness - threshold_height, 0.01) : height;
    slab_width = max(clear_width - reveal * 2, 0.01);
    slab_height = max(clear_height - reveal, 0.01);
    slab_depth = depth;
    hinge_sign = hinge == "right" ? 1 : -1;
    pivot_x = hinge_sign * slab_width / 2;
    closed_x = include_frame
        ? (hinge_sign == -1
            ? -width / 2 + frame_thickness + reveal + slab_width / 2
            : width / 2 - frame_thickness - reveal - slab_width / 2)
        : 0;
    slab_z = include_frame ? threshold_height : 0;

    if (include_frame) {
        door_frame(width, depth + 0.5, height, frame_thickness, threshold_height);
    }

    translate([closed_x, 0, slab_z]) {
        if (functional) {
            translate([pivot_x, 0, 0])
                rotate([0, 0, hinge_sign == -1 ? -open_angle : open_angle])
                    translate([-pivot_x, 0, 0])
                        door_leaf(
                            width = slab_width,
                            depth = slab_depth,
                            height = slab_height,
                            decorative = decorative
                        );
        } else {
            door_leaf(
                width = slab_width,
                depth = slab_depth,
                height = slab_height,
                decorative = decorative
            );
        }
    }
}

module demo_scene() {
    translate([-50, 0, 0])
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

    translate([45, 0, 0])
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
}
// Open examples/demo_scene.scad for a ready-to-render preview scene.
