{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, which
, copyDesktopItems
, makeBinaryWrapper
, SDL2
, libGL
, openal
, curl
, speex
, opusfile
, libogg
, libvorbis
, libjpeg
, makeDesktopItem
, freetype
, mumble
}:

stdenv.mkDerivation {
  pname = "ioquake3";
  version = "unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
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
    curl
    speex
    opusfile
    libogg
    libvorbis
    libjpeg
    freetype
    mumble
  ];

  enableParallelBuilding = true;

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
    description = "Fast-paced 3D first-person shooter, a community effort to continue supporting/developing id's Quake III Arena";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ioquake3";
    maintainers = with lib.maintainers; [ abbradar drupol eelco rvolosatovs ];
    platforms = lib.platforms.linux;
  };
}
