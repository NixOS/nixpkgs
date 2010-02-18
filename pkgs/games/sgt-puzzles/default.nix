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
   rev = "8872";
   sha256 = "16hcrhkl6plzdhw60g7i4vgkxcc4mw4h4bzg2myy5cfhpx7y0m9s";
  } + "/";

  inherit buildInputs;
  configureFlags = [];
  makeFlags = ["prefix=$out" "gamesdir=$out/bin"];

  neededDirs = ["$out/bin" "$out/share" ""];
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
