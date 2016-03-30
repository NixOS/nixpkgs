{ stdenv, fetchgit, skalibs }:

let

  version = "2.0.0.7";

in stdenv.mkDerivation rec {

  name = "s6-dns-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6-dns";
    rev = "refs/tags/v${version}";
    sha256 = "033pijilkvj3vw94aqrvavr4mqafm7kcc8ql8lc3ma6lqkx4xyak";
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
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
