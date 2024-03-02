{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

assert crossSystem == localSystem;

let
  bootStages = import ../. {
    inherit lib localSystem crossSystem overlays;
    # Remove config.replaceStdenv to ensure termination.
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in bootStages ++ [

  # Additional stage, built using custom stdenv
  (vanillaPackages: {
    inherit config overlays;
    stdenv =
      assert vanillaPackages.hostPlatform == localSystem;
      assert vanillaPackages.targetPlatform == localSystem;
      config.replaceStdenv { pkgs = vanillaPackages; };
  })

]
