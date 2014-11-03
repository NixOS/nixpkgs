{ stdenv, fetchurl, linuxHeaders }:

stdenv.mkDerivation {
  name = "jujuutils-0.2";

  src = fetchurl {
    url = "http://jujuutils.googlecode.com/files/jujuutils-0.2.tar.gz";
    sha256 = "1r74m7s7rs9d6y7cffi7mdap3jf96qwm1v6jcw53x5cikgmfxn4x";
  };

  buildInputs = [ linuxHeaders ];

  meta = {
    homepage = "http://code.google.com/p/jujuutils/";
    description = "Utilities around FireWire devices connected to a Linux computer";
    license = stdenv.lib.licenses.gpl2;
  };
}
