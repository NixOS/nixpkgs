{ stdenv, execline, fetchurl, s6Dns, skalibs }:

let

  version = "2.0.0.0";

in stdenv.mkDerivation rec {

  name = "s6-networking-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-networking/${name}.tar.gz";
    sha256 = "0k2i0g5lsvh1gz90ixwdip1pngj9vd45d4fpmdg075vd8zhh7j37";
  };

  dontDisableStatic = true;

  configureFlags = [
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-include=${execline}/include"
    "--with-include=${s6Dns}/include"
    "--with-lib=${skalibs}/lib"
    "--with-lib=${execline}/lib"
    "--with-lib=${s6Dns}/lib"
    "--with-dynlib=${skalibs}/lib"
    "--with-dynlib=${execline}/lib"
    "--with-dynlib=${s6Dns}/lib"
  ];

  meta = {
    homepage = http://www.skarnet.org/software/s6-networking/;
    description = "A suite of small networking utilities for Unix systems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
