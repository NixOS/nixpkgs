{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  SDL,
  SDL_mixer,
  plib,
  libjpeg,
}:
let
  version = "0.9.13";
in
stdenv.mkDerivation rec {
  pname = "crrcsim";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/crrcsim/${pname}-${version}.tar.gz";
    sha256 = "abe59b35ebb4322f3c48e6aca57dbf27074282d4928d66c0caa40d7a97391698";
  };

  buildInputs = [
    libGLU
    libGL
    SDL
    SDL_mixer
    plib
    libjpeg
  ];

  patches = [
    ./gcc6.patch
  ];

  meta = {
    description = "A model-airplane flight simulator";
    mainProgram = "crrcsim";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.gpl2;
  };
}
