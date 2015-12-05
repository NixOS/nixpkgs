{ callPackage, glib, libsndfile, zlib, bzip2, lzma, libsamplerate }:
let pkg = import ./base.nix {
  version = "3.0.4";
  pkgName = "libmirage";
  pkgSha256 = "0grzdacl8hlj20amq88r98h8pd039ww0g4hl1a8lhly11h7kf1fc";
};
in callPackage pkg {
  buildInputs = [ glib libsndfile zlib bzip2 lzma libsamplerate ];
}
