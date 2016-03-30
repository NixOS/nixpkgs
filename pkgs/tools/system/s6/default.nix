{ stdenv, execline, fetchgit, skalibs }:

let

  version = "2.2.4.3";

in stdenv.mkDerivation rec {

  name = "s6-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6";
    rev = "refs/tags/v${version}";
    sha256 = "0j981xslcsra8filaawgwq6daqvxxjs0014lqb7dy3qf7c5pc4l8";
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
  ] ++ [ (if stdenv.isDarwin then "--disable-shared" else "--enable-shared") ];

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
