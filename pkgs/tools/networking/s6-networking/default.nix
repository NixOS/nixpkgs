{ stdenv, execline, fetchgit, s6, s6Dns, skalibs }:

let

  version = "2.1.0.1";

in stdenv.mkDerivation rec {

  name = "s6-networking-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6-networking";
    rev = "refs/tags/v${version}";
    sha256 = "0jdjxwqrp7lzdb85sp1gdkm7s478wyl7wqxb3jfxflgh2bgdgvy2";
  };

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-include=${execline}/include"
    "--with-include=${s6}/include"
    "--with-include=${s6Dns}/include"
    "--with-lib=${skalibs}/lib"
    "--with-lib=${execline}/lib"
    "--with-lib=${s6}/lib/s6"
    "--with-lib=${s6Dns}/lib"
    "--with-dynlib=${skalibs}/lib"
    "--with-dynlib=${execline}/lib"
    "--with-dynlib=${s6}/lib"
    "--with-dynlib=${s6Dns}/lib"
  ];

  meta = {
    homepage = http://www.skarnet.org/software/s6-networking/;
    description = "A suite of small networking utilities for Unix systems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
