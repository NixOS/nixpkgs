with (import ./release-lib.nix);

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
    openssl.system = "linux-generic32";
  };
  nativePlatforms = linux;
in {
  crossSheevaplugLinux = mapTestOnCross crossSystem (rec {
    bison = nativePlatforms;
    tightvnc = nativePlatforms;
    #openoffice = nativePlatforms;
    wxGTK = nativePlatforms;
    #firefox = nativePlatforms;
    xorg = {
      #xorgserver = nativePlatforms;
    };
    nixUnstable = linux;
    linuxPackages_2_6_32.kernel = linux;
    linuxPackages_2_6_33.kernel = linux;
    gdbCross = nativePlatforms;
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
  nativePlatforms = linux;
in {
  crossMipselLinux = mapTestOnCross crossSystem (rec {
    bison = nativePlatforms;
    tightvnc = nativePlatforms;
    #openoffice = nativePlatforms;
    wxGTK = nativePlatforms;
    #firefox = nativePlatforms;
    xorg = {
      #xorgserver = nativePlatforms;
    };
    nixUnstable = linux;
    linuxPackages_2_6_32.kernel = linux;
    linuxPackages_2_6_33.kernel = linux;
    gdbCross = nativePlatforms;
  });
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
  nativePlatforms = linux;
in {
  crossUltraSparcLinux = mapTestOnCross crossSystem (rec {
    bison = nativePlatforms;
    tightvnc = nativePlatforms;
    #openoffice = nativePlatforms;
    wxGTK = nativePlatforms;
    #firefox = nativePlatforms;
    xorg = {
      #xorgserver = nativePlatforms;
    };
    nixUnstable = linux;
    linuxPackages_2_6_32.kernel = linux;
    linuxPackages_2_6_33.kernel = linux;
    gdbCross = nativePlatforms;
  });
})
