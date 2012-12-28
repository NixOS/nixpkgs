with (import ./release-lib.nix);
let
  nativePlatforms = linux;

  /* Basic list of packages to cross-build */
  basicHostDrv = {
    gccCrossStageFinal = nativePlatforms;
    bison.crossDrv = nativePlatforms;
    busybox.crossDrv = nativePlatforms;
    coreutils.crossDrv = nativePlatforms;
    dropbear.crossDrv = nativePlatforms;
    tigervnc.crossDrv = nativePlatforms;
    #openoffice.crossDrv = nativePlatforms;
    wxGTK.crossDrv = nativePlatforms;
    #firefox = nativePlatforms;
    xorg = {
      #xorgserver.crossDrv = nativePlatforms;
    };
    nixUnstable.crossDrv = nativePlatforms;
    linuxPackages_3_3.kernel.crossDrv = linux;
    linuxPackages_3_4.kernel.crossDrv = linux;
    linuxPackages_3_6.kernel.crossDrv = linux;
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
      ubootSheevaplug.crossDrv = nativePlatforms;
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
      ubootSheevaplug.crossDrv = nativePlatforms;
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

/* Test some cross builds on mingw-w64 */
let
  crossSystem = {
      # That's the triplet they use in the mingw-w64 docs,
      # and it's relevant for nixpkgs conditions.
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
  };
in {
  crossGNU = mapTestOnCross crossSystem {
    gnu.hurdCross = nativePlatforms;
    gnu.mach.crossDrv = nativePlatforms;
    gnu.mig = nativePlatforms;
    gnu.smbfs.crossDrv = nativePlatforms;

    coreutils.crossDrv = nativePlatforms;
    ed.crossDrv = nativePlatforms;
    grub2.crossDrv = nativePlatforms;
    inetutils.crossDrv = nativePlatforms;
    boehmgc.crossDrv = nativePlatforms;
    findutils.crossDrv = nativePlatforms;
    gcc.crossDrv = nativePlatforms;
    gcc46.crossDrv = nativePlatforms;
    gdb.crossDrv = nativePlatforms;
    gmp.crossDrv = nativePlatforms;
    gnugrep.crossDrv = nativePlatforms;
    gnumake.crossDrv = nativePlatforms;
    gnused.crossDrv = nativePlatforms;
    guile_1_8.crossDrv = nativePlatforms;
    guile.crossDrv = nativePlatforms;
    libffi.crossDrv = nativePlatforms;
    libtool.crossDrv = nativePlatforms;
    libunistring.crossDrv = nativePlatforms;
    lsh.crossDrv = nativePlatforms;
    nixUnstable.crossDrv = nativePlatforms;
    openssl.crossDrv = nativePlatforms;            # dependency of Nix
    patch.crossDrv = nativePlatforms;
    samba_light.crossDrv = nativePlatforms;      # needed for `runInGenericVM'
    zile.crossDrv = nativePlatforms;
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
    grub2.crossDrv = nativePlatforms;
    inetutils.crossDrv = nativePlatforms;
    nixUnstable.crossDrv = nativePlatforms;
    patch.crossDrv = nativePlatforms;
    zile.crossDrv = nativePlatforms;
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

    coreutils.crossDrv = nativePlatforms;
    ed.crossDrv = nativePlatforms;
    inetutils.crossDrv = nativePlatforms;
    nixUnstable.crossDrv = nativePlatforms;
    patch.crossDrv = nativePlatforms;
    zile.crossDrv = nativePlatforms;
    prboom.crossDrv = nativePlatforms;
    vim.crossDrv = nativePlatforms;
    lynx.crossDrv = nativePlatforms;
    patchelf.crossDrv = nativePlatforms;
    nix.crossDrv = nativePlatforms;
    fossil.crossDrv = nativePlatforms;
    binutils.crossDrv = nativePlatforms;
    mpg123.crossDrv = nativePlatforms;
    yacas.crossDrv = nativePlatforms;
  };
})
