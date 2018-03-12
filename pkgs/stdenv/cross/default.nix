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
    inherit config overlays;
    selfBuild = false;
    stdenv =
      assert vanillaPackages.hostPlatform == localSystem;
      assert vanillaPackages.targetPlatform == localSystem;
      vanillaPackages.stdenv.override { targetPlatform = crossSystem; };
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
  })

  # Run Packages
  (buildPackages: {
    inherit config overlays;
    selfBuild = false;
    stdenv = buildPackages.makeStdenvCross {
      inherit (buildPackages) stdenv;
      buildPlatform = localSystem;
      hostPlatform = crossSystem;
      targetPlatform = crossSystem;
      cc = if crossSystem.useiOSCross or false
             then buildPackages.darwin.ios-cross
           else if crossSystem.useAndroidPrebuilt
             then buildPackages.androidenv.androidndkPkgs.gcc
           else buildPackages.gcc;
    };
  })

]
