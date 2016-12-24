{ lib
, localSystem, crossSystem, config, overlays
}:

let
  bootStages = import ../. {
    inherit lib localSystem overlays;
    crossSystem = null;
    # Ignore custom stdenvs when cross compiling for compatability
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in bootStages ++ [

  # Build Packages
  (vanillaPackages: {
    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
    inherit (vanillaPackages) stdenv;
  })

  # Run Packages
  (buildPackages: {
    buildPlatform = localSystem;
    hostPlatform = crossSystem;
    targetPlatform = crossSystem;
    inherit config overlays;
    selfBuild = false;
    stdenv = if crossSystem.useiOSCross or false
      then let
          inherit (buildPackages.darwin.ios-cross {
              prefix = crossSystem.config;
              inherit (crossSystem) arch;
              simulator = crossSystem.isiPhoneSimulator or false; })
            cc binutils;
        in buildPackages.makeStdenvCross
          buildPackages.stdenv crossSystem
          binutils cc
      else buildPackages.makeStdenvCross
        buildPackages.stdenv crossSystem
        buildPackages.binutilsCross buildPackages.gccCrossStageFinal;
  })

]
