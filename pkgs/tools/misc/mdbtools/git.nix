{ stdenv, fetchurl, fetchgit, glib, readline, bison, flex, pkgconfig,
  libiconvOrEmpty, autoconf, automake, libtool, which, txt2man, gnome_doc_utils,
  scrollkeeper}:

stdenv.mkDerivation {
  name = "mdbtools-git-2014-07-25";

  src = fetchgit {
    url = "http://github.com/brianb/mdbtools.git";
    rev = "9ab40e83e6789015c965c92bdb62f92f8cdd0dbd";
    sha256 = "18j1a9y9xhl7hhx30zvmx2n4w7dc8c7sdr6722sf3mh5230mvv59";
    name = "mdbtools-git-export";
  };

  buildInputs = [
    glib readline bison flex pkgconfig autoconf automake
    libtool which txt2man gnome_doc_utils scrollkeeper
  ] ++ libiconvOrEmpty;

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
