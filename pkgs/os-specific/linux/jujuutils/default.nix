{ stdenv, fetchurl, linuxHeaders }:

stdenv.mkDerivation {
  name = "jujuutils-0.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/jujuutils/jujuutils-0.2.tar.gz";
    sha256 = "1r74m7s7rs9d6y7cffi7mdap3jf96qwm1v6jcw53x5cikgmfxn4x";
  };

  buildInputs = [ linuxHeaders ];

  meta = {
    homepage = https://github.com/cladisch/linux-firewire-utils;
    description = "Utilities around FireWire devices connected to a Linux computer";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
