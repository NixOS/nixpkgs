{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-0.0-7899-g34f8464";

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "34f84640cd015eee3d9aed3b1eddf6f361576890";
    sha256 = "9267827d6b3f0eb97957eae7851afd4e5ac8aa714a83e3be52e7b660cc27851d";
  };

  buildPhase = ":";

  installPhase = "mkdir -p $out; mv * $out/";

  meta = {
    homepage = "http://www.gnu.org/software/gnulib/";
    description = "central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
