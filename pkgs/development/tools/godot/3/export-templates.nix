<<<<<<< HEAD
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
=======
{ godot, lib }:

# https://docs.godotengine.org/en/stable/development/compiling/compiling_for_x11.html#building-export-templates
godot.overrideAttrs (oldAttrs: rec {
  pname = "godot-export-templates";
  sconsFlags = [ "target=release" "platform=x11" "tools=no" ];
  installPhase = ''
    # The godot export command expects the export templates at
    # .../share/godot/templates/3.2.3.stable with 3.2.3 being the godot version.
    mkdir -p "$out/share/godot/templates/${oldAttrs.version}.stable"
    cp bin/godot.x11.opt.64 $out/share/godot/templates/${oldAttrs.version}.stable/linux_x11_64_release
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # https://docs.godotengine.org/en/stable/development/compiling/optimizing_for_size.html
  # Stripping reduces the template size from around 500MB to 40MB for Linux.
  # This also impacts the size of the exported games.
  # This is added explicitly here because mkDerivation does not automatically
  # strip binaries in the template directory.
<<<<<<< HEAD
  stripAllList = (base.stripAllList or []) ++ [ "share/godot/templates" ];

  meta = base.meta // {
    homepage = "https://docs.godotengine.org/en/stable/development/compiling/compiling_for_x11.html#building-export-templates";
  };
=======
  stripAllList = (oldAttrs.stripAllList or []) ++ [ "share/godot/templates" ];

  outputs = [ "out" ];
  meta.description =
    "Free and Open Source 2D and 3D game engine (export templates)";
  meta.maintainers = with lib.maintainers; [ twey jojosch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
