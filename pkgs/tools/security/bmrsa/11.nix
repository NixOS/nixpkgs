{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "bmrsa-${version}";
  version = "11";

  src = fetchurl {
    url = "mirror://sourceforge/bmrsa/bmrsa${version}.zip";
    sha256 = "0ksd9xkvm9lkvj4yl5sl0zmydp1wn3xhc55b28gj70gi4k75kcl4";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir bmrsa
    cd bmrsa
    unzip ${src}
    sed -e 's/gcc/g++/' -i Makefile
    mkdir -p $out/bin
    echo -e 'install:\n\tcp bmrsa '$out'/bin' >> Makefile
  '';

  meta = with stdenv.lib; {
    description = "RSA utility";
    homepage = http://bmrsa.sourceforge.net/;
    license = licenses.gpl1;
    platforms = platforms.linux;
  };
}
