{ stdenv, fetchurl, fetchgit, glib, readline, bison, flex, pkgconfig,
  libiconv, autoconf, automake, libtool, which, txt2man, gnome_doc_utils,
  scrollkeeper}:

stdenv.mkDerivation {
  name = "mdbtools-git";

  src = fetchgit {
    url = "http://github.com/brianb/mdbtools.git";
    rev = "dfd752ec022097ee1e0999173aa604d8a0c0ca8b";
    sha256 = "0ibj36yxlhwjgi7cj170lwpbzdbgidkq5p8raa59v76bdrxwmb0n";
  };

  buildInputs = [glib readline bison flex pkgconfig libiconv autoconf automake
    libtool which txt2man gnome_doc_utils scrollkeeper ];

  preConfigure = ''
    sed -e 's@static \(GHashTable [*]mdb_backends;\)@\1@' -i src/libmdb/backend.c
    sed -e '/ENABLE_GTK_DOC/aAM_CONDITIONAL(HAVE_GNOME_DOC_UTILS, test x$enable_gtk_doc = xyes)' \
    -e  '/ENABLE_GTK_DOC/aAM_CONDITIONAL(ENABLE_SK, test x$enable_scrollkeeper = xyes)'          \
    -i configure.ac
    autoreconf -i -f
  '';

  meta = {
    description = ".mdb (MS Access) format tools";
  };
}
