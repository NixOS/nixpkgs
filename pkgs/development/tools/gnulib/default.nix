{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-0.0-7901-g076ac82";

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "076ac82d1d7f4df54630f1b4917b3c14f227f032";
    sha256 = "023q3gqjrs8zdk31d81d3bcv9n5770nns0h5vq31saa5391qbpvn";
  };

  buildPhase = ":";

  installPhase = "mkdir -p $out; mv * $out/";

  meta = {
    homepage = "http://www.gnu.org/software/gnulib/";
    description = "central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
