{ stdenv, fetchurl, ncurses, flex, bison, autoconf, automake, m4, coreutils }:

stdenv.mkDerivation rec {
  name = "zangband-${version}";
  version = "2.7.3";

  src = fetchurl {
    url = "ftp://ftp.sunet.se/pub/games/Angband/Variant/ZAngband/zangband-${version}.tar.gz";
    sha256 = "0654m8fzklsc8565sqdad76mxjsm1z9c280srq8863sd10af0bdq";
  };

  buildInputs = [
    ncurses flex bison autoconf automake m4
  ];

  # fails during chmod due to broken permissions
  dontMakeSourcesWritable = true;
  postUnpack = ''
    chmod a+rwX -R .
  '';

  preConfigure = ''
    sed -re 's/ch(own|grp|mod)/true/' -i lib/*/makefile.zb makefile.in
    sed -e '/FIXED_PATHS/d' -i src/z-config.h
    ./bootstrap
  '';

  preInstall = ''
    mkdir -p $out/share/games/zangband
    mkdir -p $out/share/man
    mkdir -p $out/bin
  '';

  postInstall = ''
    mv $out/bin/zangband $out/bin/.zangband.real
    echo '#! /bin/sh
      PATH="$PATH:${coreutils}/bin"

      ZANGBAND_PATH="$HOME/.zangband"
      ORIG_PATH="'$out'"/share/games/zangband
      mkdir -p "$ZANGBAND_PATH"
      cd "$ZANGBAND_PATH"
      for i in $(find "$ORIG_PATH" -type f); do
        REL_PATH="''${i#$ORIG_PATH/}"
	mkdir -p "$(dirname "$REL_PATH")"
	ln -s "$i" "$REL_PATH" &>/dev/null
      done
      mkdir -p lib/user lib/save
      for i in lib/*/*.raw; do
        test -L "$i" && rm "$i";
      done
      for i in $(find lib -type l); do if ! test -e $(readlink "$i"); then rm "$i"; fi; done;
      export ANGBAND_PATH="$PWD"
      "'$out'/bin/.zangband.real" "$@"
    ' > $out/bin/zangband
    chmod +x $out/bin/zangband
  '';

  meta = {
    description = "rogue-like game";
    license = stdenv.lib.licenses.unfree;
  };
}
