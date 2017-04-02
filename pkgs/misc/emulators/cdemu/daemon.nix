{ callPackage, glib, libao }:
let pkg = import ./base.nix {
  version = "3.0.5";
  pkgName = "cdemu-daemon";
  pkgSha256 = "1cc0yxf1y5dxinv7md1cqhdjsbqb69v9jygrdq5c20mrkqaajz1i";
};
in callPackage pkg {
  buildInputs = [ glib libao (callPackage ./libmirage.nix {}) ];
}
