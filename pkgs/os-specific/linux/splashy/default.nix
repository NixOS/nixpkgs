{ stdenv, fetchurl, perl, pkgconfig, glib, directfb, file, zlib
, # !!! autocnf/automake are only necessary because we patch src/Makefile.am
  autoconf, automake
}:

stdenv.mkDerivation {
  name = "splashy-0.2.1";
  src = fetchurl {
    url = http://alioth.debian.org/frs/download.php/1812/splashy-0.2.1.tar.bz2;
    md5 = "05a4e0cc9dc363f6c093aa9c7122ccdc";
  };
  buildInputs = [perl pkgconfig glib directfb file zlib autoconf automake];
  patches = [./paths.patch];
  configureFlags = "--disable-shared";
}
