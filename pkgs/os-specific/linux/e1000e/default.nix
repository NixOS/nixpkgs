{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation {
  name = "e1000e-1.5.1-${kernel.version}";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/e1000/e1000e-1.5.1.tar.gz";
    sha256 = "0nzjlarpqcpm5y112n3vzra4qv32hiygpfkk10y8g4nln4adhqsw";
  };

  buildInputs = [ kernel ];

  configurePhase = ''
    cd src
    kernel_version=$( cd ${kernel}/lib/modules && echo * )
    sed -i -e 's|/lib/modules|${kernel}/lib/modules|' Makefile
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
