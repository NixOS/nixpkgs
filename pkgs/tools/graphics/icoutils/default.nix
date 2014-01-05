{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "icoutils-0.31.0";

  src = fetchurl {
    url = "mirror://savannah/icoutils/${name}.tar.bz2";
    sha256 = "0wdgyfb1clrn3maq84vi4vkwjydy72p5hzk6kb9nb3a19bbxk5d8";
  };

  buildInputs = [ libpng ];

  meta = {
    homepage = http://www.nongnu.org/icoutils/;
    description = "Set of  programs to deal with Microsoft Windows(R) icon and cursor files";
    license = "GPLv3+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
