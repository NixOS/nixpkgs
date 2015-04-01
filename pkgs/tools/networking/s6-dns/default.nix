{ stdenv, fetchgit, skalibs }:

let

  version = "2.0.0.2";

in stdenv.mkDerivation rec {

  name = "s6-dns-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6-dns";
    rev = "refs/tags/v${version}";
    sha256 = "0rsw19r9hwxb0xj9xs1rwb7fa21wwbsnfq3p2nfg4lf6cc64b39r";
  };

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--includedir=\${prefix}/include"
    "--libdir=\${prefix}/lib"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ] ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ]);

  meta = {
    homepage = http://www.skarnet.org/software/s6-dns/;
    description = "A suite of DNS client programs and libraries for Unix systems";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
