{ stdenv, fetchurl, texinfo, which }:

stdenv.mkDerivation rec {
  name = "wdiff-1.2.2";

  src = fetchurl {
    url = "mirror://gnu/wdiff/${name}.tar.gz";
    sha256 = "0sxgg0ms5lhi4aqqvz1rj4s77yi9wymfm3l3gbjfd1qchy66kzrl";
  };

  buildInputs = [ texinfo ];

  checkInputs = [ which ];

  meta = {
    homepage = https://www.gnu.org/software/wdiff/;
    description = "Comparing files on a word by word basis";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
  };
}
