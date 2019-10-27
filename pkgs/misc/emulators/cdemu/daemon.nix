{ callPackage, glib, libao, intltool, libmirage }:
let pkg = import ./base.nix {
  version = "3.2.2";
  pkgName = "cdemu-daemon";
  pkgSha256 = "0himyrhhfjsr4ff5aci7240bpm9x34h20pid412ci8fm16nk929b";
};
in callPackage pkg {
  buildInputs = [ glib libao libmirage intltool ];
}
