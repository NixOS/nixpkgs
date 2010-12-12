{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wdiff-0.6.5";

  src = fetchurl {
    url = "mirror://gnu/wdiff/${name}.tar.gz";
    sha256 = "1fij74hni4mi1zipf5is8kr1i9cssyyq5kqqhcxi0j7mynb5d1sm";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/wdiff/;
    description = "GNU wdiff, comparing files on a word by word basis";
    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.eelco stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
