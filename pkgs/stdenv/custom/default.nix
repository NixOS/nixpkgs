{ lib
, system, platform, crossSystem, config
}:

assert crossSystem == null;

let
  bootStages = import ../. {
    inherit lib system platform crossSystem;
    # Remove config.replaceStdenv to ensure termination.
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in bootStages ++ [

  # Additional stage, built using custom stdenv
  (vanillaPackages: {
    inherit system platform crossSystem config;
    stdenv = config.replaceStdenv { pkgs = vanillaPackages; };
  })

]
