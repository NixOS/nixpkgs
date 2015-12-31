{ stdenv, fetchurl, qt4, box2d, which, cmake }:

stdenv.mkDerivation rec {
  name = "tbe-${version}";
  version = "0.9.2.1";

  src = fetchurl {
    url = "https://github.com/kaa-ching/tbe/archive/v${version}.tar.gz";
    sha256 = "1cs4q9qiakfd2m1lvfsvfgf8yvhxzmc06glng5d80piwyn6ymzxg";
  };

  buildInputs = [ qt4 box2d which cmake ];

  installPhase = ''
    make DESTDIR=.. install
    mkdir -p $out/bin
    cp ../usr/games/tbe $out/bin
    cp -r ../usr/share $out/
  '';

  meta = with stdenv.lib; {
    description = "A physics-based game vaguely similar to Incredible Machine";
    homepage = http://the-butterfly-effect.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
