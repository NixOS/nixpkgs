{ system, allPackages, platform, crossSystem, config, ... } @ args:

rec {
  vanillaStdenv = (import ../. (args // {
    crossSystem = null;
    allPackages = args: allPackages ({ crossSystem = null; } // args);
  })).stdenv;

  # Yeah this isn't so cleanly just build-time packages yet. Notice the
  # buildPackages <-> stdenvCross cycle. Yup, it's very weird.
  #
  # This works because the derivation used to build `stdenvCross` are in
  # fact using `forceNativeDrv` to use the `nativeDrv` attribute of the resulting
  # derivation built with `vanillaStdenv` (second argument of `makeStdenvCross`).
  #
  # Eventually, `forceNativeDrv` should be removed and the cycle broken.
  buildPackages = allPackages {
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
    bootStdenv = stdenvCross;
    inherit system platform crossSystem config;
  };

  stdenvCross = buildPackages.makeStdenvCross
    vanillaStdenv crossSystem
    buildPackages.binutilsCross buildPackages.gccCrossStageFinal;
}
