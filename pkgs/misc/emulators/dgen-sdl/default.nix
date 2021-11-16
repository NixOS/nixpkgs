{ lib, stdenv
, fetchurl
, libarchive
, SDL
}:

let
  pname = "dgen-sdl";
  version = "1.33";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://sourceforge.net/projects/dgen/files/dgen/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-meLAYBfCKHPHf4gYbrzAmGckTrbgQsdjuwlLArje9h4=";
  };

  buildInputs = [ SDL libarchive ];

  configureFlags = [
    "--enable-joystick"
    "--enable-debugger"
    "--enable-debug-vdp"
    "--enable-pico" # experimental
    "--enable-vgmdump"
    "--with-star=no" # Needs ASM support
    "--with-musa"
    "--with-cyclone=no" # Needs ASM support
    "--with-mz80"
    "--with-cz80"
    "--with-drz80=no" # Needs ASM support
    "--with-dz80"
  ];

  meta = with lib; {
    homepage = "https://dgen.sourceforge.net/";
    description = "Sega Genesis/Mega Drive emulator";
    longDescription = ''
      DGen/SDL is a free, open source emulator for Sega Genesis/Mega Drive
      systems. DGen was originally written by Dave, then ported to SDL by Joe
      Groff and Phil K. Hornung in 1998.

      It features:

      - Game Genie/Hex codes support
      - PAL/NTSC, fullscreen modes
      - Joypad/joystick support
      - Mouse support
      - Highly configurable controls
      - OpenGL textured video output
      - Portable (64‐bit, endian safe), runs in Windows using MinGW
      - Screenshots, demos recording and playback
      - Musashi (generic) and StarScream (x86‐only) CPU cores
      - Cyclone 68000 and DrZ80 (both ARM‐only) CPU cores
      - CZ80 (generic) and MZ80 (generic and x86‐only versions)
      - 16‐bit, 8000 to 48000Hz sound output
      - Support for 8, 15, 16, 24 and 32 bpp modes
      - Archived/compressed ROMs support
      - M68K debugger (contributed by Edd Barrett)
      - Z80 debugger
      - hqx and scale2x upscaling filters
      - VGM dumping
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
# TODO: implement configure options
