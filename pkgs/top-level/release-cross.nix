/* This file defines some basic smoke tests for cross compilation.
*/

{ # The platforms *from* which we cross compile.
  supportedSystems ? [ "x86_64-linux" "x86_64-darwin" ]
, # Strip most of attributes when evaluating to spare memory usage
  scrubJobs ? true
}:

with import ./release-lib.nix { inherit supportedSystems scrubJobs; };

let
  nativePlatforms = linux;

  common = {
    buildPackages.binutils = nativePlatforms;
    gmp = nativePlatforms;
    libcCross = nativePlatforms;
  };

  gnuCommon = lib.recursiveUpdate common {
    buildPackages.gcc = nativePlatforms;
    coreutils = nativePlatforms;
  };

  linuxCommon = lib.recursiveUpdate gnuCommon {
    buildPackages.gdb = nativePlatforms;

    bison = nativePlatforms;
    busybox = nativePlatforms;
    dropbear = nativePlatforms;
    ed = nativePlatforms;
    ncurses = nativePlatforms;
    patch = nativePlatforms;
  };

  windowsCommon = lib.recursiveUpdate gnuCommon {
    boehmgc = nativePlatforms;
    guile_1_8 = nativePlatforms;
    libffi = nativePlatforms;
    libtool = nativePlatforms;
    libunistring = nativePlatforms;
    windows.wxMSW = nativePlatforms;
  };

  darwinCommon = {
    buildPackages.binutils = darwin;
  };

in

{
  # These derivations from a cross package set's `buildPackages` should be
  # identical to their vanilla equivalents --- none of these package should
  # observe the target platform which is the only difference between those
  # package sets.
  ensureUnaffected = let
    # Absurd values are fine here, as we are not building anything. In fact,
    # there probably a good idea to try to be "more parametric" --- i.e. avoid
    # any special casing.
    crossSystem = {
      config = "mips64el-apple-windows-gnu";
      libc = "glibc";
    };

    # Converting to a string (drv path) before checking equality is probably a
    # good idea lest there be some irrelevant pass-through debug attrs that
    # cause false negatives.
    testEqualOne = path: system: let
      f = path: attrs: builtins.toString (lib.getAttrFromPath path (allPackages attrs));
    in assertTrue (
        f path { inherit system; }
        ==
        f (["buildPackages"] ++ path) { inherit system crossSystem; }
      );

    testEqual = path: systems: forAllSupportedSystems systems (testEqualOne path);

    mapTestEqual = lib.mapAttrsRecursive testEqual;

  in mapTestEqual {
    boehmgc = nativePlatforms;
    libffi = nativePlatforms;
    libiconv = nativePlatforms;
    libtool = nativePlatforms;
    zlib = nativePlatforms;
    readline = nativePlatforms;
    libxml2 = nativePlatforms;
    guile = nativePlatforms;
  };

  crossIphone64 = mapTestOnCross lib.systems.examples.iphone64 darwinCommon;

  crossIphone32 = mapTestOnCross lib.systems.examples.iphone32 darwinCommon;

  /* Test some cross builds to the Sheevaplug */
  crossSheevaplugLinux = mapTestOnCross lib.systems.examples.sheevaplug (linuxCommon // {
    ubootSheevaplug = nativePlatforms;
  });

  /* Test some cross builds on 32 bit mingw-w64 */
  crossMingw32 = mapTestOnCross lib.systems.examples.mingw32 windowsCommon;

  /* Test some cross builds on 64 bit mingw-w64 */
  crossMingwW64 = mapTestOnCross lib.systems.examples.mingwW64 windowsCommon;

  /* Linux on the fuloong */
  fuloongminipc = mapTestOnCross lib.systems.examples.fuloongminipc linuxCommon;

  /* Linux on Raspberrypi */
  rpi = mapTestOnCross lib.systems.examples.raspberryPi (linuxCommon // {
    vim = nativePlatforms;
    unzip = nativePlatforms;
    ddrescue = nativePlatforms;
    lynx = nativePlatforms;
    patchelf = nativePlatforms;
    buildPackages.binutils = nativePlatforms;
    mpg123 = nativePlatforms;
  });


  /* Cross-built bootstrap tools for every supported platform */
  bootstrapTools = let
    tools = import ../stdenv/linux/make-bootstrap-tools-cross.nix { system = "x86_64-linux"; };
    maintainers = [ lib.maintainers.dezgeg ];
    mkBootstrapToolsJob = drv: hydraJob' (lib.addMetaAttrs { inherit maintainers; } drv);
  in lib.mapAttrsRecursiveCond (as: !lib.isDerivation as) (name: mkBootstrapToolsJob) tools;
}
