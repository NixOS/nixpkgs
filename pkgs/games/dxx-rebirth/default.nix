{ stdenv
, fetchFromGitHub
, fetchurl
, fetchpatch
, scons
, pkgconfig
, SDL
, SDL_mixer
, libGLU
, libGL
, libpng
, physfs
}:

let
  music = fetchurl {
    url = "https://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.dxa";
    sha256 = "05mz77vml396mff43dbs50524rlm4fyds6widypagfbh5hc55qdc";
  };

in
stdenv.mkDerivation rec {
  pname = "dxx-rebirth";
  version = "0.59.20200202";

  src = fetchFromGitHub {
    owner = "dxx-rebirth";
    repo = "dxx-rebirth";
    rev = "8ebb66c5c9c74ebb93d49741cc9545f2bb7fa05d";
    sha256 = "1lsrlp47aby2m9hh7i3nv5rb0srlkmnq1w2ca6vyvlga9m9h7jrk";
  };

  nativeBuildInputs = [ pkgconfig scons ];

  buildInputs = [ libGLU libGL libpng physfs SDL SDL_mixer ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [
    "-Wno-format-nonliteral"
    "-Wno-format-truncation"
  ];

  postInstall = ''
    install -Dm644 ${music} $out/share/games/dxx-rebirth/${music.name}
    install -Dm644 -t $out/share/doc/dxx-rebirth *.txt
  '';

  meta = with stdenv.lib; {
    description = "Source Port of the Descent 1 and 2 engines";
    homepage = "https://www.dxx-rebirth.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
