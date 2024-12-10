{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  doxygen,
  pkg-config,
  freetype,
  fmt,
  glib,
  harfbuzz,
  liblcf,
  libpng,
  libsndfile,
  libvorbis,
  libxmp,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXScrnSaver,
  libXxf86vm,
  mpg123,
  opusfile,
  pcre,
  pixman,
  SDL2,
  speexdsp,
  wildmidi,
  zlib,
  libdecor,
  alsa-lib,
  asciidoctor,
  Foundation,
  AudioUnit,
  AudioToolbox,
}:

stdenv.mkDerivation rec {
  pname = "easyrpg-player";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = version;
    hash = "sha256-t0sa9ONVVfsiTy+us06vU2bMa4QmmQeYxU395g0WS6w=";
  };

  patches = [
    # Fixed compatibility with fmt > 9
    # Remove when version > 0.8
    (fetchpatch {
      name = "0001-Fix-building-with-fmtlib-10.patch";
      url = "https://github.com/EasyRPG/Player/commit/ab6286f6d01bada649ea52d1f0881dde7db7e0cf.patch";
      hash = "sha256-GdSdVFEG1OJCdf2ZIzTP+hSrz+ddhTMBvOPjvYQHy54=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    asciidoctor
    cmake
    doxygen
    pkg-config
  ];

  buildInputs =
    [
      fmt
      freetype
      glib
      harfbuzz
      liblcf
      libpng
      libsndfile
      libvorbis
      libxmp
      mpg123
      opusfile
      pcre
      pixman
      SDL2
      speexdsp
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libXcursor
      libXext
      libXi
      libXinerama
      libXrandr
      libXScrnSaver
      libXxf86vm
      libdecor
      wildmidi # until packaged on Darwin
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Foundation
      AudioUnit
      AudioToolbox
    ];

  cmakeFlags = [
    "-DPLAYER_ENABLE_TESTS=${lib.boolToString doCheck}"
  ];

  makeFlags = [
    "all"
    "man"
  ];

  buildFlags = lib.optionals doCheck [
    "test_runner_player"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/bin
    mv Package $out/Applications
    ln -s $out/{Applications/EasyRPG\ Player.app/Contents/MacOS,bin}/EasyRPG\ Player
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = true;

  meta = with lib; {
    description = "RPG Maker 2000/2003 and EasyRPG games interpreter";
    homepage = "https://easyrpg.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.all;
    mainProgram = lib.optionalString stdenv.hostPlatform.isDarwin "EasyRPG Player";
  };
}
