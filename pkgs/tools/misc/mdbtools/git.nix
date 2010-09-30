{ stdenv, fetchurl, fetchgit, glib, readline, bison, flex, pkgconfig,
  libiconv, autoconf, automake, libtool }:

stdenv.mkDerivation {
  name = "mdbtools-git";

  src = fetchgit {
    url = "http://github.com/brianb/mdbtools.git";
    rev = "5ac44b69d9375cca3e1055b70fd22abf7fbf17ab";
    sha256 = "094e6b480c6fda3a000d0d8539b209d2d7c204a440660a21c11f2e1c9b3aa345";
  };

  buildInputs = [glib readline bison flex pkgconfig libiconv autoconf automake
    libtool];

  preConfigure = ''
    sed -e 's@static \(GHashTable [*]mdb_backends;\)@\1@' -i src/libmdb/backend.c
    export NIX_LDFLAGS="$NIX_LDFLAGS -liconv"
    ./autogen.sh
  '';

  meta = {
    description = ".mdb (MS Access) format tools";
  };
}
