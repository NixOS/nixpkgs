{ stdenv
, SDL2
, SDL2_gfx
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, autoreconfHook
, fetchFromGitHub
, jam
, lib
, libGL
, libGLU
, libX11
, libxml2
, libxslt
, physfs
, pkg-config
, xorgproto
, zlib
}:

stdenv.mkDerivation {
  pname = "lincity-ng";
  version = "2.9beta.20211125";

  src = fetchFromGitHub {
    owner = "lincity-ng";
    repo = "lincity-ng";
    rev = "b9062bec252632ca5d26b98d71453b8762c63173";
    sha256 = "0l07cn8rmpmlqdppjc2ikh5c7xmwib27504zpmn3n9pryp394r46";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    autoreconfHook
    jam
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libGL
    libGLU
    libX11
    libxml2
    libxslt
    physfs
    xorgproto
    zlib
  ];

  autoreconfPhase = ''
    ./autogen.sh
  '';

  buildPhase = ''
    runHook preBuild

    AR='ar r' jam -j $NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    touch CREDITS
    AR='ar r' jam install

    runHook postInstall
  '';

  meta = with lib; {
    description = "City building game";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
