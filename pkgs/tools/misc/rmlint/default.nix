{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "rmlint-1.0.8";

  src = fetchurl {
    url = "https://github.com/downloads/sahib/rmlint/rmlint_1.0.8.tar.gz";
    sha256 = "bea39a5872b39d3596e756f242967bc5bde6febeb996fdcd63fbcf5bfdc75f01";
  };

  preConfigure = ''
    substituteInPlace Makefile.in \
      --replace "/usr/" "/"
  '';

  makeFlags="DESTDIR=$(out)";

  meta = {
    description = "A tool to remove duplicates and other lint";
    homepage = "https://github.com/sahib/rmlint";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
