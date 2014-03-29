{ stdenv, fetchurl, bzip2 }:

stdenv.mkDerivation rec {
  name    = "bsdiff-${version}";
  version = "4.3";

  src = fetchurl {
    url    = "http://www.daemonology.net/bsdiff/${name}.tar.gz";
    sha256 = "0j2zm3z271x5aw63mwhr3vymzn45p2vvrlrpm9cz2nywna41b0hq";
  };

  buildInputs = [ bzip2 ];
  patches = [ ./include-systypes.patch ];

  buildPhase = ''
    cc -O3 -lbz2 bspatch.c -o bspatch
    cc -O3 -lbz2 bsdiff.c  -o bsdiff
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    cp bsdiff    $out/bin
    cp bspatch   $out/bin
    cp bsdiff.1  $out/share/man/man1
    cp bspatch.1 $out/share/man/man1
  '';

  meta = {
    description = "An efficient binary diff/patch tool";
    homepage    = "http://www.daemonology.net/bsdiff";
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
