{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation rec {
  name = "dos2unix-${version}";
  version = "7.3.4";

  src = fetchurl {
    url = "http://waterlan.home.xs4all.nl/dos2unix/${name}.tar.gz";
    sha256 = "1i9hbxn0br7xa18z4bjpkdv7mrzmbfxhm44mzpd07yd2qnxsgkcc";
  };

  configurePhase = ''
    substituteInPlace Makefile \
    --replace /usr $out
    '';

  buildInputs = [ perl gettext ];

  meta = with stdenv.lib; {
    homepage = http://waterlan.home.xs4all.nl/dos2unix.html;
    description = "Tools to transform text files from dos to unix formats and vicervesa";
    license = licenses.bsd2;
    maintainers = with maintainers; [viric ndowens ];
    
  };
}
