{stdenv, fetchurl, hal, pkgconfig, dbus}:
stdenv.mkDerivation {
  name = "pcsclite-1.5.5";

  src = fetchurl {
    url = https://alioth.debian.org/frs/download.php/3082/pcsc-lite-1.5.5.tar.bz2;
    sha256 = "09pdf4dbzjh235zp6x7aiby266i7kmmmz6bjdyf9mzyyq7ryc785";
  };

  # The OS should care on preparing the drivers into this location
  configureFlags = [ "--enable-usbdropdir=/var/lib/pcsc/drivers" ];

  preConfigure = ''
    configureFlags="$configureFlags --enable-confdir=$out/etc"
  '';
  buildInputs = [ hal pkgconfig dbus ];

  meta = {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = http://pcsclite.alioth.debian.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
