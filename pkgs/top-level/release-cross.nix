with import ./release-lib.nix { supportedSystems = []; };
let
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
(

/* Test some cross builds to the Sheevaplug */
let
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

in {
  crossSheevaplugLinux = mapTestOnCross crossSystem (
    basic //
    {
      ubootSheevaplug.crossDrv = nativePlatforms;
    });
}) // (

/* Test some cross builds on 32 bit mingw-w64 */
let
  crossSystem = {
      config = "i686-w64-mingw32";
      arch = "x86"; # Irrelevant
      libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
      platform = {};
  };
in {
  crossMingw32 = mapTestOnCross crossSystem {
    coreutils.crossDrv = nativePlatforms;
    boehmgc.crossDrv = nativePlatforms;
    gmp.crossDrv = nativePlatforms;
    guile_1_8.crossDrv = nativePlatforms;
    libffi.crossDrv = nativePlatforms;
    libtool.crossDrv = nativePlatforms;
    libunistring.crossDrv = nativePlatforms;
    windows.wxMSW.crossDrv = nativePlatforms;
  };
}) // (

/* Test some cross builds on 64 bit mingw-w64 */
let
  crossSystem = {
      # That's the triplet they use in the mingw-w64 docs.
      config = "x86_64-w64-mingw32";
      arch = "x86_64"; # Irrelevant
      libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
      platform = {};
  };
in {
  crossMingwW64 = mapTestOnCross crossSystem {
    coreutils.crossDrv = nativePlatforms;
    boehmgc.crossDrv = nativePlatforms;
    gmp.crossDrv = nativePlatforms;
    guile_1_8.crossDrv = nativePlatforms;
    libffi.crossDrv = nativePlatforms;
    libtool.crossDrv = nativePlatforms;
    libunistring.crossDrv = nativePlatforms;
    windows.wxMSW.crossDrv = nativePlatforms;
  };
}) // (

/* Linux on the fuloong */
let
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
in {
  fuloongminipc = mapTestOnCross crossSystem {

    coreutils.crossDrv = nativePlatforms;
    ed.crossDrv = nativePlatforms;
    patch.crossDrv = nativePlatforms;
  };
}) // (

/* Linux on Raspberrypi */
let
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
in {
  rpi = mapTestOnCross crossSystem {
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
}) // (

/* Cross-built bootstrap tools for every supported platform */
let
  tools = import ../stdenv/linux/make-bootstrap-tools-cross.nix { system = "x86_64-linux"; };
  maintainers = [ pkgs.lib.maintainers.dezgeg ];
  mkBootstrapToolsJob = bt: hydraJob' (pkgs.lib.addMetaAttrs { inherit maintainers; } bt.dist);
in {
  bootstrapTools = pkgs.lib.mapAttrs (name: mkBootstrapToolsJob) tools;
})
