{ callPackage, glib, libsndfile, zlib, bzip2, lzma, libsamplerate, intltool }:
let pkg = import ./base.nix {
  version = "3.1.0";
  pkgName = "libmirage";
  pkgSha256 = "0qvkvnvxqx8hqzcqzh7sqjzgbc1nrd91lzv33lr8c6fgaq8cqzmn";
};
in callPackage pkg {
  buildInputs = [ glib libsndfile zlib bzip2 lzma libsamplerate intltool ];
}
