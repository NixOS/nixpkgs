{stdenv, fetchurl, perl, gettext, LocaleGettext}:

stdenv.mkDerivation {
  name = "help2man-1.35.1";

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/help2man/help2man-1.35.1.tar.gz;
    md5 = "e3c9e846dd163eb7f1d1661e2d0baa07";
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
