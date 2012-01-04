{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "icoutils-0.29.1";

  src = fetchurl {
    url = "mirror://savannah/icoutils/${name}.tar.bz2";
    sha256 = "180yqv41yc3fi6ggx7azhmaciqzadj0ir87wajigmcpgxkjk6v34";
  };

  buildInputs = [ libpng ];

  meta = {
    homepage = http://www.nongnu.org/icoutils/;
    description = "Set of  programs to deal with Microsoft Windows(R) icon and cursor files";
    license = "GPLv3+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
