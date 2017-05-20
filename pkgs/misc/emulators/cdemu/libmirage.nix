{ callPackage, glib, libsndfile, zlib, bzip2, lzma, libsamplerate }:
let pkg = import ./base.nix {
  version = "3.0.5";
  pkgName = "libmirage";
  pkgSha256 = "01wfxlyviank7k3p27grl1r40rzm744rr80zr9lcjk3y8i5g8ni2";
};
in callPackage pkg {
  buildInputs = [ glib libsndfile zlib bzip2 lzma libsamplerate ];
}
