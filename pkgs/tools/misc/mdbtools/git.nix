{ stdenv, fetchgit, glib, readline, bison, flex, pkgconfig,
  libiconv, autoreconfHook, which, txt2man, gnome_doc_utils, scrollkeeper }:

stdenv.mkDerivation {
  name = "mdbtools-git-2014-07-25";

  src = fetchgit {
    url = "http://github.com/brianb/mdbtools.git";
    rev = "9ab40e83e6789015c965c92bdb62f92f8cdd0dbd";
    sha256 = "0hlf5lk86xm0bpdlpk4a1zyfvbim76dhvmybxga2p7mbb1jc825l";
  };

  buildInputs = [
    glib readline bison flex autoreconfHook pkgconfig which txt2man
    gnome_doc_utils scrollkeeper libiconv
  ];

  preAutoreconf = ''
    sed -e '/ENABLE_GTK_DOC/aAM_CONDITIONAL(HAVE_GNOME_DOC_UTILS, test x$enable_gtk_doc = xyes)' \
        -e  '/ENABLE_GTK_DOC/aAM_CONDITIONAL(ENABLE_SK, test x$enable_scrollkeeper = xyes)' \
        -i configure.ac
  '';

  preConfigure = ''
    sed -e 's@static \(GHashTable [*]mdb_backends;\)@\1@' -i src/libmdb/backend.c
  '';

  meta = {
    description = ".mdb (MS Access) format tools";
    platforms = stdenv.lib.platforms.linux;
  };
}
