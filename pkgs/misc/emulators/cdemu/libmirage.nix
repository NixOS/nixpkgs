{ callPackage, gobject-introspection, cmake, pkg-config
, glib, libsndfile, zlib, bzip2, lzma, libsamplerate, intltool
, pcre, util-linux, libselinux, libsepol }:

let pkg = import ./base.nix {
  version = "3.2.3";
  pkgName = "libmirage";
  pkgSha256 = "08mfvqyk3833ksfd47i4j3ppmrw5ry219km6h7lywdh9hm9x14yf";
};
in callPackage pkg {
  buildInputs = [ glib libsndfile zlib bzip2 lzma libsamplerate intltool ];
  drvParams = {
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "out"}/share/gir-1.0";
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";
    nativeBuildInputs = [ cmake gobject-introspection pkg-config ];
    propagatedBuildInputs = [ pcre util-linux libselinux libsepol ];
  };
}
