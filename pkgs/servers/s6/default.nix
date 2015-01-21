{ stdenv, execline, fetchgit, skalibs }:

let

  version = "2.0.1.0";

in stdenv.mkDerivation rec {

  name = "s6-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6";
    rev = "refs/tags/v${version}";
    sha256 = "1x7za0b1a2i6xn06grpb5j361s9bl4524bp5mz3zcdg8s9nil50d";
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
  ] ++ stdenv.lib.optional stdenv.isDarwin [ "--disable-shared" ];

  preBuild = ''
    substituteInPlace "src/daemontools-extras/s6-log.c" \
      --replace '"execlineb"' '"${execline}/bin/execlineb"'
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6/;
    description = "skarnet.org's small & secure supervision software suite";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
