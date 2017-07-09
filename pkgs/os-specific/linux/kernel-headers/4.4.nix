{ stdenvNoCC, lib, buildPackages
, buildPlatform, hostPlatform
, fetchurl, perl
}:

assert hostPlatform.isLinux;

let
  version = "4.4.10";
  inherit (hostPlatform.platform) kernelHeadersBaseConfig;
in

stdenvNoCC.mkDerivation {
  name = "linux-headers-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1kpjvvd9q9wwr3314q5ymvxii4dv2d27295bzly225wlc552xhja";
  };

  targetConfig = if hostPlatform != buildPlatform then hostPlatform.config else null;

  platform = hostPlatform.platform.kernelArch or (
    if hostPlatform.system == "i686-linux" then "i386" else
    if hostPlatform.system == "x86_64-linux" then "x86_64" else
    if hostPlatform.system == "powerpc-linux" then "powerpc" else
    if hostPlatform.isArm then "arm" else
    abort "don't know what the kernel include directory is called for this platform");

  # It may look odd that we use `stdenvNoCC`, and yet explicit depend on a cc.
  # We do this so we have a build->build, not build->host, C compiler.
  nativeBuildInputs = [ buildPackages.stdenv.cc perl ];

  extraIncludeDirs = lib.optional hostPlatform.isPowerPC ["ppc"];

  buildPhase = ''
    if test -n "$targetConfig"; then
       export ARCH=$platform
    fi
    make ${kernelHeadersBaseConfig} SHELL=bash
    make mrproper headers_check SHELL=bash
  '';

  installPhase = ''
    make INSTALL_HDR_PATH=$out headers_install

    # Some builds (e.g. KVM) want a kernel.release.
    mkdir -p $out/include/config
    echo "${version}-default" > $out/include/config/kernel.release
  '';

  # !!! hacky
  fixupPhase = ''
    ln -s asm $out/include/asm-$platform
    if test "$platform" = "i386" -o "$platform" = "x86_64"; then
      ln -s asm $out/include/asm-x86
    fi
  '';

  meta = with lib; {
    description = "Header files and scripts for Linux kernel";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
