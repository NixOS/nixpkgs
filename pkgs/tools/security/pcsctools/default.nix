{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl, pcsclite }:

stdenv.mkDerivation rec {
  name = "pcsc-tools-1.4.23";

  src = fetchurl {
    url = "http://ludovic.rousseau.free.fr/softwares/pcsc-tools/pcsc-tools-1.4.23.tar.gz";
    sha256 = "1qjgvvvwhykmzn4js9s3rjnp9pbjc3sz4lb4d7i9kvr3xsv7pjk9";
  };

  buildInputs = [ udev dbus_libs perl pcsclite ];

  preBuild = ''
    makeFlags=DESTDIR=$out
  '';

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Tools used to test a PC/SC driver, card or reader";
    homepage = http://ludovic.rousseau.free.fr/softwares/pcsc-tools/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; linux;
  };
}
