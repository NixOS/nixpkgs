{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, substituteAll
, cmake
, curl
, nasm
, unzip
, libgme
, libpng
, SDL2
, SDL2_mixer
, zlib
, p7zip
, makeWrapper
, makeDesktopItem
}:

let

  # Common info
  mainName = "srb2kart";
  version = "1.3";
  owner = "STJr";
  repo = "Kart-Public";
  fixVersion = builtins.replaceStrings ["."] [""] version;
  description = "SRB2Kart is a classic styled kart racer";

  # Normal assets found on the official release
  assets = stdenv.mkDerivation rec {
    pname = "${mainName}-data";
    inherit version;
    nativeBuildInputs = [ p7zip ];
    buildInputs = [ p7zip ];
    src = fetchurl {
      url = "https://github.com/${owner}/${repo}/releases/download/v${version}/srb2kart-v${fixVersion}-Installer.exe";
      sha256 = "0bk36y7wf6xfdg6j0b8qvk8671hagikzdp5nlfqg478zrj0qf6cs";
    };
    unpackPhase = ''
      7z -y x "''${src}"
    '';
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/share/srb2kart
      cp -r mdls/ *.kart *.dat *.pdf *.srb $out/share/srb2kart/
    '';
  };

in stdenv.mkDerivation rec {

  pname = mainName;
  inherit version;

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    sha256 = "131g9bmc9ihvz0klsc3yzd0pnkhx3mz1vzm8y7nrrsgdz5278y49";
  };

  nativeBuildInputs = [
    cmake
    nasm
    unzip
  ];

  buildInputs = [
    curl
    libgme
    libpng
    SDL2
    SDL2_mixer
    zlib
    makeWrapper
  ];

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${assets}/share/srb2kart"
    "-DGME_INCLUDE_DIR=${libgme}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${SDL2.dev}/include/SDL2"
  ];

  # Desktop icon
  desktopLink = makeDesktopItem rec {
    name = "Sonic Robo Blast 2 Kart";
    exec = mainName;
    icon = mainName;
    comment = description;
    desktopName = name;
    genericName = name;
    categories = [ "Game" ];
  };

  installPhase = ''
    mkdir -p $out/bin $out/share $out/share/applications $out/share/pixmaps $out/share/icons

    ln -s ${desktopLink}/share/applications/* $out/share/applications

    cp /build/source/srb2.png $out/share/pixmaps/srb2kart.png
    cp /build/source/srb2.png $out/share/icons/srb2kart.png

    cp bin/srb2kart-${version} $out/bin/srb2kart
    wrapProgram $out/bin/srb2kart --set SRB2WADDIR "${assets}/share/srb2kart"
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://mb.srb2.org/threads/srb2kart.25868/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
  };
}
