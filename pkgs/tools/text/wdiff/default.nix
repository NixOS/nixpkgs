{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wdiff-0.6.3";

  src = fetchurl {
    url = "mirror://gnu/wdiff/${name}.tar.gz";
    sha256 = "04x0snfyahw9si160zwghh5nmijn535iacbbfsd376w4p0k5zk08";
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
