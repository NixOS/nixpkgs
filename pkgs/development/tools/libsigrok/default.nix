{ stdenv, fetchurl, pkgconfig, libzip, glib, libusb1, libftdi, check
, libserialport, librevisa
}:

stdenv.mkDerivation rec {
  name = "libsigrok-0.3.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/libsigrok/${name}.tar.gz";
    sha256 = "0l3h7zvn3w4c1b9dgvl3hirc4aj1csfkgbk87jkpl7bgl03nk4j3";
  };

  firmware = fetchurl {
    url = "http://sigrok.org/download/binary/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-bin-0.1.2.tar.gz";
    sha256 = "0w0w6l015d16181mx8mgyjha4bv3ba7x36p86k9n1x52809433gj";
  };

  buildInputs = [ pkgconfig libzip glib libusb1 libftdi check libserialport
    librevisa
  ];

  postInstall = ''
    mkdir -p "$out/share/sigrok-firmware/"
    tar --strip-components=1 -xvf "${firmware}" -C "$out/share/sigrok-firmware/"
  '';

  meta = with stdenv.lib; {
    description = "Core library of the sigrok signal analysis software suite";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
