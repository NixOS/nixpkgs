# Keep existing value if it is already non-empty
if [[ -z "${AVALONIA_GLOBAL_SCALE_FACTOR-}" ]]; then
    # Attempt to get GNOME desktop interface scaling factor
    AVALONIA_GLOBAL_SCALE_FACTOR="$(gsettings get org.gnome.desktop.interface scaling-factor | cut --delimiter=' ' --fields=2)"
fi

if [[ -z "${AVALONIA_GLOBAL_SCALE_FACTOR-}" ]]; then
    # Attempt to get scaling factor from X FreeType DPI setting
    dpi="$(xrdb -get Xft.dpi)"
    if [[ -n "$dpi" ]]; then
        AVALONIA_GLOBAL_SCALE_FACTOR=$(echo "scale=2; $dpi/96" | bc)
    fi
fi

if [[ -n "${AVALONIA_GLOBAL_SCALE_FACTOR-}" ]]; then
    export AVALONIA_GLOBAL_SCALE_FACTOR
fi
