{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gettext,
  makeWrapper,
  bzip2,
  curl,
  libjpeg,
  libxml2,
  xz,
  lua,
  ode,
  libGL,
  libpng,
  SDL,
  SDL_mixer,
  SDL_net,
  SDL_ttf,
  sqlite,
  libxdg_basedir,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "xmoto";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "00f5ha79lfa2iiaz66wl0hl5dapa1l15qdr7m7knzi0ll7j6z66n";
  };

  patches = [
    # Fix build with Nix
    (fetchpatch {
      url = "https://github.com/xmoto/xmoto/commit/536dcc7ec77a4c4c454b86220e85b1cb3cd1c7f7.patch";
      sha256 = "0h9lld668jrbmrqva89zqwp63jiagjj86prkxzx6372p3kk9y7g7";
    })
  ];

  nativeBuildInputs = [
    cmake
    gettext
    makeWrapper
  ];

  buildInputs = [
    bzip2
    curl
    libjpeg
    libxml2
    xz
    lua
    ode
    libGL
    libpng
    SDL
    SDL_mixer
    SDL_net
    SDL_ttf
    sqlite
    libxdg_basedir
    zlib
  ];

  preFixup = ''
    wrapProgram "$out/bin/xmoto" \
      --prefix XDG_DATA_DIRS : "$out/share/"
  '';

  meta = with lib; {
    description = "A challenging 2D motocross platform game, where physics play an important role";
    mainProgram = "xmoto";
    longDescription = ''
      X-Moto is a challenging 2D motocross platform game, where physics plays an all important role in the gameplay.
      You need to control your bike to its limits, if you want to have a chance to finish the most difficult challenges.
    '';
    homepage = "https://xmoto.tuxfamily.org";
    maintainers = with maintainers; [
      raskin
      pSub
    ];
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
