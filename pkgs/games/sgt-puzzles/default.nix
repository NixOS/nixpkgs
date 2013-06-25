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
   rev = "9773";
   sha256 = "1m0mmxbcj0zi44dlmhk4h30d9hdy8g9f59r7k7906pgnnyf49611";
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
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error"
  '';

  /* doConfigure should be removed if not needed */
  phaseNames = ["addInputs" "setVars" "mkMakefiles" "doMakeInstall"];

  name = "sgt-puzzles-" + version;
  meta = {
    description = "Simon Tatham's portable puzzle collection";
  };
}
