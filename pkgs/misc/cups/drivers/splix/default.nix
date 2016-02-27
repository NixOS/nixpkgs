{ stdenv, fetchsvn, fetchurl, cups, zlib }:
let rev = "r315"; in
stdenv.mkDerivation (rec {
  name = "splix-svn-${rev}";
  src = fetchsvn {
    # We build this from svn, because splix hasn't been in released in several years
    # although the community has been adding some new printer models
    # if you are having problems, please try the stable version below and report back
    url = "svn://svn.code.sf.net/p/splix/code/splix";
    inherit rev;
    sha256 = "16wbm4xnz35ca3mw2iggf5f4jaxpyna718ia190ka6y4ah932jxl";
  };

  preBuild = ''
    makeFlags="V=1 DISABLE_JBIG=1 CUPSFILTER=$out/lib/cups/filter CUPSPPD=$out/share/cups/model"
  '';

  buildInputs = [ cups zlib ];

  meta = {
    homepage = http://splix.sourceforge.net;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };

} /* // { # uncomment to build the stable version

  name = "splix-2.0.0";
  patches = [ ./splix-2.0.0-gcc45.patch ];
  src = fetchurl {
    url = "mirror://sourceforge/splix/${name}.tar.bz2";
    sha256 = "0bwivrwwvh6hzvnycpzqs7a0capgycahc4s3v9ihx552fgy07xwp";
  };  

} */)
