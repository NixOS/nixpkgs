{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-0.1-357-gffe6467";

  phases = ["unpackPhase" "installPhase"];

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "92b60e61666f008385d9b7f7443da17c7a44d1b1";
    sha256 = "0sa1dndvaxhw0zyc19al5cmpgzlwnnznjz89lw1b4vj3xn7avjnr";
  };

  installPhase = "mkdir -p $out; mv * $out/";

  meta = {
    homepage = http://www.gnu.org/software/gnulib/;
    description = "Central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
