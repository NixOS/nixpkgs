with import ./release-lib.nix { supportedSystems = [ builtins.currentSystem ]; };
let
  lib = import ../../lib;

  nativePlatforms = linux;

  /* Basic list of packages to cross-build */
  basicCrossDrv = {
    gccCrossStageFinal = nativePlatforms;
    bison.crossDrv = nativePlatforms;
    busybox.crossDrv = nativePlatforms;
    coreutils.crossDrv = nativePlatforms;
    dropbear.crossDrv = nativePlatforms;
  };

  /* Basic list of packages to be natively built,
     but need a crossSystem defined to get meaning */
  basicNativeDrv = {
    gdbCross = nativePlatforms;
  };

  basic = basicCrossDrv // basicNativeDrv;

in

{
  # These `nativeDrv`s should be identical to their vanilla ones --- cross
  # compiling should not affect the native derivation.
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
      f = attrs: builtins.toString (lib.getAttrFromPath path (allPackages attrs));
    in assert f { inherit system; } == f { inherit system crossSystem; }; true;

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
      platform = pkgs.platforms.sheevaplug;
      libc = "glibc";
      openssl.system = "linux-generic32";
    };
  in mapTestOnCross crossSystem (basic // {
    ubootSheevaplug.crossDrv = nativePlatforms;
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
    coreutils.crossDrv = nativePlatforms;
    boehmgc.crossDrv = nativePlatforms;
    gmp.crossDrv = nativePlatforms;
    guile_1_8.crossDrv = nativePlatforms;
    libffi.crossDrv = nativePlatforms;
    libtool.crossDrv = nativePlatforms;
    libunistring.crossDrv = nativePlatforms;
    windows.wxMSW.crossDrv = nativePlatforms;
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
    coreutils.crossDrv = nativePlatforms;
    boehmgc.crossDrv = nativePlatforms;
    gmp.crossDrv = nativePlatforms;
    guile_1_8.crossDrv = nativePlatforms;
    libffi.crossDrv = nativePlatforms;
    libtool.crossDrv = nativePlatforms;
    libunistring.crossDrv = nativePlatforms;
    windows.wxMSW.crossDrv = nativePlatforms;
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
      platform = {
        name = "fuloong-minipc";
        kernelMajor = "2.6";
        kernelBaseConfig = "lemote2f_defconfig";
        kernelHeadersBaseConfig = "fuloong2e_defconfig";
        uboot = null;
        kernelArch = "mips";
        kernelAutoModules = false;
        kernelTarget = "vmlinux";
      };
      openssl.system = "linux-generic32";
      gcc = {
        arch = "loongson2f";
        abi = "n32";
      };
    };
  in mapTestOnCross crossSystem {
    coreutils.crossDrv = nativePlatforms;
    ed.crossDrv = nativePlatforms;
    patch.crossDrv = nativePlatforms;
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
      platform = pkgs.platforms.raspberrypi;
      openssl.system = "linux-generic32";
      gcc = {
        arch = "armv6";
        fpu = "vfp";
        float = "softfp";
        abi = "aapcs-linux";
      };
    };
  in mapTestOnCross crossSystem {
    coreutils.crossDrv = nativePlatforms;
    ed.crossDrv = nativePlatforms;
    patch.crossDrv = nativePlatforms;
    vim.crossDrv = nativePlatforms;
    unzip.crossDrv = nativePlatforms;
    ddrescue.crossDrv = nativePlatforms;
    lynx.crossDrv = nativePlatforms;
    patchelf.crossDrv = nativePlatforms;
    binutils.crossDrv = nativePlatforms;
    mpg123.crossDrv = nativePlatforms;
  };


  /* Cross-built bootstrap tools for every supported platform */
  bootstrapTools = let
    tools = import ../stdenv/linux/make-bootstrap-tools-cross.nix { system = "x86_64-linux"; };
    maintainers = [ pkgs.lib.maintainers.dezgeg ];
    mkBootstrapToolsJob = bt: hydraJob' (pkgs.lib.addMetaAttrs { inherit maintainers; } bt.dist);
  in pkgs.lib.mapAttrs (name: mkBootstrapToolsJob) tools;
}
