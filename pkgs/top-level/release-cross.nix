{ # The platforms for which we build Nixpkgs.
  supportedSystems ? [ builtins.currentSystem ]
, # Strip most of attributes when evaluating to spare memory usage
  scrubJobs ? true
}:

with import ./release-lib.nix { inherit supportedSystems scrubJobs; };

let
  nativePlatforms = linux;

  /* Basic list of packages to cross-build */
  basicCrossDrv = {
    bison = nativePlatforms;
    busybox = nativePlatforms;
    coreutils = nativePlatforms;
    dropbear = nativePlatforms;
  };

  /* Basic list of packages to be natively built,
     but need a crossSystem defined to get meaning */
  basicNativeDrv = {
    buildPackages.gccCrossStageFinal = nativePlatforms;
    buildPackages.gdbCross = nativePlatforms;
  };

  basic = basicCrossDrv // basicNativeDrv;

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
      config = "foosys";
      libc = "foolibc";
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
  in mapTestOnCross crossSystem (basic // {
    ubootSheevaplug = nativePlatforms;
  });


  /* Test some cross builds on 32 bit mingw-w64 */
  crossMingw32 = let
    crossSystem = {
      config = "i686-w64-mingw32";
      arch = "x86"; # Irrelevant
      libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
      platform = {};
    };
  in mapTestOnCross crossSystem {
    coreutils = nativePlatforms;
    boehmgc = nativePlatforms;
    gmp = nativePlatforms;
    guile_1_8 = nativePlatforms;
    libffi = nativePlatforms;
    libtool = nativePlatforms;
    libunistring = nativePlatforms;
    windows.wxMSW = nativePlatforms;
  };


  /* Test some cross builds on 64 bit mingw-w64 */
  crossMingwW64 = let
    crossSystem = {
      # That's the triplet they use in the mingw-w64 docs.
      config = "x86_64-w64-mingw32";
      arch = "x86_64"; # Irrelevant
      libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
      platform = {};
    };
  in mapTestOnCross crossSystem {
    coreutils = nativePlatforms;
    boehmgc = nativePlatforms;
    gmp = nativePlatforms;
    guile_1_8 = nativePlatforms;
    libffi = nativePlatforms;
    libtool = nativePlatforms;
    libunistring = nativePlatforms;
    windows.wxMSW = nativePlatforms;
  };


  /* Linux on the fuloong */
  fuloongminipc = let
    crossSystem = {
      config = "mips64el-unknown-linux";
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
  in mapTestOnCross crossSystem {
    coreutils = nativePlatforms;
    ed = nativePlatforms;
    patch = nativePlatforms;
  };


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
  in mapTestOnCross crossSystem {
    coreutils = nativePlatforms;
    ed = nativePlatforms;
    patch = nativePlatforms;
    vim = nativePlatforms;
    unzip = nativePlatforms;
    ddrescue = nativePlatforms;
    lynx = nativePlatforms;
    patchelf = nativePlatforms;
    buildPackages.binutils = nativePlatforms;
    mpg123 = nativePlatforms;
  };


  /* Cross-built bootstrap tools for every supported platform */
  bootstrapTools = let
    tools = import ../stdenv/linux/make-bootstrap-tools-cross.nix { system = "x86_64-linux"; };
    maintainers = [ lib.maintainers.dezgeg ];
    mkBootstrapToolsJob = drv: hydraJob' (lib.addMetaAttrs { inherit maintainers; } drv);
  in lib.mapAttrsRecursiveCond (as: !lib.isDerivation as) (name: mkBootstrapToolsJob) tools;
}
