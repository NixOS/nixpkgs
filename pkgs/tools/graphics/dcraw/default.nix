{stdenv, fetchurl, libjpeg, lcms2, gettext, jasper }:

stdenv.mkDerivation rec {
  name = "dcraw-9.26.0";

  src = fetchurl {
    url = "http://www.cybercom.net/~dcoffin/dcraw/archive/${name}.tar.gz";
    sha256 = "18zvzaxjq1yaj90xm8bwb30lqbjyjyp002bp175dayh3kr91syc5";
  };

  buildInputs = [ libjpeg lcms2 gettext jasper ];

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ install
  '';

  buildPhase = ''
    mkdir -p $out/bin
    sh install
  '';

  meta = {
    homepage = http://www.cybercom.net/~dcoffin/dcraw/;
    description = "Decoder for many camera raw picture formats";
    license = stdenv.lib.licenses.free;
    platforms = with stdenv.lib.platforms; allBut cygwin;
    maintainers = [ ];
  };
}
