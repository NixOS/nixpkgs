{ stdenv, fetchsvn, cups, zlib, jbigkit }:

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
    makeFlags="$makeFlags CUPSFILTER=$out/lib/cups/filter CUPSDRV=$out/share/cups/drv"
  '';

  buildFlags = [ "drv" "all" ];

  makeFlags = [ "DRV_ONLY=1" ];

  buildInputs = [ cups zlib jbigkit ];

  meta = {
    description = "CUPS drivers for SPL (Samsung Printer Language) printers";
    homepage = http://splix.sourceforge.net;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
