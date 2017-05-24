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
    buildPackages.gccCrossStageFinal = nativePlatforms;
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

  darwinToAarch64 = let
    crossSystem = {
      config = "aarch64-apple-darwin14";
      arch = "arm64";
      libc = "libSystem";
    };
  in mapTestOnCross crossSystem darwinCommon;

  darwinToArm = let
    crossSystem = {
      config = "arm-apple-darwin10";
      arch = "armv7-a";
      libc = "libSystem";
    };
  in mapTestOnCross crossSystem darwinCommon;

  /* Test some cross builds to the Sheevaplug */
  crossSheevaplugLinux = let
    crossSystem = {
      config = "armv5tel-unknown-linux-gnueabi";
      bigEndian = false;
      arch = "arm";
      float = "soft";
      withTLS = true;
      platform = lib.systems.platforms.sheevaplug;
      libc = "glibc";
      openssl.system = "linux-generic32";
    };
  in mapTestOnCross crossSystem (linuxCommon // {
    ubootSheevaplug = nativePlatforms;
  });


  /* Test some cross builds on 32 bit mingw-w64 */
  crossMingw32 = let
    crossSystem = {
      config = "i686-pc-mingw32";
      arch = "x86"; # Irrelevant
      libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
      platform = {};
    };
  in mapTestOnCross crossSystem windowsCommon;


  /* Test some cross builds on 64 bit mingw-w64 */
  crossMingwW64 = let
    crossSystem = {
      # That's the triplet they use in the mingw-w64 docs.
      config = "x86_64-pc-mingw32";
      arch = "x86_64"; # Irrelevant
      libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
      platform = {};
    };
  in mapTestOnCross crossSystem windowsCommon;


  /* Linux on the fuloong */
  fuloongminipc = let
    crossSystem = {
      config = "mips64el-unknown-linux-gnu";
      bigEndian = false;
      arch = "mips";
      float = "hard";
      withTLS = true;
      libc = "glibc";
      platform = lib.systems.platforms.fuloong2f_n32;
      openssl.system = "linux-generic32";
      gcc = {
        arch = "loongson2f";
        abi = "n32";
      };
    };
  in mapTestOnCross crossSystem linuxCommon;


  /* Linux on Raspberrypi */
  rpi = let
    crossSystem = {
      config = "armv6l-unknown-linux-gnueabi";
      bigEndian = false;
      arch = "arm";
      float = "hard";
      fpu = "vfp";
      withTLS = true;
      libc = "glibc";
      platform = lib.systems.platforms.raspberrypi;
      openssl.system = "linux-generic32";
      gcc = {
        arch = "armv6";
        fpu = "vfp";
        float = "softfp";
        abi = "aapcs-linux";
      };
    };
  in mapTestOnCross crossSystem (linuxCommon // {
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
