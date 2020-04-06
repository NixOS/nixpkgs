{ stdenv, fetchurl
, p7zip, pkgconfig, libicns
, libX11, libXv
, udev
, libGLU, libGL, SDL
, Carbon, Cocoa, OpenGL, OpenAL
, libao, openal, libpulseaudio
, gtk2, gtksourceview
, runtimeShell }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "higan";
  version = "106";
  sourceName = "higan_v${version}-source";

  src = fetchurl {
    urls = [ "https://download.byuu.org/${sourceName}.7z" ];
    sha256 = "063dzp9wrdnbvagraxi31xg0154y2gf67rrd0mnc8h104cgzjr35";
    curlOpts = "--user-agent 'Mozilla/5.0'"; # the good old user-agent trick...
  };

  patches = [ ./0001-change-flags.diff ];
  postPatch = ''
    sed '1i#include <cmath>' -i higan/fc/ppu/ppu.cpp

    for file in icarus/GNUmakefile higan/target-tomoko/GNUmakefile; do
      substituteInPlace "$file" \
        --replace 'sips -s format icns data/$(name).png --out out/$(name).app/Contents/Resources/$(name).icns' \
                  'png2icns out/$(name).app/Contents/Resources/$(name).icns data/$(name).png'
    done
  '';

  nativeBuildInputs = [ p7zip pkgconfig ]
    ++ optional stdenv.isDarwin [ libicns ];

  buildInputs =
    [ SDL libao ]
    ++ optionals stdenv.isLinux [ openal libpulseaudio udev libX11 libXv libGLU libGL gtk2 gtksourceview ]
    ++ optionals stdenv.isDarwin [ Carbon Cocoa OpenGL OpenAL ]
    ;

  unpackPhase = ''
    7z x $src
    sourceRoot=${sourceName}
  '';

  buildPhase = ''
    make compiler=c++ -C icarus
    make compiler=c++ -C higan
  '';

  # Now the cheats file will be distributed separately
  installPhase = (if !stdenv.isDarwin then ''
    mkdir -p "$out"/bin "$out"/share/applications "$out"/share/pixmaps
    install -m 755 icarus/out/icarus "$out"/bin/
    install -m 755 higan/out/higan "$out"/bin/
    install -m 644 higan/data/higan.desktop "$out"/share/applications/
    install -m 644 higan/data/higan.png "$out"/share/pixmaps/higan-icon.png
    install -m 644 higan/resource/logo/higan.png "$out"/share/pixmaps/higan-logo.png
  '' else ''
    mkdir "$out"
    mv higan/out/higan.app "$out"/
    mv icarus/out/icarus.app "$out"/
  '') + ''
    mkdir -p  "$out"/share/higan
    cp --recursive --no-dereference --preserve='links' --no-preserve='ownership' \
      higan/systems/* "$out"/share/higan/
  '';

  fixupPhase = let
    dest = if !stdenv.isDarwin then "\\$HOME/.local/share/higan" else "\\$HOME/Library/Application Support/higan";
  in ''
    # A dirty workaround, suggested by @cpages:
    # we create a first-run script to populate
    # the local $HOME with all the auxiliary
    # stuff needed by higan at runtime

    mkdir -p "$out"/bin
    cat <<EOF > $out/bin/higan-init.sh
    #!${runtimeShell}

    cp --recursive --update $out/share/higan/*.sys "${dest}"/

    EOF

    chmod +x $out/bin/higan-init.sh
  '';

  meta = {
    description = "An open-source, cycle-accurate Nintendo multi-system emulator";
    longDescription = ''
      higan (formerly bsnes) is a multi-system game console emulator.
      It currently supports the following systems:
        - Nintendo's Famicom, Super Famicom (with subsystems:
          Super Game Boy, BS-X Satellaview, Sufami Turbo);
          Game Boy, Game Boy Color, Game Boy Advance;
        - Sega's Master System, Game Gear, Mega Drive;
        - NEC's PC Engine, SuperGrafx;
        - Bandai's WonderSwan, WonderSwan Color.
    '';
    homepage = https://byuu.org/emulation/higan/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
