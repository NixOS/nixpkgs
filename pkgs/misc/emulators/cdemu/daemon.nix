{ callPackage, glib, libao }:
let pkg = import ./base.nix {
  version = "3.0.2";
  pkgName = "cdemu-daemon";
  pkgSha256 = "01jg9b1nkqrbh6binfcbyraz83s9yjavgwi3y4w1bmqg5qlhv6lc";
};
in callPackage pkg {
  buildInputs = [ glib libao (callPackage ./libmirage.nix {}) ];
}
