{ callPackage, glib, libsndfile, zlib, bzip2, lzma, libsamplerate }:
let pkg = import ./base.nix {
  version = "3.0.3";
  pkgName = "libmirage";
  pkgSha256 = "03idg94h5qhmnnc8g9dw8yqf14yv2paph5n77dfmg925f3z70nyn";
};
in callPackage pkg {
  buildInputs = [ glib libsndfile zlib bzip2 lzma libsamplerate ];
}
