{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation {
  name = "libtool-1.5.22";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/libtool/libtool-1.5.22.tar.gz;
    md5 = "8e0ac9797b62ba4dcc8a2fb7936412b0";
  };
  buildInputs = [m4 perl];
}
