{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "untex-${version}";
  version = "1.2";

  src = fetchurl {
    url = "https://www.ctan.org/tex-archive/support/untex/${name}.tar.gz";
    sha256 = "07p836jydd5yjy905m5ylnnac1h4cc4jsr41panqb808mlsiwmmy";
  };

  hardeningDisable = [ "format" ];

  unpackPhase = "tar xf $src";
  installTargets = "install install.man";
  installFlags = "BINDIR=$(out)/bin MANDIR=$(out)/share/man/man1";
  preBuild = ''
    sed -i '1i#include <stdlib.h>\n#include <string.h>' untex.c
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "A utility which removes LaTeX commands from input";
    homepage = https://www.ctan.org/pkg/untex;
    license = licenses.gpl1;
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.all;
  };
}
