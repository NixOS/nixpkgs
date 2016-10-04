{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "which-2.21";

  src = fetchurl {
    url = "mirror://gnu/which/${name}.tar.gz";
    sha256 = "1bgafvy3ypbhhfznwjv1lxmd6mci3x1byilnnkc7gcr486wlb8pl";
  };

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  meta = with stdenv.lib; {
    homepage = http://ftp.gnu.org/gnu/which/;
    platforms = platforms.all;
    license = licenses.gpl3;
  };
}
