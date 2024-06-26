{
  lib,
  stdenv,
  fetchurl,
  gcc,
}:

stdenv.mkDerivation rec {
  pname = "pxattr";
  version = "2.1.0";

  src = fetchurl {
    url = "https://www.lesbonscomptes.com/pxattr/pxattr-${version}.tar.gz";
    sha256 = "1dwcqc5z7gzma1zhis2md49bj2nq7m6jimh4zlx9szw6svisz56z";
  };

  buildInputs = [ gcc ];

  installPhase = ''
    mkdir -p $out/bin
    cp pxattr $out/bin
  '';

  meta = {
    homepage = "https://www.lesbonscomptes.com/pxattr/index.html";
    description = "Provides a single interface to extended file attributes";
    maintainers = [ lib.maintainers.vrthra ];
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.unix;
    mainProgram = "pxattr";
  };
}
