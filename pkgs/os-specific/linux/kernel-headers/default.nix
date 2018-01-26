{ stdenvNoCC, lib, buildPackages
, buildPlatform, hostPlatform
, fetchurl, fetchpatch, perl
}:

assert hostPlatform.isLinux;

let
  common = { version, sha256, patches ? [] }: stdenvNoCC.mkDerivation {
    name = "linux-headers-${version}";

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
      inherit sha256;
    };

    ARCH = hostPlatform.platform.kernelArch;

    # It may look odd that we use `stdenvNoCC`, and yet explicit depend on a cc.
    # We do this so we have a build->build, not build->host, C compiler.
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [ perl ];

    extraIncludeDirs = lib.optional hostPlatform.isPowerPC ["ppc"];

    inherit patches;

    hardeningDisable = lib.optional buildPlatform.isDarwin "format";

    makeFlags = [
      "SHELL=bash"
      # Avoid use of runtime build->host compilers for checks
      "cc-version:=9999"
      "cc-fullversion:=999999"
      # `$(..)` expanded by make alone
      "HOSTCC:=$(BUILD_CC)"
      "HOSTCXX:=$(BUILD_CXX)"
    ];

    # Skip clean on darwin, case-sensitivity issues.
    buildPhase = lib.optionalString (!buildPlatform.isDarwin) ''
      make mrproper $makeFlags
    '' + ''
      make headers_install $makeFlags
    '';

    # doCheck = !buildPlatform.isDarwin;

    checkPhase = ''
      make headers_check $makeFlags
    '';

    installPhase = ''
      make headers_install INSTALL_HDR_PATH=$out $makeFlags

      # Some builds (e.g. KVM) want a kernel.release.
      mkdir -p $out/include/config
      echo "${version}-default" > $out/include/config/kernel.release
    '';

    meta = with lib; {
      description = "Header files and scripts for Linux kernel";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };
in {

  linuxHeaders = common {
    version = "4.15";
    sha256 = "0sd7l9n9h7vf9c6gd6ciji28hawda60yj0llh17my06m0s4lf9js";
    patches = [
       ./no-relocs.patch # for building x86 kernel headers on non-ELF platforms
       ./no-dynamic-cc-version-check.patch # so we can use `stdenvNoCC`, see `makeFlags` above
       #(fetchpatch { # For building on non-ELF platforms
       #  url = https://github.com/richfelker/musl-cross-make/blame/master/patches/linux-4.4.10/0001-archscripts.diff;
       #  sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
       #})
    ];
  };
}
