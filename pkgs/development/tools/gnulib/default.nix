{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-0.1-83-g8008cac";

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "8008cac0568ee76a4a9b7002f839e1abbad78af6";
    sha256 = "1w8wh5ljh1qpssnj2lxizf45ggd7fgk5ggwhrnzjxxhn9m7rdvwm";
  };

  buildPhase = ":";

  installPhase = "mkdir -p $out; mv * $out/";

  meta = {
    homepage = "http://www.gnu.org/software/gnulib/";
    description = "central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
