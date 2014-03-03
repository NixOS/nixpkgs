{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "gtypist-2.9.4";

  src = fetchurl {
    url = "mirror://gnu/gtypist/gtypist-2.9.4.tar.xz";
    sha256 = "18f54lh7ihhfvgwk3xd9d087kmganrgi2jd7avhvwn5gcc31vrqq";
  };

  buildInputs = [ncurses];

  patchPhase = "sed -e 's#ncursesw/##' -i configure src/*";

  meta = {
    homepage = http://www.gnu.org/software/gtypist;
    description = "Universal typing tutor";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
