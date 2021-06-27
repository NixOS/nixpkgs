{ godot, lib }:

# https://docs.godotengine.org/en/stable/development/compiling/compiling_for_x11.html#building-export-templates
godot.overrideAttrs (oldAttrs: rec {
  pname = "godot-export-templates";
  sconsFlags = "target=release platform=x11 tools=no";
  installPhase = ''
    # The godot export command expects the export templates at
    # .../share/godot/templates/3.2.3.stable with 3.2.3 being the godot version.
    mkdir -p "$out/share/godot/templates/${oldAttrs.version}.stable"
    cp bin/godot.x11.opt.64 $out/share/godot/templates/${oldAttrs.version}.stable/linux_x11_64_release
  '';
  outputs = [ "out" ];
  meta.description =
    "Free and Open Source 2D and 3D game engine (export templates)";
  meta.maintainers = with lib.maintainers; [ twey jojosch ];
})
