a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "r8541" a; 
  buildInputs = with a; [
    gtk glib pkgconfig libX11 
  ];
in
rec {
  src = fetchurl {
    url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
    sha256 = "1m6fybbvlx33786hmgraqxgm1hakfj9bqqszzzpi2ka4spfzj3xl";
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
