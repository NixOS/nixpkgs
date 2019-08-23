{stdenv, fetchurl, libjpeg, lcms2, gettext, jasper, libiconv }:

stdenv.mkDerivation rec {
  name = "dcraw-9.28.0";

  src = fetchurl {
    url = "https://www.cybercom.net/~dcoffin/dcraw/archive/${name}.tar.gz";
    sha256 = "1fdl3xa1fbm71xzc3760rsjkvf0x5jdjrvdzyg2l9ka24vdc7418";
  };

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;
  buildInputs = [ libjpeg lcms2 gettext jasper ];

  patchPhase = ''
    substituteInPlace install \
      --replace 'prefix=/usr/local' 'prefix=$out' \
      --replace gcc '$CC'
  '';

  buildPhase = ''
    mkdir -p $out/bin
    sh -e install
  '';

  meta = {
    homepage = http://www.cybercom.net/~dcoffin/dcraw/;
    description = "Decoder for many camera raw picture formats";
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix; # Once had cygwin problems
    maintainers = [ ];
  };
}
