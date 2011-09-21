{ stdenv, fetchurl, libpng, xz }:

stdenv.mkDerivation rec {
  name = "pngcrush-1.7.17";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/${name}-nolib.tar.xz";
    sha256 = "0lh6wl0ci2y9b690n2zggc1mk21xj6iv378gvxk6gksgjkdw2rj2";
  };

  configurePhase = ''
    sed -i s,/usr,$out, Makefile
  '';

  buildInputs = [ xz libpng ];

  meta = {
    homepage = http://pmt.sourceforge.net/pngcrush;
    description = "A PNG optimizer";
    license = "free";
    platforms = with stdenv.lib.platforms; linux;
  };
}
