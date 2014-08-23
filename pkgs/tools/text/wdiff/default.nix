{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "wdiff-1.2.1";

  src = fetchurl {
    url = "mirror://gnu/wdiff/${name}.tar.gz";
    sha256 = "1gb5hpiyikada9bwz63q3g96zs383iskiir0xsqynqnvq1vd4n41";
  };

  buildInputs = [ texinfo ];

  meta = {
    homepage = http://www.gnu.org/software/wdiff/;
    description = "GNU wdiff, comparing files on a word by word basis";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
