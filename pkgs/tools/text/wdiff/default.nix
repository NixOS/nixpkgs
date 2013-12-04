{ stdenv, fetchurl, which, screen }:

stdenv.mkDerivation rec {
  name = "wdiff-1.1.2";

  src = fetchurl {
    url = "mirror://gnu/wdiff/${name}.tar.gz";
    sha256 = "0q78y5awvjjmsvizqilbpwany62shlmlq2ayxkjbygmdafpk1k8j";
  };

  # Required for the compile-time for the test suite.
  buildInputs = [ which screen ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/wdiff/;
    description = "GNU wdiff, comparing files on a word by word basis";
    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
