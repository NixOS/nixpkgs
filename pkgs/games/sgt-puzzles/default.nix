a :  
let 
  fetchsvn = a.fetchsvn;

  version = a.lib.attrByPath ["version"] "r8541" a; 
  buildInputs = with a; [
    gtk glib pkgconfig libX11 perl
  ];
in
rec {
  src = fetchsvn {
   url = svn://svn.tartarus.org/sgt/puzzles;
   rev = "8842";
   sha256 = "0rx3pxd1ci9x1mlw1jfmwd0fpcyv76vv6jraxfrxcykxx62qg479";
  } + "/";

  inherit buildInputs;
  configureFlags = [];
  makeFlags = ["prefix=$out" "gamesdir=$out/bin"];

  neededDirs = ["$out/bin" "$out/share" ""];
  extraDoc = ["puzzles.txt"];

  mkMakefiles = a.fullDepEntry ''
    perl mkfiles.pl
  '' ["minInit" "doUnpack" "addInputs"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["addInputs" "doExport" "mkMakefiles" "doMakeInstall"];

  doExport = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${a.libX11}/lib -lX11"
  '';

  name = "sgt-puzzles-" + version;
  meta = {
    description = "Simon Tatham's portable puzzle collection";
  };
}
