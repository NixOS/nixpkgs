{ stdenv, mkDerivation, fetchFromGitHub, makeDesktopItem, makeWrapper
, python, pkgconfig, SDL2, SDL2_ttf, alsaLib, which, qtbase, libXinerama
, installShellFiles }:

let
  majorVersion = "0";
  minorVersion = "217";

  desktopItem = makeDesktopItem {
    name = "MAME";
    exec = "mame${stdenv.lib.optionalString stdenv.is64bit "64"}";
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
    sha256 = "0yzn29fp72k2g5xgv47ss6fr3sk9wdxw9f52nwld1baxr2adc0qx";
  };

  hardeningDisable = [ "fortify" ];
  NIX_CFLAGS_COMPILE = [ "-Wno-error=maybe-uninitialized" ];

  makeFlags = [ "TOOLS=1" ];

  dontWrapQtApps = true;

  buildInputs = [ SDL2 SDL2_ttf alsaLib qtbase libXinerama ];
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

    mkdir -p $out/share
    ln -s ${desktopItem}/share/applications $out/share
  '';

  meta = with stdenv.lib; {
    description = "Is a multi-purpose emulation framework";
    homepage = https://www.mamedev.org/;
    license = with licenses; [ bsd3 gpl2Plus ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ gnidorah ];
  };
}
