{ stdenv, fetchsvn, fetchurl, cups, zlib }:
let rev = "315"; in
stdenv.mkDerivation rec {
  name = "splix-svn-${rev}";
  src = fetchsvn {
    # We build this from svn, because splix hasn't been in released in several years
    # although the community has been adding some new printer models.
    url = "svn://svn.code.sf.net/p/splix/code/splix";
    rev = "r${rev}";
    sha256 = "16wbm4xnz35ca3mw2iggf5f4jaxpyna718ia190ka6y4ah932jxl";
  };

  preBuild = ''
    makeFlags="V=1 DISABLE_JBIG=1 CUPSFILTER=$out/lib/cups/filter CUPSPPD=$out/share/cups/model"
  '';

  buildInputs = [cups zlib];

  meta = {
    homepage = http://splix.sourceforge.net;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
