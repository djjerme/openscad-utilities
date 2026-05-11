use <../architectural_openings.scad>;

translate([-55, 0, 0])
    window_unit(
        width = 60,
        depth = 5,
        height = 72,
        frame_thickness = 4,
        pane_cols = 4,
        pane_rows = 2,
        mullions = true,
        has_sill = true,
        sill_projection = 2.5,
        has_apron = true
    );

translate([50, 0, 0])
    door_unit(
        width = 40,
        depth = 2,
        height = 84,
        include_frame = true,
        frame_thickness = 3.5,
        functional = true,
        open_angle = 20,
        hinge = "right",
        decorative = true,
        threshold_height = 1
    );
