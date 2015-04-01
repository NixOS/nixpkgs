{ stdenv, fetchgit, skalibs }:

let

  version = "2.1.1.0";

in stdenv.mkDerivation rec {

  name = "execline-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/execline";
    rev = "refs/tags/v${version}";
    sha256 = "0yhxyih8p6p9135nifi655qk4gnhdarjzfp1lb4pxx9ar9ay5q7w";
  };

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--libdir=\${prefix}/lib"
    "--includedir=\${prefix}/include"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ] ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ]);

  meta = {
    homepage = http://skarnet.org/software/execline/;
    description = "A small scripting language, to be used in place of a shell in non-interactive scripts";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
