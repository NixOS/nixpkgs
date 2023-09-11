{ godot3 }:

godot3.overrideAttrs (self: base: {
  pname = "godot3-export-templates";
  godotBuildDescription = "nix export templates";

  # As described in default.nix, adding the link flags to pulseaudio in detect.py was necessary to
  # allow the dlopen calls to succeed in Nix builds of godot. However, it seems that this *breaks*
  # the export templates, resulting in programs exported from godot using these export templates to
  # be unable to load this library.
  shouldAddLinkFlagsToPulse = false;

  shouldBuildTools = false;
  godotBuildTarget = "release";
  godotBinInstallPath = "share/godot/templates/${self.version}.stable";
  installedGodotBinName = "linux_${self.godotBuildPlatform}_64_${self.godotBuildTarget}";

  # https://docs.godotengine.org/en/stable/development/compiling/optimizing_for_size.html
  # Stripping reduces the template size from around 500MB to 40MB for Linux.
  # This also impacts the size of the exported games.
  # This is added explicitly here because mkDerivation does not automatically
  # strip binaries in the template directory.
  stripAllList = (base.stripAllList or []) ++ [ "share/godot/templates" ];

  meta = base.meta // {
    homepage = "https://docs.godotengine.org/en/stable/development/compiling/compiling_for_x11.html#building-export-templates";
  };
})
