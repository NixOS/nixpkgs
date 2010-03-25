{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wdiff-0.5.95";
  
  src = fetchurl {
    url = "http://alpha.gnu.org/gnu/wdiff/${name}.tar.gz";
    sha256 = "1rha2x8b6i0gk9s2gp61x4acakkx5q9ar1k54x9grmgr6w7fzd97";
  };
  
  meta = {
    homepage = http://www.gnu.org/software/wdiff/;
    description = "A front-end to diff for comparing files on a word per word basis";
    license = "GPLv3";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
