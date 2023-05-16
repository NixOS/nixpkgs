{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, pkg-config
, which
, copyDesktopItems
, makeBinaryWrapper
, SDL2
, libGL
, openal
=======
, which
, pkg-config
, SDL2
, libGL
, openalSoft
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, curl
, speex
, opusfile
, libogg
, libvorbis
<<<<<<< HEAD
, libjpeg
, makeDesktopItem
, freetype
, mumble
=======
, libopus
, libjpeg
, mumble
, freetype
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation {
  pname = "ioquake3";
<<<<<<< HEAD
  version = "unstable-2023-08-13";
=======
  version = "unstable-2022-11-24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
<<<<<<< HEAD
    rev = "ee950eb7b0e41437cc23a9943254c958da8a61ab";
    sha256 = "sha256-NfhInwrtw85i2mnv7EtBrrpNaslaQaVhLNlK0I9aYto=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    pkg-config
    which
  ];

  buildInputs = [
    SDL2
    libGL
    openal
=======
    rev = "70d07d91d62dcdd2f2268d1ac401bfb697b4c991";
    sha256 = "sha256-WDjR0ik+xAs6OA1DNbUGIF1MXSuEoy8nNkPiHaegfF0=";
  };

  nativeBuildInputs = [ which pkg-config ];
  buildInputs = [
    SDL2
    libGL
    openalSoft
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    curl
    speex
    opusfile
    libogg
    libvorbis
<<<<<<< HEAD
=======
    libopus
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libjpeg
    freetype
    mumble
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  preConfigure = ''
    cp ${./Makefile.local} ./Makefile.local
  '';

  installTargets = [ "copyfiles" ];

  installFlags = [ "COPYDIR=$(out)/share/ioquake3" ];

  postInstall = ''
    install -Dm644 misc/quake3.svg $out/share/icons/hicolor/scalable/apps/ioquake3.svg

    makeWrapper $out/share/ioquake3/ioquake3.* $out/bin/ioquake3
    makeWrapper $out/share/ioquake3/ioq3ded.* $out/bin/ioq3ded
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "IOQuake3";
      exec = "ioquake3";
      icon = "ioquake3";
      comment = "A fast-paced 3D first-person shooter, a community effort to continue supporting/developing id's Quake III Arena";
      desktopName = "ioquake3";
      categories = [ "Game" "ActionGame" ];
    })
  ];

  meta = {
    homepage = "https://ioquake3.org/";
    description = "A fast-paced 3D first-person shooter, a community effort to continue supporting/developing id's Quake III Arena";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ioquake3";
    maintainers = with lib.maintainers; [ abbradar drupol eelco rvolosatovs ];
    platforms = lib.platforms.linux;
=======
  makeFlags = [ "USE_INTERNAL_LIBS=0" "USE_FREETYPE=1" "USE_OPENAL_DLOPEN=0" "USE_CURL_DLOPEN=0" ];

  installTargets = [ "copyfiles" ];

  installFlags = [ "COPYDIR=$(out)" "COPYBINDIR=$(out)/bin" ];

  preInstall = ''
    mkdir -p $out/baseq3 $out/bin
  '';

  meta = with lib; {
    homepage = "https://ioquake3.org/";
    description = "First person shooter engine based on the Quake 3: Arena and Quake 3: Team Arena";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rvolosatovs eelco abbradar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
