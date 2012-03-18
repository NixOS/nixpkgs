{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "gtypist-2.9.1";

  src = fetchurl {
    url = "ftp://ftp.gnu.org/gnu/gtypist/gtypist-2.9.1.tar.xz";
    sha256 = "1yv209aih1ixbs477vzzk1xj013g6w32vi33g0hldfzvfxbl9y5s";
  };

  buildInputs = [ncurses];

  patches = [ (fetchurl {
    url = "http://projects.archlinux.org/svntogit/community.git/plain/trunk/ncurses.patch?h=packages/gtypist";
    sha256 = "1chdr4xkm140cjwv1n3ydk04qdwgycd12d9adz2sjc58lybqp7sy";
  })];

  meta = {
    homepage = http://www.gnu.org/software/gtypist;
    description = "GNU Typist (also called gtypist) is a universal typing tutor.";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
