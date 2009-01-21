a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "r8418" a; 
  buildInputs = with a; [
    gtk glib pkgconfig libX11 
  ];
in
rec {
  src = fetchurl {
    url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
    sha256 = "aca9f0e364d40d2ebb97287a2639d76a1bfa752fdd38d6598ead0f22f6cb585d";
  };

  inherit buildInputs;
  configureFlags = [];
  makeFlags = ["prefix=$out" "gamesdir=$out/bin"];

  neededDirs = ["$out/bin" "$out/share" ""];
  extraDoc = ["puzzles.txt"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["addInputs" "doExport" "doMakeInstall"];

  doExport = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${a.libX11}/lib -lX11"
  '';

  name = "sgt-puzzles-" + version;
  meta = {
    description = "Simon Tatham's portable puzzle collection";
  };
}
