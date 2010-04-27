{stdenv, fetchurl, libjpeg, lcms, gettext }:

stdenv.mkDerivation {
  name = "dcraw-8.99";

  src = fetchurl {
    url = http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-8.99.tar.gz;
    sha256 = "0w557lsrj8fs666cxzhhv1rigmy705bnkn94rn856dwck59l3ipq";
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
