{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation {
  name = "e1000e-3.3.1-${kernel.version}";

  src = fetchurl {
    url = "mirror://sourceforge/e1000/e1000e-3.3.1.tar.gz";
    sha256 = "07hg6xxqgqshnys1qs9wbl9qr7d4ixdkd1y1fj27cg6bn8s2n797";
  };

  hardeningDisable = [ "pic" ];

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
