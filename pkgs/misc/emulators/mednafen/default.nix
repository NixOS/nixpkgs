{ stdenv, fetchurl, pkgconfig, freeglut, libGLU, libGL, libcdio, libjack2
, libsamplerate, libsndfile, libX11, SDL2, SDL2_net, zlib, alsaLib }:

stdenv.mkDerivation rec {
  pname = "mednafen";
  version = "1.26.1";

  src = fetchurl {
    url = "https://mednafen.github.io/releases/files/${pname}-${version}.tar.xz";
    sha256 = "1x7xhxjhwsdbak8l0iyb497f043xkhibk73w96xck4j2bk10fac4";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    freeglut
    libGLU libGL
    libcdio
    libjack2
    alsaLib
    libsamplerate
    libsndfile
    libX11
    SDL2
    SDL2_net
    zlib
  ];

  hardeningDisable = [ "pic" ];

  postInstall = ''
    mkdir -p $out/share/doc
    mv Documentation $out/share/doc/mednafen
  '';

  meta = with stdenv.lib; {
    description = "A portable, CLI-driven, SDL+OpenGL-based, multi-system emulator";
    longDescription = ''
      Mednafen is a portable, utilizing OpenGL and SDL,
      argument(command-line)-driven multi-system emulator. Mednafen has the
      ability to remap hotkey functions and virtual system inputs to a keyboard,
      a joystick, or both simultaneously. Save states are supported, as is
      real-time game rewinding. Screen snapshots may be taken, in the PNG file
      format, at the press of a button. Mednafen can record audiovisual movies
      in the QuickTime file format, with several different lossless codecs
      supported.

      The following systems are supported (refer to the emulation module
      documentation for more details):

      - Apple II/II+
      - Atari Lynx
      - Neo Geo Pocket (Color)
      - WonderSwan
      - GameBoy (Color)
      - GameBoy Advance
      - Nintendo Entertainment System
      - Super Nintendo Entertainment System/Super Famicom
      - Virtual Boy
      - PC Engine/TurboGrafx 16 (CD)
      - SuperGrafx
      - PC-FX
      - Sega Game Gear
      - Sega Genesis/Megadrive
      - Sega Master System
      - Sega Saturn (experimental, x86_64 only)
      - Sony PlayStation
    '';
    homepage = "https://mednafen.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
