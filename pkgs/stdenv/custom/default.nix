{ lib
, localSystem, crossSystem, config, overlays
}:

assert crossSystem == null;

let
  bootStages = import ../. {
    inherit lib localSystem crossSystem overlays;
    # Remove config.replaceStdenv to ensure termination.
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in bootStages ++ [

  # Additional stage, built using custom stdenv
  (vanillaPackages: {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = localSystem;
    inherit config overlays;
    stdenv = config.replaceStdenv { pkgs = vanillaPackages; };
  })

]
