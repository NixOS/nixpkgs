{ stdenv, fetchurl
, pkgconfig
, libX11, libXv
, udev
, mesa, gtk, SDL
, libao, openal, pulseaudio
}:

stdenv.mkDerivation rec {

  name = "higan-${version}";
  version = "094";
  sourceName = "higan_v${version}-source";

  src = fetchurl {
    url = "http://byuu.org/files/${sourceName}.tar.xz";
    sha256 = "06qm271pzf3qf2labfw2lx6k0xcd89jndmn0jzmnc40cspwrs52y";
    curlOpts = "--user-agent 'Mozilla/5.0'"; # the good old user-agent trick...
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig libX11 libXv udev mesa gtk SDL libao openal pulseaudio ];

  builder = ./builder.sh;

  meta = {
    description = "An open-source, cycle-accurate Nintendo multi-system emulator";
    longDescription = ''
      Higan (formerly bsnes) is a Nintendo multi-system emulator.
      It currently supports the following systems:
        Famicom; Super Famicom;
        Game Boy; Game Boy Color; Game Boy Advance
      higan also supports the following subsystems:
        Super Game Boy; BS-X Satellaview; Sufami Turbo
    '';
    homepage = http://byuu.org/higan/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}

#
# TODO:
#   - options to choose profiles (accuracy, balanced, performance)
#     and different GUIs (gtk2, qt4)
#   - fix the BML and BIOS paths - maybe a custom patch to Higan project?
#
