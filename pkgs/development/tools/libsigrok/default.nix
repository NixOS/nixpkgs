{ stdenv, fetchurl, pkgconfig, libzip, glib, libusb1, libftdi, check
, libserialport, librevisa
}:

stdenv.mkDerivation rec {
  name = "libsigrok-0.3.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/libsigrok/${name}.tar.gz";
    sha256 = "0l3h7zvn3w4c1b9dgvl3hirc4aj1csfkgbk87jkpl7bgl03nk4j3";
  };

  buildInputs = [ pkgconfig libzip glib libusb1 libftdi check libserialport
    librevisa
  ];

  meta = with stdenv.lib; {
    description = "Core library of the sigrok signal analysis software suite";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
