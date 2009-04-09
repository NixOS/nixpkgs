{stdenv, fetchurl, libjpeg, lcms, gettext }:

stdenv.mkDerivation {
  name = "dcraw-8.93";

  src = fetchurl {
    url = http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-8.93.tar.gz;
    sha256 = "1vjqfpqr0pczrf8ap3jpar1f98gik9is9v34sv1ridcxx87rniqz";
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
