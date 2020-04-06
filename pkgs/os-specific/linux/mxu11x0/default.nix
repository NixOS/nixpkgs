{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation {
  name = "mxu11x0-1.4-${kernel.version}";

  src = fetchurl {
    url = "https://www.moxa.com/Moxa/media/PDIM/S100000385/moxa-uport-1000-series-linux-3.x-and-4.x-for-uport-11x0-series-driver-v1.4.tgz";
    sha256 = "1hz9ygabbp8pv49k1j4qcsr0v3zw9xy0bh1akqgxp5v29gbdgxjl";
  };

  preBuild = ''
    sed -i -e "s/\$(uname -r).*/${kernel.modDirVersion}/g" driver/mxconf
    sed -i -e "s/\$(shell uname -r).*/${kernel.modDirVersion}/g" driver/Makefile
    sed -i -e 's|/lib/modules|${kernel.dev}/lib/modules|' driver/mxconf
    sed -i -e 's|/lib/modules|${kernel.dev}/lib/modules|' driver/Makefile
  '';
  
  installPhase = ''
    install -v -D -m 644 ./driver/mxu11x0.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/usb/serial/mxu11x0.ko"
    install -v -D -m 644 ./driver/mxu11x0.ko "$out/lib/modules/${kernel.modDirVersion}/misc/mxu11x0.ko"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  hardeningDisable = [ "pic" ];

  meta = with stdenv.lib; {
    description = "MOXA UPort 11x0 USB to Serial Hub driver";
    homepage = https://www.moxa.com/en/products/industrial-edge-connectivity/usb-to-serial-converters-usb-hubs/usb-to-serial-converters/uport-1000-series;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ uralbash ];
    platforms = platforms.linux;
  };
}
