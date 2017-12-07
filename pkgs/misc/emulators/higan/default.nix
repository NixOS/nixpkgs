{ stdenv, fetchurl
, p7zip, pkgconfig
, libX11, libXv
, udev
, mesa, SDL
, libao, openal, libpulseaudio
, gtk2, gtksourceview }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "higan-${version}";
  version = "103";
  sourceName = "higan_v${version}-source";

  src = fetchurl {
    urls = [ "http://download.byuu.org/${sourceName}.7z" ];
    sha256 = "0xj2k5g1zyl71hk3kwaixk1axbi6s9kqq31c702rl7qkljv6lfp6";
    curlOpts = "--user-agent 'Mozilla/5.0'"; # the good old user-agent trick...
  };

  patches = [ ./0001-change-flags.diff ];
  postPatch = "sed '1i#include <cmath>' -i higan/fc/ppu/ppu.cpp";

  buildInputs =
  [ p7zip pkgconfig libX11 libXv udev mesa SDL libao openal libpulseaudio gtk2 gtksourceview ];

  unpackPhase = ''
    7z x $src
    sourceRoot=${sourceName}
  '';

  buildPhase = ''
    make compiler=c++ -C icarus
    make compiler=c++ -C higan
  '';

  # Now the cheats file will be distributed separately
  installPhase = ''
    install -dm 755 $out/bin $out/share/applications $out/share/higan $out/share/pixmaps
    install -m 755 icarus/out/icarus $out/bin/
    install -m 755 higan/out/higan $out/bin/
    install -m 644 higan/data/higan.desktop $out/share/applications/
    install -m 644 higan/data/higan.png $out/share/pixmaps/higan-icon.png
    install -m 644 higan/resource/logo/higan.png $out/share/pixmaps/higan-logo.png
    cp --recursive --no-dereference --preserve='links' --no-preserve='ownership' \
      higan/systems/* $out/share/higan/
  '';

  fixupPhase = ''
    # A dirty workaround, suggested by @cpages:
    # we create a first-run script to populate
    # the local $HOME with all the auxiliary
    # stuff needed by higan at runtime

    cat <<EOF > $out/bin/higan-init.sh
    #!${stdenv.shell}

    cp --recursive --update $out/share/higan/*.sys \$HOME/.local/share/higan/

    EOF

    chmod +x $out/bin/higan-init.sh
  '';

  meta = {
    description = "An open-source, cycle-accurate Nintendo multi-system emulator";
    longDescription = ''
      Higan (formerly bsnes) is a multi-system game console emulator.
      It currently supports the following systems:
        - Nintendo's Famicom, Super Famicom (with subsystems: 
          Super Game Boy, BS-X Satellaview, Sufami Turbo); 
          Game Boy, Game Boy Color, Game Boy Advance;
        - Sega's Master System, Game Gear, Mega Drive;
        - NEC's PC Engine, SuperGrafx;
        - Bandai' WonderSwan, WonderSwan Color.
    '';
    homepage = https://byuu.org/higan/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}

#
# TODO:
#   - fix the BML and BIOS paths - maybe submitting
#     a custom patch to upstream would not be a bad idea...
