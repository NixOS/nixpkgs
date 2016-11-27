{ lib, allPackages
, system, platform, crossSystem, config
}:

rec {
  vanillaStdenv = import ../. {
    inherit lib allPackages system platform crossSystem;
    # Remove config.replaceStdenv to ensure termination.
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

  buildPackages = allPackages {
    inherit system platform crossSystem config;
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
    stdenv = vanillaStdenv;
  };

  stdenvCustom = config.replaceStdenv { pkgs = buildPackages; };
}
