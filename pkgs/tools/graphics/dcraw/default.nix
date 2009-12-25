{stdenv, fetchurl, libjpeg, lcms, gettext }:

stdenv.mkDerivation {
  name = "dcraw-8.98";

  src = fetchurl {
    url = http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-8.98.tar.gz;
    sha256 = "0vb375m1s5b1d72d9a5apcyxz2b9zl0pycj700yhy2zsfx804kmp";
  };

  buildInputs = [ libjpeg lcms gettext ];

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ install
  '';

  buildPhase = ''
    ensureDir $out/bin
    set +e
    sh install
    set -e
  '';

  meta = {
    homepage = http://www.cybercom.net/~dcoffin/dcraw/;
    description = "Decoder for many camera raw picture formats";
    license = "free";
  };
}
