{ stdenv, execline, fetchgit, skalibs }:

let

  version = "2.2.4.3";

in stdenv.mkDerivation rec {

  name = "s6-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6";
    rev = "refs/tags/v${version}";
    sha256 = "1jlavi3q6wmcxdcwsy42qcgfkl0ag6hwcgmi4g67dvqs9nqjq2a3";
  };

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-include=${execline}/include"
    "--with-lib=${skalibs}/lib"
    "--with-lib=${execline}/lib"
    "--with-dynlib=${skalibs}/lib"
    "--with-dynlib=${execline}/lib"
  ]
  ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ])
  ++ (stdenv.lib.optional stdenv.isDarwin "--target=${stdenv.system}");

  preBuild = ''
    substituteInPlace "src/daemontools-extras/s6-log.c" \
      --replace '"execlineb"' '"${execline}/bin/execlineb"'
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6/;
    description = "skarnet.org's small & secure supervision software suite";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
