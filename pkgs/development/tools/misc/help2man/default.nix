{stdenv, fetchurl, perl, gettext, LocaleGettext}:

stdenv.mkDerivation {
  name = "help2man-1.37.1";

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/help2man/help2man-1.37.1.tar.gz;
    sha256 = "0q8msq7b71rdg73r49ibvljsr6i4rpqy7l52l9qca8p7z0gaji1v";
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
