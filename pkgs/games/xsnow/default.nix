{ stdenv, fetchurl, libXt, libXpm, libXext, imake }:

stdenv.mkDerivation rec {

  version = "1.42";
  name = "xsnow";

  src = fetchurl {
    url = "http://dropmix.xs4all.nl/rick/Xsnow/xsnow-${version}.tar.gz";
    sha256 = "06jnbp88wc9i9dbmy7kggplw4hzlx2bhghxijmlhkjlizgqwimyh";
  };

  buildInputs = [
    libXt libXpm libXext imake
  ];

  buildPhase = ''
    xmkmf
    make
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp xsnow $out/bin/
    cp xsnow.1 $out/share/man/man1/
  '';

  meta = {
    description = "An X-windows application that will let it snow on the root, in between and on windows";
    homepage = http://dropmix.xs4all.nl/rick/Xsnow/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.robberer ];
  }; 
}
