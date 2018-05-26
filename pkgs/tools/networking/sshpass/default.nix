{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "sshpass-${version}";
  version = "1.06";

  src = fetchurl {
    url = "mirror://sourceforge/sshpass/sshpass-${version}.tar.gz";
    sha256 = "0q7fblaczb7kwbsz0gdy9267z0sllzgmf0c7z5c9mf88wv74ycn6";
  };

  meta = {
    homepage = https://sourceforge.net/projects/sshpass/;
    description = "Non-interactive ssh password auth";
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.unix;
  };
}
