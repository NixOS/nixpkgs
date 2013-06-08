a :  
let 
  fetchsvn = a.fetchsvn;

  version = a.lib.attrByPath ["version"] "r8541" a;
  buildInputs = with a; [
    gtk pkgconfig libX11 perl
  ];
in
rec {
  src = fetchsvn {
   url = svn://svn.tartarus.org/sgt/puzzles;
   rev = "9689";
   sha256 = "33285a971fee67324f8867de22582931135d8b8ee4cc2c41c46c3ba81eb99cb7";
  } + "/";

  inherit buildInputs;
  configureFlags = [];
  makeFlags = ["prefix=$out" "gamesdir=$out/bin"];

  neededDirs = ["$out/bin" "$out/share"];
  extraDoc = ["puzzles.txt"];

  mkMakefiles = a.fullDepEntry ''
    perl mkfiles.pl
  '' ["minInit" "doUnpack" "addInputs"];

  setVars = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lX11"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error=variadic-macros"
  '';

  /* doConfigure should be removed if not needed */
  phaseNames = ["addInputs" "setVars" "mkMakefiles" "doMakeInstall"];

  name = "sgt-puzzles-" + version;
  meta = {
    description = "Simon Tatham's portable puzzle collection";
  };
}
