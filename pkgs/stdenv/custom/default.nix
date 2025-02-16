{
  lib,
  localSystem,
  crossSystem,
  config,
  overlays,
  crossOverlays ? [ ],
}:

assert crossSystem.equals localSystem;

let
  bootStages = import ../. {
    inherit
      lib
      localSystem
      crossSystem
      overlays
      ;
    # Remove config.replaceStdenv to ensure termination.
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in
bootStages
++ [

  # Additional stage, built using custom stdenv
  (vanillaPackages: {
    inherit config overlays;
    stdenv =
      assert vanillaPackages.stdenv.hostPlatform.equals localSystem;
      assert vanillaPackages.stdenv.targetPlatform.equals localSystem;
      config.replaceStdenv { pkgs = vanillaPackages; };
  })

]
