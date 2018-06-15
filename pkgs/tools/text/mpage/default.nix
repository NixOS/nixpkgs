{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "mpage-2.5.6";
  src = fetchurl {
    url = "http://www.libGLU_combined.nl/pub/mpage/${name}.tgz";
    sha256 = "016w9sm06sn1d2lim4p8fzl6wbmad3wigxhflsybzi7p4zy6vrjg";
  };

  patchPhase = ''
    sed -i "Makefile" -e "s|^ *PREFIX *=.*$|PREFIX = $out|g"
  '';

  meta = {
    description = "Many-to-one page printing utility";

    longDescription = ''
      Mpage reads plain text files or PostScript documents and prints
      them on a PostScript printer with the text reduced in size so
      that several pages appear on one sheet of paper.  This is useful
      for viewing large printouts on a small amount of paper.  It uses
      ISO 8859.1 to print 8-bit characters.
    '';

    license = "liberal";  # a non-copyleft license, see `Copyright' file
    homepage = http://www.libGLU_combined.nl/pub/mpage/;
    platforms = stdenv.lib.platforms.linux;
  };
}
