{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "olsrd-${version}";
  version = "0.9.6.1";

  src = fetchurl {
    url = "http://www.olsr.org/releases/0.9/${name}.tar.bz2";
    sha256 = "9cac290e9bff5fc7422110b9ccd972853f10962c962d2f31a63de9c6d1520612";
  };

  buildInputs = [ bison flex ];

  preConfigure = ''
    makeFlags="prefix=$out ETCDIR=$out/etc"
  '';

  meta = {
    description = "An adhoc wireless mesh routing daemon";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://olsr.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
