{stdenv, fetchurl, perl, gettext, perlLocaleGettext}:

stdenv.mkDerivation {
  name = "help2man-1.35.1";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/help2man-1.35.1.tar.gz;
    md5 = "e3c9e846dd163eb7f1d1661e2d0baa07";
  };

  buildInputs = [
    perl
    gettext
    perlLocaleGettext
  ];

  # So that configure can find `preloadable_libintl.so'.
  LD_LIBRARY_PATH = gettext + "/lib";

  inherit gettext;
}
