{ stdenv, fetchurl
, pkgconfig
, libX11, libXv
, udev
, mesa, SDL
, libao, openal, pulseaudio
, profile ? "accuracy" # Options: accuracy, balanced, performance
, gui ? "gtk" # can be gtk or qt4
, gtk ? null, qt4 ? null }:

assert gui == "gtk" || gui == "qt4";
assert (gui == "gtk" -> gtk != null) || (gui == "qt4" -> qt4 != null);

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
  [ pkgconfig libX11 libXv udev mesa SDL libao openal pulseaudio ]
  ++ optionals (gui == "gtk") [ gtk ]
  ++ optionals (gui == "qt4") [ qt4 ];

  buildPhase = ''
    make phoenix=${gui} profile=${profile} -C ananke
    make phoenix=${gui} profile=${profile}
  '';

  installPhase = ''
    install -dm 755 $out/share/applications $out/share/pixmaps $out/share/higan/Video\ Shaders $out/bin $out/lib

    install -m 644 data/higan.desktop $out/share/applications/
    install -m 644 data/higan.png $out/share/pixmaps/
    cp -dr --no-preserve=ownership profile/* data/cheats.bml $out/share/higan/
    cp -dr --no-preserve=ownership shaders/*.shader $out/share/higan/Video\ Shaders/

    install -m 755 out/higan $out/bin/higan
    install -m 644 ananke/libananke.so $out/lib/libananke.so.1
    (cd $out/lib && ln -s libananke.so.1 libananke.so)
  '';

  fixupPhase = ''
    oldRPath=$(patchelf --print-rpath $out/bin/higan)
    patchelf --set-rpath $oldRPath:$out/lib $out/bin/higan

    # A dirty workaround, suggested by @cpages:
    # we create a first-run script to populate
    # the local $HOME with all the auxiliary
    # stuff needed by higan at runtime

    cat <<EOF > $out/bin/higan-init.sh
    #!${stdenv.shell}

    cp --update --recursive $out/share/higan \$HOME/.config
    chmod --recursive u+w \$HOME/.config/higan
    EOF

    chmod +x $out/bin/higan-init.sh
  '';

  meta = with stdenv.lib; {
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
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

#
# TODO:
#   - fix the BML and BIOS paths - maybe submitting
#     a custom patch to Higan project would not be a bad idea...
#   - config.higan.{gui,profile} options
#
