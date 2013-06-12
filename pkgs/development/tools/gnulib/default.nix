{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-0.0-7952-g439b0e9";

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "439b0e925f9ffb6fe58481717def708af96a9321";
    sha256 = "0xvnqn3323w0wnd1p7dhkcd4mihfh2dby88kv2dsclszppd9g4dc";
  };

  buildPhase = ":";

  installPhase = "mkdir -p $out; mv * $out/";

  meta = {
    homepage = "http://www.gnu.org/software/gnulib/";
    description = "central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
