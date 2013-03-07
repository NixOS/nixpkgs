{stdenv, fetchurl, perl, cross ? null}:

assert cross == null -> stdenv.isLinux;

let
  version = "2.4.37.9";
  kernelHeadersBaseConfig = if cross == null then
      stdenv.platform.kernelHeadersBaseConfig
    else
      cross.platform.kernelHeadersBaseConfig;
in

stdenv.mkDerivation {
  name = "linux-headers-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v2.4/linux-${version}.tar.bz2";
    sha256 = "08rca9lcb5l5w483hgaqk8pi2njd7cmwpkifjqxwlb3g8liz4r5g";
  };

  targetConfig = if cross != null then cross.config else null;

  platform =
    if cross != null then cross.platform.kernelArch else
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    if stdenv.isArm then "arm" else
    abort "don't know what the kernel include directory is called for this platform";

  buildInputs = [perl];

  patchPhase = ''
    sed -i s,/bin/pwd,pwd, Makefile
  '';

  extraIncludeDirs =
    if cross != null then
      (if cross.arch == "powerpc" then ["ppc"] else [])
    else if stdenv.system == "powerpc-linux" then ["ppc"] else [];

  buildPhase = ''
    cp arch/$platform/${kernelHeadersBaseConfig} .config
    make mrproper symlinks include/linux/{version,compile}.h \
      ARCH=$platform
    yes "" | make oldconfig ARCH=$platform
  '';

  installPhase = ''
    mkdir -p $out/include
    cp -a include/{asm,asm-$platform,acpi,linux,pcmcia,scsi,video} \
      $out/include
  '';
}
