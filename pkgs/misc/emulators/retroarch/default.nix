{ stdenv, fetchFromGitHub, makeDesktopItem, coreutils, which, pkgconfig
, ffmpeg, mesa, freetype, libxml2, python34
, enableNvidiaCgToolkit ? false, nvidia_cg_toolkit ? null
, alsaLib ? null, libv4l ? null
, udev ? null, libX11 ? null, libXext ? null, libXxf86vm ? null
, libXdmcp ? null, SDL ? null, libpulseaudio ? null
}:

with stdenv.lib;

let
  desktopItem = makeDesktopItem {
    name = "retroarch";
    exec = "retroarch";
    icon = "retroarch";
    comment = "Multi-Engine Platform";
    desktopName = "RetroArch";
    genericName = "Libretro Frontend";
    categories = "Game;Emulator;";
    #keywords = "multi;engine;emulator;xmb;";
  };
in

stdenv.mkDerivation rec {
  name = "retroarch-bare-${version}";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    sha256 = "1ym2kws58fbavkc3giz5xqaqiqqdbf7wrz7y7iw53p1bnkc3l8yi";
    rev = "v${version}";
  };

  buildInputs = [ pkgconfig ffmpeg mesa freetype libxml2 coreutils python34 which SDL ]
                ++ optional enableNvidiaCgToolkit nvidia_cg_toolkit
                ++ optionals stdenv.isLinux [ udev alsaLib libX11 libXext libXxf86vm libXdmcp libv4l libpulseaudio ];

  configureScript = "sh configure";

  patchPhase = ''
    export GLOBAL_CONFIG_DIR=$out/etc
    sed -e 's#/bin/true#${coreutils}/bin/true#' -i qb/qb.libs.sh
  '';

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp -p -T ./media/retroarch.svg $out/share/icons/hicolor/scalable/apps/retroarch.svg

    mkdir -p "$out/share/applications"
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://libretro.org/;
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ MP2E edwtjo matthewbauer ];
  };
}
