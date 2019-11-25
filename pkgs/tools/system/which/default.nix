{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "which-2.21";

  src = fetchurl {
    url = "mirror://gnu/which/${name}.tar.gz";
    sha256 = "1bgafvy3ypbhhfznwjv1lxmd6mci3x1byilnnkc7gcr486wlb8pl";
  };

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/which/;
    description = "Shows the full path of (shell) commands";
    platforms = platforms.all;
    license = licenses.gpl3;
  };
}
