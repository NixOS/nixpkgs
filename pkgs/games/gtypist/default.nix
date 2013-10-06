{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "gtypist-2.9.3";

  src = fetchurl {
    url = "mirror://gnu/gtypist/gtypist-2.9.3.tar.xz";
    sha256 = "0srwa841caci69hzqb47xfbxxf7fvz3640qka083p72vm8z9hsxw";
  };

  buildInputs = [ncurses];

  patchPhase = "sed -e 's#ncursesw/##' -i configure src/*";

  meta = {
    homepage = http://www.gnu.org/software/gtypist;
    description = "Universal typing tutor";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
