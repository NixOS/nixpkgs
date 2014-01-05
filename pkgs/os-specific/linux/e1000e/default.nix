{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation {
  name = "e1000e-2.5.4-${kernel.version}";

  src = fetchurl {
    url = "mirror://sourceforge/e1000/e1000e-2.5.4.tar.gz";
    sha256 = "0bmihkc7y37jzwi996ryqblnyflyhhbimbnrnmlk419vxlzg1pzi";
  };

  configurePhase = ''
    cd src
    kernel_version=${kernel.modDirVersion}
    sed -i -e 's|/lib/modules|${kernel.dev}/lib/modules|' Makefile
    export makeFlags="BUILD_KERNEL=$kernel_version"
  '';

  installPhase = ''
    install -v -D -m 644 e1000e.ko "$out/lib/modules/$kernel_version/kernel/drivers/net/e1000e/e1000e.ko"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = {
    description = "Linux kernel drivers for Intel Ethernet adapters and LOMs (LAN On Motherboard)";
    homepage = "http://e1000.sf.net/";
    license = stdenv.lib.licenses.gpl2;
  };
}
