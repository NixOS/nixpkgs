{ lib, stdenv, fetchFromGitHub
, pkg-config
, libX11, libXv
, udev
, libGLU, libGL, SDL2
, libao, openal, libpulseaudio
, alsa-lib
, gtk2, gtksourceview
, runtimeShell
# Darwin dependencies
, libicns, Carbon, Cocoa, OpenGL, OpenAL}:

let
  inherit (lib) optionals;
in
stdenv.mkDerivation rec {

  pname = "higan";
  version = "110";

  src = fetchFromGitHub {
    owner = "higan-emu";
    repo = "higan";
    rev = "v${version}";
    sha256 = "11rvm53c3p2f6zk8xbyv2j51xp8zmqnch7zravhj3fk590qrjrr2";
  };

  patches = [ ./0001-change-flags.diff ];
  postPatch = ''
    sed '1i#include <cmath>' -i higan/fc/ppu/ppu.cpp

    for file in icarus/GNUmakefile higan/target-higan/GNUmakefile; do
      substituteInPlace "$file" \
        --replace 'sips -s format icns data/$(name).png --out out/$(name).app/Contents/Resources/$(name).icns' \
                  'png2icns out/$(name).app/Contents/Resources/$(name).icns data/$(name).png'
    done
  '';

  nativeBuildInputs = [ pkg-config ]
    ++ optionals stdenv.isDarwin [ libicns ];

  buildInputs = [ SDL2 libao ]
                ++ optionals stdenv.isLinux [ alsa-lib udev libpulseaudio openal
                                              gtk2 gtksourceview libX11 libXv
                                              libGLU libGL ]
                ++ optionals stdenv.isDarwin [ Carbon Cocoa OpenGL OpenAL ];

  buildPhase = ''
    make compiler=c++ -C higan openmp=true target=higan
    make compiler=c++ -C genius openmp=true
    make compiler=c++ -C icarus openmp=true
  '';

  installPhase = (if stdenv.isDarwin then ''
    mkdir "$out"
    mv higan/out/higan.app "$out"/
    mv icarus/out/icarus.app "$out"/
    mv genius/out/genius.app "$out"/
  '' else ''
    install -dm 755 "$out"/bin "$out"/share/applications "$out"/share/pixmaps

    install -m 755 higan/out/higan -t "$out"/bin/
    install -m 644 higan/target-higan/resource/higan.desktop \
            -t $out/share/applications/
    install -m 644 higan/target-higan/resource/higan.svg \
            $out/share/pixmaps/higan-icon.svg
    install -m 644 higan/target-higan/resource/higan.png \
            $out/share/pixmaps/higan-icon.png

    install -m 755 icarus/out/icarus -t "$out"/bin/
    install -m 644 icarus/data/icarus.desktop -t $out/share/applications/
    install -m 644 icarus/data/icarus.svg $out/share/pixmaps/icarus-icon.svg
    install -m 644 icarus/data/icarus.png $out/share/pixmaps/icarus-icon.png

    install -m 755 genius/out/genius -t "$out"/bin/
    install -m 644 genius/data/genius.desktop -t $out/share/applications/
    install -m 644 genius/data/genius.svg $out/share/pixmaps/genius-icon.svg
    install -m 644 genius/data/genius.png $out/share/pixmaps/genius-icon.png
  '') + ''
    mkdir -p "$out"/share/higan "$out"/share/icarus
    cp --recursive --no-dereference --preserve='links' --no-preserve='ownership' \
      higan/System/ "$out"/share/higan/
    cp --recursive --no-dereference --preserve='links' --no-preserve='ownership' \
      icarus/Database icarus/Firmware $out/share/icarus/
  '';

  fixupPhase = let
    dest = if stdenv.isDarwin
           then "\\$HOME/Library/Application Support/higan"
           else "\\$HOME/higan";
  in ''
    # A dirty workaround, suggested by @cpages:
    # we create a first-run script to populate
    # $HOME with all the stuff needed at runtime

    mkdir -p "$out"/bin
    cat <<EOF > $out/bin/higan-init.sh
    #!${runtimeShell}

    cp --recursive --update $out/share/higan/System/ "${dest}"/

    EOF

    chmod +x $out/bin/higan-init.sh
  '';

  meta = with lib; {
    description = "An open-source, cycle-accurate multi-system emulator";
    longDescription = ''
      higan is a multi-system game console emulator. The purpose of higan is to
      serve as hardware documentation in source code form: it is meant to be as
      accurate and complete as possible, with code that is easy to read and
      understand.

      It currently supports the following systems:
      - Famicom + Famicom Disk System
      - Super Famicom + Super Game Boy
      - Game Boy + Game Boy Color
      - Game Boy Advance + Game Boy Player
      - SG-1000 + SC-3000
      - Master System + Game Gear
      - Mega Drive + Mega CD
      - PC Engine + SuperGrafx
      - MSX + MSX2
      - ColecoVision
      - Neo Geo Pocket + Neo Geo Pocket Color
      - WonderSwan + WonderSwan Color + SwanCrystal + Pocket Challenge V2
    '';
    homepage = "https://byuu.org/higan/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: Qt and GTK3+ support
