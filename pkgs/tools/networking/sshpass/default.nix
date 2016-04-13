{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "sshpass-${version}";
  version = "1.05";
  
  src = fetchurl {
    url = "mirror://sourceforge/sshpass/sshpass-${version}.tar.gz";
    sha256 = "0gj8r05h1hy01vh4csygyw21z2hcxb72qcxkxxi3y34alr98gxy3";
  };
  
  meta = {
    homepage = http://sourceforge.net/projects/sshpass/;
    description = "Non-interactive ssh password auth";
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.unix;
  };
}
