{ lib, stdenv, fetchFromGitHub, autoreconfHook, jam, pkg-config
, zlib, libxml2, libxslt, xorgproto, libX11, libGLU, libGL, SDL
, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, physfs
}:

stdenv.mkDerivation {
  pname = "lincity-ng";
  version = "2.9beta.20170715";

  src = fetchFromGitHub {
    owner  = "lincity-ng";
    repo   = "lincity-ng";
    rev    = "0c19714b811225238f310633e59f428934185e6b";
    sha256 = "1gaj9fq97zmb0jsdw4rzrw34pimkmkwbfqps0glpqij4w3srz5f3";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    autoreconfHook jam pkg-config
  ];

  buildInputs = [
    zlib libxml2 libxslt xorgproto libX11 libGLU libGL SDL SDL_mixer SDL_image
    SDL_ttf SDL_gfx physfs
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
