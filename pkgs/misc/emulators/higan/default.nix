{ stdenv, fetchurl
, p7zip, pkgconfig
, libX11, libXv
, udev
, mesa, SDL
, libao, openal, libpulseaudio
, gtk, gtksourceview
}:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "higan-${version}";
  version = "098";
  sourceName = "higan_v${version}-source";

  src = fetchurl {
    urls = [ "http://download.byuu.org/${sourceName}.7z" ];
    sha256 = "0qphvjfv17dbmzgb4pny2q6ln0lsgzyhalq6qyqxc3qwm4fzdjv1";
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
    make compiler=c++ -C icarus
    make compiler=c++ -C higan
  '';

  installPhase = ''
    install -dm 755 $out/bin $out/share/applications $out/share/higan $out/share/pixmaps
    install -m 755 icarus/out/icarus $out/bin/
    install -m 755 higan/out/higan $out/bin/
    install -m 644 higan/data/higan.desktop $out/share/applications/
    install -m 644 higan/data/higan.png $out/share/pixmaps/
    cp --recursive --no-dereference --preserve='links' --no-preserve='ownership' higan/data/cheats.bml higan/profile/* $out/share/higan/
  '';

  fixupPhase = ''
    # A dirty workaround, suggested by @cpages:
    # we create a first-run script to populate
    # the local $HOME with all the auxiliary
    # stuff needed by higan at runtime

    cat <<EOF > $out/bin/higan-init.sh
    #!${stdenv.shell}

    cp --update $out/share/higan/cheats.bml \$HOME/.config/
    cp --recursive --update $out/share/higan/*.sys \$HOME/.local/share/higan/

    EOF

    chmod +x $out/bin/higan-init.sh
  '';

  meta = {
    description = "An open-source, cycle-accurate Nintendo multi-system emulator";
    longDescription = ''
      Higan (formerly bsnes) is a Nintendo multi-system emulator.
      It currently supports the following systems:
        Famicom; Super Famicom;
        Game Boy; Game Boy Color; Game Boy Advance
        WonderSwan; WonderSwan Color
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
#     a custom patch to upstream would not be a bad idea...
