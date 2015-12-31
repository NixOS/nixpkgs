{ stdenv, fetchurl
, p7zip, pkgconfig
, libX11, libXv
, udev
, mesa, SDL
, libao, openal, libpulseaudio
, gtk, gtksourceview
, profile ? "balanced" # Options: accuracy, balanced, performance
}:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "higan-${meta.version}";
  sourceName = "higan_v${meta.version}-source";

  src = fetchurl {
    urls = [ "http://download.byuu.org/${sourceName}.7z" ];
    sha256 = "0yc5gwg6dq9iwi2qk3g66wn8j2l55nhdb0311jzmdsh86zcrpvqh";
    curlOpts = "--user-agent 'Mozilla/5.0'"; # the good old user-agent trick...
  };

  patches = [ ./0001-change-flags.diff ];

  buildInputs =
  [ p7zip pkgconfig libX11 libXv udev mesa SDL libao openal libpulseaudio gtk gtksourceview ];

  unpackPhase = ''
    7z x $src
    sourceRoot=${sourceName}
  '';

  buildPhase = ''
    make compiler=c++ profile=${profile} -C icarus
    make compiler=c++ profile=${profile}
  '';

  installPhase = ''
    install -dm 755 $out/bin $out/share/applications $out/share/higan $out/share/pixmaps
    install -m 755 icarus/icarus $out/bin/
    install -m 755 out/tomoko $out/bin/
    (cd $out/bin; ln -Ts tomoko higan) #backwards compatibility
    install -m 644 data/higan.desktop $out/share/applications/
    install -m 644 data/higan.png $out/share/pixmaps/
    cp -dr --no-preserve='ownership' profile/* data/cheats.bml $out/share/higan/
  '';

  fixupPhase = ''
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

  meta = {
    version = "096";
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
#   - Qt support
