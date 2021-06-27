{ lib, stdenv, fetchFromSourcehut
, SDL, SDL_image, libGLU, libGL, openal, libvorbis, freealut }:

stdenv.mkDerivation rec {
  pname = "blackshades";
  version = "1.1.1";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "1gx43hcqahbd21ib8blhzmsrwqfzx4qy7f10ck0mh2zc4bfihz64";
  };

  buildInputs = [ SDL SDL_image libGLU libGL openal libvorbis freealut ];

  patchPhase = ''
    sed -i -e s,Data/,$out/share/$pname/,g \
      -e s,Data:,$out/share/$pname/,g \
      src/*.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/$pname
    cp build/blackshades $out/bin
    cp -R Data $out/share/$pname
    cp README.md $out/share/doc/$pname
  '';

  meta = {
    homepage = "https://sr.ht/~cnx/blackshades";
    description = "A psychic bodyguard FPS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ McSinyx viric ];
    platforms = with lib.platforms; linux;
  };
}
