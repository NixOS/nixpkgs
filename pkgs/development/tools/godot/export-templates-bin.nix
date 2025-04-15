{
  fetchzip,
  godot,
  hash,
  lib,
  version,
}:
# Export templates is necessary for setting up Godot engine, it's used when exporting projects.
# Godot applications/games packages needs to reference export templates.
# Export templates version should be kept in sync with Godot version.
# https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html#export-templates
fetchzip {
  pname = "godot-export-templates";
  version = version;
  extension = "zip";
  url = "https://github.com/godotengine/godot/releases/download/${version}/Godot_v${version}_export_templates.tpz";
  inherit hash;

  meta = {
    inherit (godot.meta)
      changelog
      description
      homepage
      license
      maintainers
      ;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
