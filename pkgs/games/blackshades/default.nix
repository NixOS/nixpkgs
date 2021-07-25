{ lib, stdenv, fetchFromSourcehut
, SDL, stb, libGLU, libGL, openal, libvorbis, freealut }:

stdenv.mkDerivation rec {
  pname = "blackshades";
  version = "1.3.1";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "0yzp74ynkcp6hh5m4zmvrgx5gwm186hq7p3m7qkww54qdyijb3rv";
  };

  buildInputs = [ SDL stb libGLU libGL openal libvorbis freealut ];

  postPatch = ''
    sed -i -e s,Data/,$out/share/$pname/,g \
      -e s,Data:,$out/share/$pname/,g \
      src/*.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp build/blackshades $out/bin
    cp -R Data $out/share/$pname
  '';

  meta = {
    homepage = "https://sr.ht/~cnx/blackshades";
    description = "A psychic bodyguard FPS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ McSinyx viric ];
    platforms = with lib.platforms; linux;
  };
}
