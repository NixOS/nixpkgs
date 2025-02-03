{ godot3
, callPackage
, mkNugetDeps
, mono
, dotnet-sdk
, scons
, python311Packages
}:

(godot3.override {
  scons = scons.override {
    python3Packages = python311Packages;
  };
}).overrideAttrs (self: base: {
  pname = "godot3-mono";

  godotBuildDescription = "mono build";

  nativeBuildInputs = base.nativeBuildInputs ++ [ mono dotnet-sdk ];

  glue = callPackage ./glue.nix {};

  buildInputs = base.buildInputs ++ [
    (mkNugetDeps { name = "deps"; nugetDeps = import ./deps.nix; })
  ];

  sconsFlags = base.sconsFlags ++ [
    "module_mono_enabled=true"
    "mono_prefix=${mono}"
  ];

  postConfigure = ''
    echo "Setting up buildhome."
    mkdir buildhome
    export HOME="$PWD"/buildhome

    echo "Overlaying godot glue."
    cp -R --no-preserve=mode "$glue"/. .
  '';

  installedGodotShortcutFileName = "org.godotengine.GodotMono3.desktop";
  installedGodotShortcutDisplayName = "Godot Engine (Mono) 3";

  passthru = {
    make-deps = callPackage ./make-deps.nix {};
  };
})
