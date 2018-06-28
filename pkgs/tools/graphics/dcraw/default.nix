{stdenv, fetchurl, libjpeg, lcms2, gettext, jasper }:

stdenv.mkDerivation rec {
  name = "dcraw-9.28.0";

  src = fetchurl {
    url = "https://www.cybercom.net/~dcoffin/dcraw/archive/${name}.tar.gz";
    sha256 = "1fdl3xa1fbm71xzc3760rsjkvf0x5jdjrvdzyg2l9ka24vdc7418";
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
    platforms = stdenv.lib.platforms.unix; # Once had cygwin problems
    maintainers = [ ];
  };
}
