{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-0.1-228-gb155b06";

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "b155b0649814b20e635a2db305696710fa1037ce";
    sha256 = "06r0cpm97k82hx6qqm9nbwyp5mr8g9qqdiw2ak2pndymc66v233l";
  };

  buildPhase = ":";

  installPhase = "mkdir -p $out; mv * $out/";

  meta = {
    homepage = "http://www.gnu.org/software/gnulib/";
    description = "central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
