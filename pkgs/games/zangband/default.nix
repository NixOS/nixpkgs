a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "2.7.3" a; 
  buildInputs = with a; [
    ncurses flex bison autoconf automake m4
  ];
in
rec {
  src = fetchurl {
    url = "ftp://ftp.sunet.se/pub/games/Angband/Variant/ZAngband/zangband-${version}.tar.gz";
    sha256 = "0654m8fzklsc8565sqdad76mxjsm1z9c280srq8863sd10af0bdq";
  };

  inherit buildInputs;
  configureFlags = [];

  preConfigure = a.FullDepEntry (''
    chmod a+rwX -R . 
    sed -re 's/ch(own|grp|mod)/true/' -i lib/*/makefile.zb makefile.in
    sed -e '/FIXED_PATHS/d' -i src/z-config.h
    ./bootstrap
    ensureDir $out/share/games/zangband
    ensureDir $out/share/man
    ensureDir $out/bin
  '') ["minInit" "doUnpack" "addInputs" "defEnsureDir"];

  postInstall = a.FullDepEntry (''
    mv $out/bin/zangband $out/bin/.zangband.real
    echo '#! /bin/sh
      PATH="$PATH:${a.stdenv.coreutils}/bin"

      ZANGBAND_PATH="$HOME/.zangband"
      ORIG_PATH="'$out'"/share/games/zangband
      mkdir -p "$ZANGBAND_PATH"
      cd "$ZANGBAND_PATH"
      for i in $(find "$ORIG_PATH" -type f); do
        REL_PATH="''${i#$ORIG_PATH/}"
	mkdir -p "$(dirname "$REL_PATH")"
	ln -s "$i" "$REL_PATH" &>/dev/null
      done
      mkdir lib/user
      for i in lib/*/*.raw; do
        test -L "$i" && rm "$i"; 
      done
      export ANGBAND_PATH="$PWD"
      "'$out'/bin/.zangband.real" "$@"
    ' > $out/bin/zangband
    chmod +x $out/bin/zangband
  '') ["minInit" "doUnpack"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall" "postInstall"];
      
  name = "zangband-" + version;
  meta = {
    description = "rogue-like game";
    license = "non-free"; # Basically "not for commercial profit"
  };
}
