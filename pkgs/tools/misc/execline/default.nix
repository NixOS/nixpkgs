{ stdenv, fetchgit, skalibs }:

let

  version = "2.1.4.5";

in stdenv.mkDerivation rec {

  name = "execline-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/execline";
    rev = "refs/tags/v${version}";
    sha256 = "1k4db9iyskrqf6wbc4dkiqgpn0wb43qc9rf1br7kvy9rrzq3yrj0";
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
  ]
  ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ])
  ++ (stdenv.lib.optional stdenv.isDarwin "--target=${stdenv.system}");

  meta = {
    homepage = http://skarnet.org/software/execline/;
    description = "A small scripting language, to be used in place of a shell in non-interactive scripts";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
