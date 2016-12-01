{ system, allPackages, platform, crossSystem, config, ... } @ args:

rec {
  vanillaStdenv = import ../. (args // {
    # Remove config.replaceStdenv to ensure termination.
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  });

  buildPackages = allPackages {
    inherit system platform crossSystem config;
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
    bootStdenv = vanillaStdenv;
  };

  stdenvCustom = config.replaceStdenv { pkgs = buildPackages; };
}
