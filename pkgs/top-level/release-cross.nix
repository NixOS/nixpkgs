/* This file defines some basic smoke tests for cross compilation.
   Individual jobs can be tested by running:

   $ nix-build pkgs/top-level/release-cross.nix -A <jobname>.<package> --arg supportedSystems '[builtins.currentSystem]'

   e.g.

   $ nix-build pkgs/top-level/release-cross.nix -A crossMingw32.nixUnstable --arg supportedSystems '[builtins.currentSystem]'
*/

{ # The platforms *from* which we cross compile.
  supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]
, # Strip most of attributes when evaluating to spare memory usage
  scrubJobs ? true
, # Attributes passed to nixpkgs. Don't build packages marked as unfree.
  nixpkgsArgs ? { config = { allowUnfree = false; inHydra = true; }; }
}:

with import ./release-lib.nix { inherit supportedSystems scrubJobs nixpkgsArgs; };

let
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

  gnuCommon = lib.recursiveUpdate common {
    buildPackages.gcc = nativePlatforms;
    coreutils = nativePlatforms;
    haskell.packages.ghcHEAD.hello = nativePlatforms;
    haskellPackages.hello = nativePlatforms;
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
      f = path: crossSystem: system: builtins.toString (lib.getAttrFromPath path (pkgsForCross crossSystem system));
    in assertTrue (
        f path null system
        ==
        f (["buildPackages"] ++ path) crossSystem system
      );

    testEqual = path: systems: forMatchingSystems systems (testEqualOne path);

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

  /* Linux on mipsel */
  fuloongminipc = mapTestOnCross lib.systems.examples.fuloongminipc linuxCommon;
  ben-nanonote = mapTestOnCross lib.systems.examples.ben-nanonote linuxCommon;

  /* Javacript */
  ghcjs = mapTestOnCross lib.systems.examples.ghcjs {
    haskell.packages.ghcjs.hello = nativePlatforms;
    haskell.packages.native-bignum.ghcHEAD.hello = nativePlatforms;
    haskellPackages.hello = nativePlatforms;
  };

  /* Linux on Raspberrypi */
  rpi = mapTestOnCross lib.systems.examples.raspberryPi rpiCommon;
  rpi-musl = mapTestOnCross lib.systems.examples.muslpi rpiCommon;

  /* Linux on the Remarkable */
  remarkable1 = mapTestOnCross lib.systems.examples.remarkable1 linuxCommon;
  remarkable2 = mapTestOnCross lib.systems.examples.remarkable2 linuxCommon;

  /* Linux on armv7l-hf */
  armv7l-hf = mapTestOnCross lib.systems.examples.armv7l-hf-multiplatform linuxCommon;

  pogoplug4 = mapTestOnCross lib.systems.examples.pogoplug4 linuxCommon;

  /* Linux on aarch64 */
  aarch64 = mapTestOnCross lib.systems.examples.aarch64-multiplatform linuxCommon;
  aarch64-musl = mapTestOnCross lib.systems.examples.aarch64-multiplatform-musl linuxCommon;

  /* Linux on RISCV */
  riscv64 = mapTestOnCross lib.systems.examples.riscv64 linuxCommon;
  riscv32 = mapTestOnCross lib.systems.examples.riscv32 linuxCommon;

  m68k = mapTestOnCross lib.systems.examples.m68k linuxCommon;
  s390x = mapTestOnCross lib.systems.examples.s390x linuxCommon;

  /* (Cross-compiled) Linux on x86 */
  x86_64-musl = mapTestOnCross lib.systems.examples.musl64 linuxCommon;
  x86_64-gnu = mapTestOnCross lib.systems.examples.gnu64 linuxCommon;
  i686-musl = mapTestOnCross lib.systems.examples.musl32 linuxCommon;
  i686-gnu = mapTestOnCross lib.systems.examples.gnu32 linuxCommon;

  ppc64le = mapTestOnCross lib.systems.examples.powernv linuxCommon;
  ppc64le-musl = mapTestOnCross lib.systems.examples.musl-power linuxCommon;

  android64 = mapTestOnCross lib.systems.examples.aarch64-android-prebuilt linuxCommon;
  android32 = mapTestOnCross lib.systems.examples.armv7a-android-prebuilt linuxCommon;

  wasi32 = mapTestOnCross lib.systems.examples.wasi32 wasiCommon;

  msp430 = mapTestOnCross lib.systems.examples.msp430 embedded;
  mmix = mapTestOnCross lib.systems.examples.mmix embedded;
  vc4 = mapTestOnCross lib.systems.examples.vc4 embedded;
  or1k = mapTestOnCross lib.systems.examples.or1k embedded;
  avr = mapTestOnCross lib.systems.examples.avr embedded;
  arm-embedded = mapTestOnCross lib.systems.examples.arm-embedded embedded;
  armhf-embedded = mapTestOnCross lib.systems.examples.armhf-embedded embedded;
  aarch64-embedded = mapTestOnCross lib.systems.examples.aarch64-embedded embedded;
  aarch64be-embedded = mapTestOnCross lib.systems.examples.aarch64be-embedded embedded;
  powerpc-embedded = mapTestOnCross lib.systems.examples.ppc-embedded embedded;
  powerpcle-embedded = mapTestOnCross lib.systems.examples.ppcle-embedded embedded;
  i686-embedded = mapTestOnCross lib.systems.examples.i686-embedded embedded;
  x86_64-embedded = mapTestOnCross lib.systems.examples.x86_64-embedded embedded;
  riscv64-embedded = mapTestOnCross lib.systems.examples.riscv64-embedded embedded;
  riscv32-embedded = mapTestOnCross lib.systems.examples.riscv32-embedded embedded;
  rx-embedded = mapTestOnCross lib.systems.examples.rx-embedded embedded;

  x86_64-netbsd = mapTestOnCross lib.systems.examples.x86_64-netbsd common;

  # we test `embedded` instead of `linuxCommon` because very few packages
  # successfully cross-compile to Redox so far
  x86_64-redox = mapTestOnCross lib.systems.examples.x86_64-unknown-redox embedded;

  /* Cross-built bootstrap tools for every supported platform */
  bootstrapTools = let
    tools = import ../stdenv/linux/make-bootstrap-tools-cross.nix { system = "x86_64-linux"; };
    maintainers = [ lib.maintainers.dezgeg ];
    mkBootstrapToolsJob = drv:
      assert lib.elem drv.system supportedSystems;
      hydraJob' (lib.addMetaAttrs { inherit maintainers; } drv);
  in lib.mapAttrsRecursiveCond (as: !lib.isDerivation as) (name: mkBootstrapToolsJob)
    # The `bootstrapTools.${platform}.bootstrapTools` derivation
    # *unpacks* the bootstrap-files using their own `busybox` binary,
    # so it will fail unless buildPlatform.canExecute hostPlatform.
    # Unfortunately `bootstrapTools` also clobbers its own `system`
    # attribute, so there is no way to detect this -- we must add it
    # as a special case.
    (builtins.removeAttrs tools ["bootstrapTools"]);

  # Cross-built nixStatic for platforms for enabled-but-unsupported platforms
  mips64el-nixCrossStatic = mapTestOnCross lib.systems.examples.mips64el-linux-gnuabi64 nixCrossStatic;
  powerpc64le-nixCrossStatic = mapTestOnCross lib.systems.examples.powernv nixCrossStatic;
}
