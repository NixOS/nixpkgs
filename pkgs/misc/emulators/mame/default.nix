{ stdenv, mkDerivation, fetchFromGitHub, makeDesktopItem, makeWrapper
, python, pkgconfig, SDL2, SDL2_ttf, alsaLib, which, qtbase, libXinerama
, libpcap, CoreAudioKit, ForceFeedback
, installShellFiles }:

with stdenv;

let
  majorVersion = "0";
  minorVersion = "222";

  desktopItem = makeDesktopItem {
    name = "MAME";
    exec = "mame${lib.optionalString stdenv.is64bit "64"}";
    desktopName = "MAME";
    genericName = "MAME is a multi-purpose emulation framework";
    categories = "System;Emulator;";
  };

  dest = "$out/opt/mame";
in mkDerivation {
  pname = "mame";
  version = "${majorVersion}.${minorVersion}";

  src = fetchFromGitHub {
    owner = "mamedev";
    repo = "mame";
    rev = "mame${majorVersion}${minorVersion}";
    sha256 = "1ij08h7cflr76qzyhhj21948275lqkpzi9r4pbc7h2avrlpsijx4";
  };

  hardeningDisable = [ "fortify" ];
  NIX_CFLAGS_COMPILE = [ "-Wno-error=maybe-uninitialized" "-Wno-error=missing-braces" ];

  makeFlags = [
    "TOOLS=1"
    "USE_LIBSDL=1"
  ]
  ++ lib.optionals stdenv.cc.isClang [ "CC=clang" "CXX=clang++" ]
  ;

  dontWrapQtApps = true;

  buildInputs =
    [ SDL2 SDL2_ttf qtbase libXinerama ]
    ++ lib.optional stdenv.isLinux alsaLib
    ++ lib.optionals stdenv.isDarwin [ libpcap CoreAudioKit ForceFeedback ]
    ;
  nativeBuildInputs = [ python pkgconfig which makeWrapper installShellFiles ];

  # by default MAME assumes that paths with stock resources
  # are relative and that you run MAME changing to
  # install directory, so we add absolute paths here
  patches = [ ./emuopts.patch ];

  postPatch = ''
    substituteInPlace src/emu/emuopts.cpp \
      --subst-var-by mame ${dest}
  '';

  installPhase = ''
    make -f dist.mak PTR64=${stdenv.lib.optionalString stdenv.is64bit "1"}
    mkdir -p ${dest}
    mv build/release/*/Release/mame/* ${dest}

    mkdir -p $out/bin
    find ${dest} -maxdepth 1 -executable -type f -exec mv -t $out/bin {} \;
    install -Dm755 src/osd/sdl/taputil.sh $out/bin/taputil.sh

    installManPage ${dest}/docs/man/*.1 ${dest}/docs/man/*.6

    mv artwork plugins samples ${dest}
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $out/share
    ln -s ${desktopItem}/share/applications $out/share
  '';

  meta = with lib; {
    description = "Is a multi-purpose emulation framework";
    homepage = "https://www.mamedev.org/";
    license = with licenses; [ bsd3 gpl2Plus ];
    platforms = platforms.unix;
    # makefile needs fixes for install target
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with maintainers; [ gnidorah ];
  };
}
