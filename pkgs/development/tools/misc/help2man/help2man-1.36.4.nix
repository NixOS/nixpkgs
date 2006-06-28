{stdenv, fetchurl, perl, gettext, perlLocaleGettext}:

stdenv.mkDerivation {
  name = "help2man-1.36.4";

  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/help2man/help2man-1.36.4.tar.gz;
    md5 = "d31a0a38c2ec71faa06723f6b8bd3076";
  };

  buildInputs = [
    perl
    gettext
    perlLocaleGettext
  ];

  # So that configure can find `preloadable_libintl.so'.
  LD_LIBRARY_PATH = gettext ~ "/lib";

  inherit gettext;
}
