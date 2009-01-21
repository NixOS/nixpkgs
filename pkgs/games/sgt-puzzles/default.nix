a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "r8419" a; 
  buildInputs = with a; [
    gtk glib pkgconfig libX11 
  ];
in
rec {
  src = fetchurl {
    url = "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${version}.tar.gz";
    sha256 = "0lm6d34i9g8krwvchqkq433gmpy4d7c4423h8855rvd3jxga82qa";
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
