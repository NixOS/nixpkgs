{ stdenv, fetchurl, ncurses, flex, bison, autoconf, automake, m4, coreutils }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "zangband";
  version = "2.7.4b";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}-src/${version}/${name}.tar.gz";
    sha256 = "0kkz6f9myhjnr3308sdab8q186rd55lapvcp38w8qmakdbhc828j";
  };

  buildInputs = [
    ncurses flex bison autoconf automake m4
  ];

  preConfigure = ''
    sed -re 's/ch(own|grp|mod)/true/' -i lib/*/makefile.zb makefile.in
    sed -e '/FIXED_PATHS/d' -i src/z-config.h
    autoconf
  '';

  preInstall = ''
    mkdir -p $out/share/games/zangband
    mkdir -p $out/share/man
    mkdir -p $out/bin
  '';

  postInstall = ''
    mv $out/bin/zangband $out/bin/.zangband.real
    echo '#! ${stdenv.shell}
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
    description = "Rogue-like game";
    license = stdenv.lib.licenses.unfree;
    broken = true; # broken in runtime, will not get pass character generation
  };
}
