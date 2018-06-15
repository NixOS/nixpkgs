{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lrzsz-0.12.20";

  src = fetchurl {
    url = "https://ohse.de/uwe/releases/${name}.tar.gz";
    sha256 = "1wcgfa9fsigf1gri74gq0pa7pyajk12m4z69x7ci9c6x9fqkd2y2";
  };

  hardeningDisable = [ "format" ];

  configureFlags = [ "--program-transform-name=s/^l//" ];

  meta = with stdenv.lib; {
    homepage = https://ohse.de/uwe/software/lrzsz.html;
    description = "Communication package providing the XMODEM, YMODEM ZMODEM file transfer protocols";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
