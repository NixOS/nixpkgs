{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  scons,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  libGLU,
  libGL,
  libpng,
  physfs,
  unstableGitUpdater,
}:

let
  music = fetchurl {
    url = "https://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.dxa";
    sha256 = "05mz77vml396mff43dbs50524rlm4fyds6widypagfbh5hc55qdc";
  };

in
stdenv.mkDerivation {
  pname = "dxx-rebirth";
  version = "0.60.0-beta2-unstable-2025-05-24";

  src = fetchFromGitHub {
    owner = "dxx-rebirth";
    repo = "dxx-rebirth";
    rev = "7a84b3f307ac6f72fd440e55b149d7c2c942dfaf";
    hash = "sha256-b3rMitf2kw8y0EXwxeKKB8bqzCUaIaMQmpV1gtdcLis=";
  };

  nativeBuildInputs = [
    pkg-config
    scons
  ];

  buildInputs = [
    libGLU
    libGL
    libpng
    physfs
    SDL2
    SDL2_image
    SDL2_mixer
  ];

  enableParallelBuilding = true;

  sconsFlags = [ "sdl2=1" ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-format-nonliteral"
    "-Wno-format-truncation"
  ];

  postInstall = ''
    install -Dm644 ${music} $out/share/games/dxx-rebirth/${music.name}
    install -Dm644 -t $out/share/doc/dxx-rebirth *.txt
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Source Port of the Descent 1 and 2 engines";
    homepage = "https://www.dxx-rebirth.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
