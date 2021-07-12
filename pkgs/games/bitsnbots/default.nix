{ lib, stdenv, fetchurl, SDL, lua, libGLU, libGL }:

stdenv.mkDerivation rec {
  pname = "bitsnbots";
  version = "20111230";

  src = fetchurl {
    url = "http://moikmellah.org/downloads/bitsnbots/bitsnbots.source.tgz";
    sha256 = "1iiclm6bfpp2p6d692hpnw25xyr48ki1xkcxa7fvh5b7m1519gsp";
  };

  patchPhase = ''
    sed -i '/^INCLUDE/d' Makefile.linux
  '';

  makefile = "Makefile.linux";

  NIX_CFLAGS_COMPILE = "-I${SDL.dev}/include/SDL";

  NIX_LDFLAGS = "-lGL";

  installPhase = ''
    mkdir -p $out/share/${pname}-${version}
    cp -R bitsnbots resource scripts README $out/share/${pname}-${version}
    mkdir -p $out/bin
    ln -s $out/share/${pname}-${version}/bitsnbots $out/bin
  '';

  buildInputs = [ SDL lua libGLU libGL ];

  meta = {
    description = "Simple puzzle game with moving robots";
    homepage = "http://moikmellah.org/blog/?page_id=19";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux;
  };
}
