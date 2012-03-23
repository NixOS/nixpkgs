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
   rev = "9437";
   sha256 = "4820ce1e54e017a64dd9cb8991c020d0628329605a37af2a99b78bffbde43e85";
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
  '';

  /* doConfigure should be removed if not needed */
  phaseNames = ["addInputs" "setVars" "mkMakefiles" "doMakeInstall"];

  name = "sgt-puzzles-" + version;
  meta = {
    description = "Simon Tatham's portable puzzle collection";
  };
}
