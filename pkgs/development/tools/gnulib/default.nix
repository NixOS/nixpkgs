{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "gnulib-0.0-8015-gf0aab22";

  src = fetchgit {
    url = "http://git.savannah.gnu.org/r/gnulib.git";
    rev = "f0aab227265173908ecaa2353de6cf791cec3304";
    sha256 = "162i39wvrmjhkg8w07i92vg9l0f0lk57zl1ynf0lvs70rkdd8a82";
  };

  buildPhase = ":";

  installPhase = "mkdir -p $out; mv * $out/";

  meta = {
    homepage = "http://www.gnu.org/software/gnulib/";
    description = "central location for code to be shared among GNU packages";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
