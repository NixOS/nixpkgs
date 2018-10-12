{ stdenvNoCC, lib, buildPackages
, fetchurl, perl
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
    nativeBuildInputs = [ perl ];

    extraIncludeDirs = lib.optional stdenvNoCC.hostPlatform.isPowerPC ["ppc"];

    inherit patches;

    buildPhase = ''
      make mrproper headers_check SHELL=bash
    '';

    installPhase = ''
      make INSTALL_HDR_PATH=$out headers_install

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
    version = "4.18.3";
    sha256 = "1m23hjd02bg8mqnd8dc4z4m3kxds1cyrc6j5saiwnhzbz373rvc1";
  };
}
