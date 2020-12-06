{ callPackage, glib, libao, intltool, libmirage }:
let pkg = import ./base.nix {
  version = "3.2.3";
  pkgName = "cdemu-daemon";
  pkgSha256 = "022xzgwmncswb9md71w3ly3mjkdfc93lbij2llp2jamq8grxjjxr";
};
in callPackage pkg {
  buildInputs = [ glib libao libmirage intltool ];
}
