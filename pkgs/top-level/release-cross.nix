with (import ./release-lib.nix);
let
  nativePlatforms = linux;

  /* Basic list of packages to cross-build */
  basicHostDrv = {
    gccCrossStageFinal = nativePlatforms;
    bison.hostDrv = nativePlatforms;
    busybox.hostDrv = nativePlatforms;
    coreutils.hostDrv = nativePlatforms;
    dropbear.hostDrv = nativePlatforms;
    tigervnc.hostDrv = nativePlatforms;
    #openoffice.hostDrv = nativePlatforms;
    wxGTK.hostDrv = nativePlatforms;
    #firefox = nativePlatforms;
    xorg = {
      #xorgserver.hostDrv = nativePlatforms;
    };
    nixUnstable.hostDrv = nativePlatforms;
    linuxPackages_2_6_32.kernel.hostDrv = linux;
    linuxPackages_2_6_33.kernel.hostDrv = linux;
    linuxPackages_2_6_34.kernel.hostDrv = linux;
    linuxPackages_2_6_35.kernel.hostDrv = linux;
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
    uclibc.extraConfig = ''
      CONFIG_ARM_OABI n
      CONFIG_ARM_EABI y
      ARCH_BIG_ENDIAN n
      ARCH_WANTS_BIG_ENDIAN n
      ARCH_WANTS_LITTLE_ENDIAN y
      LINUXTHREADS_OLD y
    '';
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
    libc = "uclibc";
    platform = {
      name = "malta";
      kernelMajor = "2.4";
      kernelBaseConfig = "defconfig-malta";
      kernelHeadersBaseConfig = "defconfig-malta";
      uboot = null;
      kernelArch = "mips";
      kernelAutoModules = false;
      kernelTarget = "vmlinux";
    };
    openssl.system = "linux-generic32";
    uclibc.extraConfig = ''
      ARCH_BIG_ENDIAN n
      ARCH_WANTS_BIG_ENDIAN n
      ARCH_WANTS_LITTLE_ENDIAN y
      LINUXTHREADS_OLD y

      # Without this, it does not build for linux 2.4
      UCLIBC_SUSV4_LEGACY y
    '';
  };
in {
  crossMipselLinux24 = mapTestOnCross crossSystem basic;
}) // (

/* Test some cross builds to the ultrasparc */
let
  crossSystem = {
    config = "sparc64-unknown-linux";  
    bigEndian = true;
    arch = "sparc64";
    float = "hard";
    withTLS = true;
    libc = "glibc";
    platform = {
        name = "ultrasparc";
        kernelMajor = "2.6";
        kernelHeadersBaseConfig = "sparc64_defconfig";
        kernelBaseConfig = "sparc64_defconfig";
        kernelArch = "sparc";
        kernelAutoModules = false;
        kernelTarget = "zImage";
        uboot = null;
    };
    openssl.system = "linux64-sparcv9";
    gcc.cpu = "ultrasparc";
  };
in {
  crossUltraSparcLinux = mapTestOnCross crossSystem basic;
}) // (

/* Test some cross builds on mingw32 */
let
  crossSystem = {
      config = "i686-pc-mingw32";
      arch = "x86";
      libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
      platform = {};
  };
in {
  crossMingw32 = mapTestOnCross crossSystem {
    coreutils.hostDrv = nativePlatforms;
    boehmgc.hostDrv = nativePlatforms;
    gmp.hostDrv = nativePlatforms;
    guile_1_8.hostDrv = nativePlatforms;
    libffi.hostDrv = nativePlatforms;
    libtool.hostDrv = nativePlatforms;
    libunistring.hostDrv = nativePlatforms;
    windows.wxMSW.hostDrv = nativePlatforms;
  };
}) // (

/* GNU aka. GNU/Hurd.  */
let
  crossSystem = {
    config = "i586-pc-gnu";
    bigEndian = false;
    arch = "i586";
    float = "hard";
    withTLS = true;
    platform = pkgs.platforms.pc;
    libc = "glibc";
    openssl.system = "hurd-x86";  # Nix depends on OpenSSL.
    nix.system = "i686-gnu"; # Hack until nix is more cross-compile aware
  };
