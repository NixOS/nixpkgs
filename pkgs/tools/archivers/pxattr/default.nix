{ stdenv, fetchurl, gcc }:

stdenv.mkDerivation rec {
  name = "pxattr-2.1.0";

  src = fetchurl {
    url = "http://www.lesbonscomptes.com/pxattr/pxattr-2.1.0.tar.gz";
    sha256 = "1dwcqc5z7gzma1zhis2md49bj2nq7m6jimh4zlx9szw6svisz56z";
  };

  buildInputs = [ gcc ];

  installPhase = ''
    mkdir -p $out/bin
    cp pxattr $out/bin
  '';

  meta = {
    homepage = http://www.lesbonscomptes.com/pxattr/index.html;
    description = "Provides a single interface to extended file attributes";
    maintainers = [ stdenv.lib.maintainers.vrthra ];
    license = [ stdenv.lib.licenses.mit ];
    platforms = stdenv.lib.platforms.unix;
  };
}
