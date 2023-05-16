<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, doxygen
, pkg-config
, freetype
, fmt
, glib
, harfbuzz
, liblcf
, libpng
, libsndfile
, libvorbis
, libxmp
, libXcursor
, libXext
, libXi
, libXinerama
, libXrandr
, libXScrnSaver
, libXxf86vm
, mpg123
, opusfile
, pcre
, pixman
, SDL2
, speexdsp
, wildmidi
, zlib
, libdecor
, alsa-lib
, asciidoctor
, Foundation
, AudioUnit
, AudioToolbox
=======
{ lib, stdenv, fetchFromGitHub, cmake, doxygen ? null, pkg-config
, freetype ? null, fmt, glib, harfbuzz ? null
, liblcf, libpng, libsndfile ? null, libvorbis ? null, libxmp ? null
, libXcursor, libXext, libXi, libXinerama, libXrandr, libXScrnSaver, libXxf86vm
, mpg123 ? null, opusfile ? null, pcre, pixman, SDL2, speexdsp ? null, wildmidi ? null, zlib
, libdecor
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "easyrpg-player";
<<<<<<< HEAD
  version = "0.8";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = version;
<<<<<<< HEAD
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
=======
    sha256 = "049bj3jg3ldi3n11nx8xvh6pll68g7dcxz51q6z1gyyfxxws1qpj";
  };

  nativeBuildInputs = [ cmake doxygen pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    fmt
    freetype
    glib
    harfbuzz
    liblcf
    libpng
    libsndfile
    libvorbis
    libxmp
<<<<<<< HEAD
    mpg123
    opusfile
    pcre
    pixman
    SDL2
    speexdsp
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXScrnSaver
    libXxf86vm
<<<<<<< HEAD
    libdecor
    wildmidi # until packaged on Darwin
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

=======
    mpg123
    opusfile
    pcre
    pixman
    SDL2
    speexdsp
    wildmidi
    zlib
    libdecor
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "RPG Maker 2000/2003 and EasyRPG games interpreter";
    homepage = "https://easyrpg.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yana ];
<<<<<<< HEAD
    platforms = platforms.all;
    mainProgram = lib.optionalString stdenv.hostPlatform.isDarwin "EasyRPG Player";
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
