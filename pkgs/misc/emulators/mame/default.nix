{ stdenv, mkDerivation, fetchFromGitHub, makeDesktopItem
, python, pkgconfig, SDL2, SDL2_ttf, alsaLib, which, qtbase, libXinerama }:

let
  majorVersion = "0";
  minorVersion = "215";

  desktopItem = makeDesktopItem {
    name = "MAME";
    exec = "mame${stdenv.lib.optionalString stdenv.is64bit "64"}";
    desktopName = "MAME";
    genericName = "MAME is a multi-purpose emulation framework";
    categories = "System;Emulator;";
  };
in mkDerivation {
  pname = "mame";
  version = "${majorVersion}.${minorVersion}";

  src = fetchFromGitHub {
    owner = "mamedev";
    repo = "mame";
    rev = "mame${majorVersion}${minorVersion}";
    sha256 = "1phz846p3zzgzrbfiq2vn79iqar2dbf7iv6wfkrp32sdkkvp7l3h";
  };

  hardeningDisable = [ "fortify" ];
  NIX_CFLAGS_COMPILE = [ "-Wno-error=maybe-uninitialized" ];

  makeFlags = [ "TOOLS=1" ];

  buildInputs = [ SDL2 SDL2_ttf alsaLib qtbase libXinerama ];
  nativeBuildInputs = [ python pkgconfig which ];

  installPhase = ''
    dest=$out/opt/mame

    make -f dist.mak PTR64=${if stdenv.is64bit then "1" else "0"}
    mkdir -p $dest
    mv build/release/${if stdenv.is64bit then "x64" else "x32"}/Release/mame/* $dest

    mkdir -p $out/bin
    find $dest -maxdepth 1 -executable -type f -exec mv -t $out/bin {} \;

    mkdir -p $out/share/man/man{1,6}
    mv $dest/docs/man/*.1 $out/share/man/man1
    mv $dest/docs/man/*.6 $out/share/man/man6

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
