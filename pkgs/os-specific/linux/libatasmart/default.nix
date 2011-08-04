{ stdenv, fetchurl, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "libatasmart-0.17";

  src = fetchurl {
    url = "http://0pointer.de/public/${name}.tar.gz";
    sha256 = "1zazxnqsirlv9gkzij6z31b21gv2nv7gkpja0wpxwb7kfh9a2qid";
  };

  buildInputs = [ pkgconfig udev ];

  meta = {
    homepage = http://0pointer.de/public/;
    description = "Library for querying ATA SMART status";
    platforms = stdenv.lib.platforms.linux;
  };
}
