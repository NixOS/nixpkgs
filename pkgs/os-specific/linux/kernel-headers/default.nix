{ stdenvNoCC, lib, buildPackages
, fetchurl, fetchpatch, perl
, elf-header
}:

let
  common = { version, sha256, patches ? [] }: stdenvNoCC.mkDerivation {
    name = "linux-headers-${version}";

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
      inherit sha256;
    };

    ARCH = stdenvNoCC.hostPlatform.platform.kernelArch or (throw "missing kernelArch");

    # It may look odd that we use `stdenvNoCC`, and yet explicit depend on a cc.
    # We do this so we have a build->build, not build->host, C compiler.
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    # `elf-header` is null when libc provides `elf.h`.
    nativeBuildInputs = [ perl elf-header ];

    extraIncludeDirs = lib.optional stdenvNoCC.hostPlatform.isPowerPC ["ppc"];

    inherit patches;

    hardeningDisable = lib.optional stdenvNoCC.buildPlatform.isDarwin "format";

    makeFlags = [
      "SHELL=bash"
      # Avoid use of runtime build->host compilers for checks. These
      # checks only cared to work around bugs in very old compilers, so
      # these changes should be safe.
      "cc-version:=9999"
      "cc-fullversion:=999999"
      # `$(..)` expanded by make alone
      "HOSTCC:=$(BUILD_CC)"
      "HOSTCXX:=$(BUILD_CXX)"
    ];

    # Skip clean on darwin, case-sensitivity issues.
    buildPhase = lib.optionalString (!stdenvNoCC.buildPlatform.isDarwin) ''
      make mrproper $makeFlags
    ''
    # For some reason, doing `make install_headers` twice, first without
    # INSTALL_HDR_PATH=$out then with, is neccessary to get this to work
    # for darwin cross. @Ericson2314 has no idea why.
    + ''
      make headers_install $makeFlags
    '';

    checkPhase = ''
      make headers_check $makeFlags
    '';

    installPhase = ''
      make headers_install INSTALL_HDR_PATH=$out $makeFlags
    ''
    # Some builds (e.g. KVM) want a kernel.release.
    + '' mkdir -p $out/include/config
      echo "${version}-default" > $out/include/config/kernel.release
    ''
    # These oddly named file records teh `SHELL` passed, which causes bootstrap
    # tools run-time dependency.
    + ''
      find "$out" -name '..install.cmd' -print0 | xargs -0 rm
    '';

    meta = with lib; {
      description = "Header files and scripts for Linux kernel";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };
in {

  linuxHeaders = common {
    version = "4.18.3";
    sha256 = "1m23hjd02bg8mqnd8dc4z4m3kxds1cyrc6j5saiwnhzbz373rvc1";
    patches = [
       ./no-relocs.patch # for building x86 kernel headers on non-ELF platforms
       ./no-dynamic-cc-version-check.patch # so we can use `stdenvNoCC`, see `makeFlags` above
    ];
  };
}
