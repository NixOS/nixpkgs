{ stdenv, fetchFromGitHub, autoreconfHook, jam, pkgconfig
, zlib, libxml2, libxslt, xproto, libX11, libGLU_combined, SDL
, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, physfs
}:

stdenv.mkDerivation rec {
  name = "lincity-ng-${version}";
  version = "2.9beta.20170715";

  src = fetchFromGitHub {
    owner  = "lincity-ng";
    repo   = "lincity-ng";
    rev    = "0c19714b811225238f310633e59f428934185e6b";
    sha256 = "1gaj9fq97zmb0jsdw4rzrw34pimkmkwbfqps0glpqij4w3srz5f3";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    autoreconfHook jam pkgconfig
  ];

  buildInputs = [
    zlib libxml2 libxslt xproto libX11 libGLU_combined SDL SDL_mixer SDL_image
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

  meta = with stdenv.lib; {
    description = "City building game";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
