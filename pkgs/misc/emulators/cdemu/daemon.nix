{ callPackage, glib, libao }:
let pkg = import ./base.nix {
  version = "3.0.3";
  pkgName = "cdemu-daemon";
  pkgSha256 = "00gi3x03l019nyqfxkph1rsldd7fwg0r0x95spwv5py5wyiqvp3m";
};
in callPackage pkg {
  buildInputs = [ glib libao (callPackage ./libmirage.nix {}) ];
}
