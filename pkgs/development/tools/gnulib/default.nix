{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-0.1-263-g92b60e6";

  phases = ["unpackPhase" "installPhase"];

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "92b60e61666f008385d9b7f7443da17c7a44d1b1";
    sha256 = "0xpxq8vqdl0niib961dnsrgjq6kbpyap6nnydzp15dvzfhzgz189";
  };

  installPhase = "mkdir -p $out; mv * $out/";

  meta = {
    homepage = "http://www.gnu.org/software/gnulib/";
    description = "central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
