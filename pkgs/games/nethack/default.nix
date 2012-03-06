a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "3.4.3" a; 
  buildInputs = with a; [
    ncurses flex bison
  ];
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/nethack/nethack-343-src.tgz";
    sha256 = "1r3ghqj82j0bar62z3b0lx9hhx33pj7p1ppxr2hg8bgfm79c6fdv";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preBuild" "doMakeInstall" "postInstall"];
     
  preBuild = a.fullDepEntry (''
    ( cd sys/unix ; sh setup.sh )
    sed -e 's@.*define HACKDIR.*@\#define HACKDIR "/tmp/nethack"@' -i include/config.h
    sed -e '/define COMPRESS/d' -i include/config.h
    sed -e '1i\#define COMPRESS "/usr/local/bin/gzip"' -i include/config.h
    sed -e '1i\#define COMPRESS_EXTENSION ".gz"' -i include/config.h

    sed -e '/extern char [*]tparm/d' -i win/tty/*.c
    sed -e 's/-ltermlib/-lncurses/' -i src/Makefile
    sed -e 's/^YACC *=.*/YACC = bison -y/' -i util/Makefile
    sed -e 's/^LEX *=.*/LEX = flex/' -i util/Makefile

    sed -e 's@GAMEDIR = @GAMEDIR = /tmp/nethack@' -i Makefile
    sed -re 's@^(CH...).*@\1 = true@' -i Makefile
  '') ["minInit" "doUnpack"];

  postInstall = a.fullDepEntry (''
    mkdir -p $out/bin
    ln -s $out/games/nethack $out/bin/nethack
    sed -i $out/bin/nethack -e '5aNEWHACKDIR="$HOME/.nethack"'
    sed -i $out/bin/nethack -e '6amkdir -p "$NEWHACKDIR/save"'
    sed -i $out/bin/nethack -e '7afor i in $(find "$NEWHACKDIR" -type l); do if ! test -e $(readlink "$i"); then rm "$i"; fi; done;'
    sed -i $out/bin/nethack -e '8aln -s "$HACKDIR"/* "$NEWHACKDIR" &>/dev/null'
    sed -i $out/bin/nethack -e '9atest -L "$NEWHACKDIR/record" && rm "$NEWHACKDIR"/record'
    sed -i $out/bin/nethack -e '10aexport HACKDIR="$NEWHACKDIR"'
  '') ["minInit" "defEnsureDir"];

  makeFlags = [
      "PREFIX=$out"
    ];

  name = "nethack-" + version;
  meta = {
    description = "rogue-like game";
  };
}
