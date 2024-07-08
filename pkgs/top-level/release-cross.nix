/* This file defines some basic smoke tests for cross compilation.
   Individual jobs can be tested by running:

   $ nix-build pkgs/top-level/release-cross.nix -A <jobname>.<package> --arg supportedSystems '[builtins.currentSystem]'

   e.g.

   $ nix-build pkgs/top-level/release-cross.nix -A crossMingw32.nixUnstable --arg supportedSystems '[builtins.currentSystem]'

   To build all of the bootstrapFiles bundles on every enabled platform, use:

   $ nix-build --expr 'with import ./pkgs/top-level/release-cross.nix {supportedSystems = [builtins.currentSystem];}; builtins.mapAttrs (k: v: v.build) bootstrapTools'
*/

{ # The platforms *from* which we cross compile.
  supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]
, # Strip most of attributes when evaluating to spare memory usage
  scrubJobs ? true
, # Attributes passed to nixpkgs. Don't build packages marked as unfree.
  nixpkgsArgs ? { config = { allowUnfree = false; inHydra = true; }; }
}:

let
  release-lib = import ./release-lib.nix {
    inherit supportedSystems scrubJobs nixpkgsArgs;
  };

  inherit (release-lib)
    all
    assertTrue
    darwin
    forMatchingSystems
    hydraJob'
    linux
    mapTestOnCross
    pkgsForCross
    unix
    ;

  inherit (release-lib.lib)
    mapAttrs
    addMetaAttrs
    elem
    getAttrFromPath
    isDerivation
    maintainers
    mapAttrsRecursive
    mapAttrsRecursiveCond
    recursiveUpdate
    systems
    ;

  inherit (release-lib.lib.attrsets)
    removeAttrs
    ;

  nativePlatforms = all;

  embedded = {
    buildPackages.binutils = nativePlatforms;
    buildPackages.gcc = nativePlatforms;
    libcCross = nativePlatforms;
  };

  common = {
    buildPackages.binutils = nativePlatforms;
    gmp = nativePlatforms;
    libcCross = nativePlatforms;
    nix = nativePlatforms;
    nixUnstable = nativePlatforms;
    mesa = nativePlatforms;
    rustc = nativePlatforms;
    cargo = nativePlatforms;
  };

  gnuCommon = recursiveUpdate common {
    buildPackages.gcc = nativePlatforms;
    coreutils = nativePlatforms;
    haskell.packages.ghcHEAD.hello = nativePlatforms;
    haskellPackages.hello = nativePlatforms;
  };

  linuxCommon = recursiveUpdate gnuCommon {
    buildPackages.gdb = nativePlatforms;

    bison = nativePlatforms;
    busybox = nativePlatforms;
    dropbear = nativePlatforms;
    ed = nativePlatforms;
    ncurses = nativePlatforms;
    patch = nativePlatforms;
  };

  windowsCommon = recursiveUpdate gnuCommon {
    boehmgc = nativePlatforms;
    libffi = nativePlatforms;
    libtool = nativePlatforms;
    libunistring = nativePlatforms;
    windows.mingw_w64_pthreads = nativePlatforms;
  };

  wasiCommon = {
    gmp = nativePlatforms;
    boehmgc = nativePlatforms;
    hello = nativePlatforms;
    zlib = nativePlatforms;
  };

  darwinCommon = {
    buildPackages.binutils = darwin;
  };

  rpiCommon = linuxCommon // {
    vim = nativePlatforms;
    unzip = nativePlatforms;
    ddrescue = nativePlatforms;
    lynx = nativePlatforms;
    patchelf = nativePlatforms;
    buildPackages.binutils = nativePlatforms;
    mpg123 = nativePlatforms;
  };

  # Enabled-but-unsupported platforms for which nix is known to build.
  # We provide Hydra-built `nixStatic` for these platforms.  This
  # allows users to bootstrap their own system without either (a)
  # trusting binaries from a non-Hydra source or (b) having to fight
  # with their host distribution's versions of nix's numerous
  # build dependencies.
  nixCrossStatic = {
    nixStatic = linux;  # no need for buildPlatform=*-darwin
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
      f = path: crossSystem: system: toString (getAttrFromPath path (pkgsForCross crossSystem system));
    in assertTrue (
        f path null system
        ==
        f (["buildPackages"] ++ path) crossSystem system
      );

    testEqual = path: systems: forMatchingSystems systems (testEqualOne path);

    mapTestEqual = mapAttrsRecursive testEqual;

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

  crossIphone64 = mapTestOnCross systems.examples.iphone64 darwinCommon;

  crossIphone32 = mapTestOnCross systems.examples.iphone32 darwinCommon;

  /* Test some cross builds to the Sheevaplug */
  crossSheevaplugLinux = mapTestOnCross systems.examples.sheevaplug (linuxCommon // {
    ubootSheevaplug = nativePlatforms;
  });

  /* Test some cross builds on 32 bit mingw-w64 */
  crossMingw32 = mapTestOnCross systems.examples.mingw32 windowsCommon;

  /* Test some cross builds on 64 bit mingw-w64 */
  crossMingwW64 = mapTestOnCross systems.examples.mingwW64 windowsCommon;

  /* Linux on mipsel */
  fuloongminipc = mapTestOnCross systems.examples.fuloongminipc linuxCommon;
  ben-nanonote = mapTestOnCross systems.examples.ben-nanonote linuxCommon;

  /* Javacript */
  ghcjs = mapTestOnCross systems.examples.ghcjs {
    haskell.packages.ghcjs.hello = nativePlatforms;
    haskell.packages.native-bignum.ghcHEAD.hello = nativePlatforms;
    haskellPackages.hello = nativePlatforms;
  };

  /* Linux on Raspberrypi */
  rpi = mapTestOnCross systems.examples.raspberryPi rpiCommon;
  rpi-musl = mapTestOnCross systems.examples.muslpi rpiCommon;

  /* Linux on the Remarkable */
  remarkable1 = mapTestOnCross systems.examples.remarkable1 linuxCommon;
  remarkable2 = mapTestOnCross systems.examples.remarkable2 linuxCommon;

  /* Linux on armv7l-hf */
  armv7l-hf = mapTestOnCross systems.examples.armv7l-hf-multiplatform linuxCommon;

  pogoplug4 = mapTestOnCross systems.examples.pogoplug4 linuxCommon;

  /* Linux on aarch64 */
  aarch64 = mapTestOnCross systems.examples.aarch64-multiplatform linuxCommon;
  aarch64-musl = mapTestOnCross systems.examples.aarch64-multiplatform-musl linuxCommon;

  /* Linux on RISCV */
  riscv64 = mapTestOnCross systems.examples.riscv64 linuxCommon;
  riscv32 = mapTestOnCross systems.examples.riscv32 linuxCommon;

  /* Linux on LoongArch */
  loongarch64-linux = mapTestOnCross systems.examples.loongarch64-linux linuxCommon;

  m68k = mapTestOnCross systems.examples.m68k linuxCommon;
  s390x = mapTestOnCross systems.examples.s390x linuxCommon;

  /* (Cross-compiled) Linux on x86 */
  x86_64-musl = mapTestOnCross systems.examples.musl64 linuxCommon;
  x86_64-gnu = mapTestOnCross systems.examples.gnu64 linuxCommon;
  i686-musl = mapTestOnCross systems.examples.musl32 linuxCommon;
  i686-gnu = mapTestOnCross systems.examples.gnu32 linuxCommon;

  ppc64le = mapTestOnCross systems.examples.powernv linuxCommon;
  ppc64le-musl = mapTestOnCross systems.examples.musl-power linuxCommon;

  android64 = mapTestOnCross systems.examples.aarch64-android-prebuilt linuxCommon;
  android32 = mapTestOnCross systems.examples.armv7a-android-prebuilt linuxCommon;

  wasi32 = mapTestOnCross systems.examples.wasi32 wasiCommon;

  msp430 = mapTestOnCross systems.examples.msp430 embedded;
  mmix = mapTestOnCross systems.examples.mmix embedded;
  vc4 = mapTestOnCross systems.examples.vc4 embedded;
  or1k = mapTestOnCross systems.examples.or1k embedded;
  avr = mapTestOnCross systems.examples.avr embedded;
  arm-embedded = mapTestOnCross systems.examples.arm-embedded embedded;
  armhf-embedded = mapTestOnCross systems.examples.armhf-embedded embedded;
  aarch64-embedded = mapTestOnCross systems.examples.aarch64-embedded embedded;
  aarch64be-embedded = mapTestOnCross systems.examples.aarch64be-embedded embedded;
  powerpc-embedded = mapTestOnCross systems.examples.ppc-embedded embedded;
  powerpcle-embedded = mapTestOnCross systems.examples.ppcle-embedded embedded;
  i686-embedded = mapTestOnCross systems.examples.i686-embedded embedded;
  x86_64-embedded = mapTestOnCross systems.examples.x86_64-embedded embedded;
  riscv64-embedded = mapTestOnCross systems.examples.riscv64-embedded embedded;
  riscv32-embedded = mapTestOnCross systems.examples.riscv32-embedded embedded;
  rx-embedded = mapTestOnCross systems.examples.rx-embedded embedded;

  x86_64-freebsd = mapTestOnCross systems.examples.x86_64-freebsd common;
  x86_64-netbsd = mapTestOnCross systems.examples.x86_64-netbsd common;
  x86_64-openbsd = mapTestOnCross systems.examples.x86_64-openbsd common;

  # we test `embedded` instead of `linuxCommon` because very few packages
  # successfully cross-compile to Redox so far
  x86_64-redox = mapTestOnCross systems.examples.x86_64-unknown-redox embedded;

  /* Cross-built bootstrap tools for every supported platform */
  bootstrapTools = let
    tools = import ../stdenv/linux/make-bootstrap-tools-cross.nix { system = "x86_64-linux"; };
    meta = {
      maintainers = [ maintainers.dezgeg ];
    };
    mkBootstrapToolsJob = drv:
      assert elem drv.system supportedSystems;
      hydraJob' (addMetaAttrs meta drv);
  in mapAttrsRecursiveCond (as: !isDerivation as) (name: mkBootstrapToolsJob)
    # The `bootstrapTools.${platform}.bootstrapTools` derivation
    # *unpacks* the bootstrap-files using their own `busybox` binary,
    # so it will fail unless buildPlatform.canExecute hostPlatform.
    # Unfortunately `bootstrapTools` also clobbers its own `system`
    # attribute, so there is no way to detect this -- we must add it
    # as a special case.  We filter the "test" attribute (only from
     # *cross*-built bootstrapTools) for the same reason.
    (mapAttrs (_: v: removeAttrs v ["bootstrapTools" "test"]) tools);

  # Cross-built nixStatic for platforms for enabled-but-unsupported platforms
  mips64el-nixCrossStatic = mapTestOnCross systems.examples.mips64el-linux-gnuabi64 nixCrossStatic;
  powerpc64le-nixCrossStatic = mapTestOnCross systems.examples.powernv nixCrossStatic;
}
