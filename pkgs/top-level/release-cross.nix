with (import ./release-lib.nix);
let
  nativePlatforms = linux;

  /* Basic list of packages to cross-build */
  basicHostDrv = {
    bison.hostDrv = nativePlatforms;
    tightvnc.hostDrv = nativePlatforms;
    #openoffice.hostDrv = nativePlatforms;
    wxGTK.hostDrv = nativePlatforms;
    #firefox = nativePlatforms;
    xorg = {
      #xorgserver.hostDrv = nativePlatforms;
    };
    nixUnstable.hostDrv = nativePlatforms;
    linuxPackages_2_6_32.kernel.hostDrv = linux;
    linuxPackages_2_6_33.kernel.hostDrv = linux;
  };

  /* Basic list of packages to be natively built,
     but need a crossSystem defined to get meaning */
  basicBuildDrv = {
    gdbCross = nativePlatforms;
  };

  basic = basicHostDrv // basicBuildDrv;

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
      ubootSheevaplug.hostDrv = nativePlatforms;
    });
}) // (

/* Test some cross builds to the Sheevaplug - uclibc*/
let
  crossSystem = {
    config = "armv5tel-unknown-linux-gnueabi";  
    bigEndian = false;
    arch = "arm";
    float = "soft";
    withTLS = true;
    platform = pkgs.platforms.sheevaplug;
    libc = "uclibc";
    openssl.system = "linux-generic32";
  };

in {
  crossSheevaplugLinuxUclibc = mapTestOnCross crossSystem (
    basic //
    {
      ubootSheevaplug.hostDrv = nativePlatforms;
    });
}) // (

/* Test some cross builds to the mipsel */
let
  crossSystem = {
    config = "mipsel-unknown-linux";  
    bigEndian = false;
    arch = "mips";
    float = "soft";
    withTLS = true;
    libc = "glibc";
    platform = {
      name = "malta";
      kernelBaseConfig = "malta_defconfig";
      kernelHeadersBaseConfig = "malta_defconfig";
      uboot = null;
      kernelArch = "mips";
      kernelAutoModules = false;
      kernelTarget = "vmlinux.bin";
    };
    openssl.system = "linux-generic32";
  };
in {
  crossMipselLinux = mapTestOnCross crossSystem basic;
}) // (

/* Test some cross builds to the ultrasparc */
let
  crossSystem = {
    config = "sparc64-unknown-linux";  
    bigEndian = true;
    arch = "sparc64";
    float = "hard";
    withTLS = true;
    cpu = "ultrasparc";
    libc = "glibc";
    platform = {
        name = "ultrasparc";
        kernelHeadersBaseConfig = "sparc64_defconfig";
        kernelBaseConfig = "sparc64_defconfig";
        kernelArch = "sparc";
        kernelAutoModules = false;
        kernelTarget = "zImage";
        uboot = null;
    };
    openssl.system = "linux64-sparcv9";
  };
in {
  crossUltraSparcLinux = mapTestOnCross crossSystem basic;
})
