{ stdenv, fetchurl, pkgconfig, libzip, glib, libusb1, libftdi, check
, libserialport, librevisa, doxygen, glibmm, python
, version ? "0.4.0", sha256 ? "17k63p3yhpx9qbfprgayphqqhn2hdrcph73g6fqxmrinxqziyaaz"
}:

stdenv.mkDerivation rec {
  inherit version;
  name = "libsigrok-${version}";

  src = fetchurl {
    url = "http://sigrok.org/download/source/libsigrok/${name}.tar.gz";
    inherit sha256;
  };

  firmware = fetchurl {
    url = "http://sigrok.org/download/binary/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-bin-0.1.3.tar.gz";
    sha256 = "1qr02ny97navqxr56xq1a227yzf6h09m8jlvc9bnjl0bsk6887bl";
  };

  buildInputs = [ pkgconfig libzip glib libusb1 libftdi check libserialport
    librevisa doxygen glibmm python
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
