{stdenv, fetchurl, perl, gettext, LocaleGettext}:

stdenv.mkDerivation {
  name = "help2man-1.36.1";

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/help2man/help2man-1.36.1.tar.gz;
    sha256 = "13w20lfvggzhvzs9dinxbhwdd61svsacfv9d78zfl9lf1syb5i1f";
  };

  buildInputs = [
    perl
    gettext
    LocaleGettext
  ];

  # So that configure can find `preloadable_libintl.so'.
  LD_LIBRARY_PATH = "${gettext}/lib";

  inherit gettext;
}
