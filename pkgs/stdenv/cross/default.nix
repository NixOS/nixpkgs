{ lib, allPackages
, system, platform, crossSystem, config
}:

rec {
  vanillaStdenv = (import ../. {
    inherit lib allPackages system platform;
    crossSystem = null;
    # Ignore custom stdenvs when cross compiling for compatability
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  }) // {
    # Needed elsewhere as a hacky way to pass the target
    cross = crossSystem;
  };

  # For now, this is just used to build the native stdenv. Eventually, it should
  # be used to build compilers and other such tools targeting the cross
  # platform. Then, `forceNativeDrv` can be removed.
  buildPackages = allPackages {
    inherit system platform crossSystem config;
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
    stdenv = vanillaStdenv;
  };

  stdenvCross = buildPackages.makeStdenvCross
    buildPackages.stdenv crossSystem
    buildPackages.binutilsCross buildPackages.gccCrossStageFinal;

  stdenvCrossiOS = let
    inherit (buildPackages.darwin.ios-cross { prefix = crossSystem.config; inherit (crossSystem) arch; simulator = crossSystem.isiPhoneSimulator or false; }) cc binutils;
  in buildPackages.makeStdenvCross
    buildPackages.stdenv crossSystem
    binutils cc;
}
