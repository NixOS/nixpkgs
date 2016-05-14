{ stdenv, fetchurl, perl, cross ? null }:

assert cross == null -> stdenv.isLinux;

let

  version = "4.4.10";

  kernelHeadersBaseConfig =
    if cross == null
    then stdenv.platform.kernelHeadersBaseConfig
    else cross.platform.kernelHeadersBaseConfig;

in

stdenv.mkDerivation {
  name = "linux-headers-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1kpjvvd9q9wwr3314q5ymvxii4dv2d27295bzly225wlc552xhja";
  };

  targetConfig = if cross != null then cross.config else null;

  platform =
    if cross != null then cross.platform.kernelArch else
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    if stdenv.isArm then "arm" else
    if stdenv.platform ? kernelArch then stdenv.platform.kernelArch else
    abort "don't know what the kernel include directory is called for this platform";

  buildInputs = [perl];

  extraIncludeDirs =
    if cross != null then
        (if cross.arch == "powerpc" then ["ppc"] else [])
    else if stdenv.system == "powerpc-linux" then ["ppc"] else [];

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

  meta = with stdenv.lib; {
    description = "Header files and scripts for Linux kernel";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
