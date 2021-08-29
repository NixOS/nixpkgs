{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, makeWrapper
, zlib, bzip2, libpng, lua5_1, toluapp
, SDL, SDL_mixer, SDL_image, libGL
}:

stdenv.mkDerivation rec {
  pname = "stratagus";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "wargus";
    repo = "stratagus";
    rev = "v${version}";
    sha256 = "128m5n9axq007xi8a002ig7d4dyw8j060542x220ld66ibfprhcn";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    zlib bzip2 libpng
    lua5_1 toluapp
    SDL.dev SDL_image SDL_mixer libGL
  ];
  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-Wno-error=format-overflow"
  ];

  meta = with lib; {
    description = "strategy game engine";
    homepage = "https://wargus.github.io/stratagus.html";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.astro ];
    platforms = platforms.linux;
  };
}
