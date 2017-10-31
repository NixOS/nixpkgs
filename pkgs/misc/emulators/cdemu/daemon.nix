{ callPackage, glib, libao, intltool }:
let pkg = import ./base.nix {
  version = "3.1.0";
  pkgName = "cdemu-daemon";
  pkgSha256 = "0kxwhwjvcr40sjlrvln9gasjwkkfc3wxpcz0rxmffp92w8phz3s9";
};
in callPackage pkg {
  buildInputs = [ glib libao (callPackage ./libmirage.nix {}) intltool ];
}
