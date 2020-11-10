{ stdenv, fetchurl, libxcb }:

stdenv.mkDerivation rec {
  pname = "wmutils-core";
  version = "1.1";

  src = fetchurl {
    url = "https://github.com/wmutils/core/archive/v${version}.tar.gz";
    sha256 = "0aq95khs154j004b79w9rgm80vpggxfqynha5rckm2cx20d1fa5s";
  };

  buildInputs = [ libxcb ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Set of window manipulation tools";
    homepage = "https://github.com/wmutils/core";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