in {
  crossGNU = mapTestOnCross crossSystem {
    hurdCross = nativePlatforms;
    mach.hostDrv = nativePlatforms;

    coreutils.hostDrv = nativePlatforms;
    ed.hostDrv = nativePlatforms;
    grub2.hostDrv = nativePlatforms;
    inetutils.hostDrv = nativePlatforms;
    boehmgc.hostDrv = nativePlatforms;
    findutils.hostDrv = nativePlatforms;
    gcc.hostDrv = nativePlatforms;
    gdb.hostDrv = nativePlatforms;
    gmp.hostDrv = nativePlatforms;
    gnugrep.hostDrv = nativePlatforms;
    gnumake.hostDrv = nativePlatforms;
    gnused.hostDrv = nativePlatforms;
    guile_1_8.hostDrv = nativePlatforms;
    guile.hostDrv = nativePlatforms;
    libffi.hostDrv = nativePlatforms;
    libtool.hostDrv = nativePlatforms;
    libunistring.hostDrv = nativePlatforms;
    lsh.hostDrv = nativePlatforms;
    nixUnstable.hostDrv = nativePlatforms;
    patch.hostDrv = nativePlatforms;
    zile.hostDrv = nativePlatforms;
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

    coreutils.hostDrv = nativePlatforms;
    ed.hostDrv = nativePlatforms;
    grub2.hostDrv = nativePlatforms;
    inetutils.hostDrv = nativePlatforms;
    nixUnstable.hostDrv = nativePlatforms;
    patch.hostDrv = nativePlatforms;
    zile.hostDrv = nativePlatforms;
  };
}) // (

/* Linux on the Ben Nanonote */
let
  crossSystem = {
    config = "mipsel-unknown-linux";  
    bigEndian = false;
    arch = "mips";
    float = "soft";
    withTLS = true;
    libc = "glibc";
    platform = {
      name = "ben_nanonote";
      kernelMajor = "2.6";
      kernelBaseConfig = "qi_lb60_defconfig";
      kernelHeadersBaseConfig = "malta_defconfig";
      uboot = "nanonote";
      kernelArch = "mips";
      kernelAutoModules = false;
      kernelTarget = "vmlinux.bin";
      kernelExtraConfig = ''
        SOUND y
        SND y
        SND_MIPS y
        SND_SOC y
        SND_JZ4740_SOC y
        SND_JZ4740_SOC_QI_LB60 y
        FUSE_FS m
        MIPS_FPU_EMU y
      '';
    };
    openssl.system = "linux-generic32";
    perl.arch = "mipsel-unknown";
    uclibc.extraConfig = ''
      CONFIG_MIPS_ISA_1 n
      CONFIG_MIPS_ISA_MIPS32 y
      CONFIG_MIPS_N32_ABI n
      CONFIG_MIPS_O32_ABI y
      ARCH_BIG_ENDIAN n
      ARCH_WANTS_BIG_ENDIAN n
      ARCH_WANTS_LITTLE_ENDIAN y
      LINUXTHREADS_OLD y
    '';
    gcc = {
      abi = "32";
      arch = "mips32";
    };
    mpg123.cpu = "generic_nofpu";
  };
in {
  nanonote = mapTestOnCross crossSystem {

    coreutils.hostDrv = nativePlatforms;
    ed.hostDrv = nativePlatforms;
    inetutils.hostDrv = nativePlatforms;
    nixUnstable.hostDrv = nativePlatforms;
    patch.hostDrv = nativePlatforms;
    zile.hostDrv = nativePlatforms;
    prboom.hostDrv = nativePlatforms;
    vim.hostDrv = nativePlatforms;
    lynx.hostDrv = nativePlatforms;
    patchelf.hostDrv = nativePlatforms;
    nix.hostDrv = nativePlatforms;
    fossil.hostDrv = nativePlatforms;
    binutils.hostDrv = nativePlatforms;
    mpg123.hostDrv = nativePlatforms;
    yacas.hostDrv = nativePlatforms;
  };
})
