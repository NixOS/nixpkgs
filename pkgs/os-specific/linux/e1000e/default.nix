{ stdenv, fetchurl, kernel }:

assert stdenv.lib.versionOlder kernel.version "4.10";

stdenv.mkDerivation rec {
  name = "e1000e-${version}-${kernel.version}";
  version = "3.3.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/e1000/e1000e-${version}.tar.gz";
    sha256 = "1ajz3vdnf1y307k585w95r6jlh4ah8d74bq36gdkjl1z5hgiqi9q";
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
