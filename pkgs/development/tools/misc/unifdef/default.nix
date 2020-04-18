{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "unifdef-2.6";

  src = fetchurl {
    url    = "https://github.com/fanf2/unifdef/archive/${name}.tar.gz";
    sha256 = "1p5wr5ms9w8kijy9h7qs1mz36dlavdj6ngz2bks588w7a20kcqxj";
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/unifdef.c \
      --replace '#include "version.h"' ""

    substituteInPlace $sourceRoot/Makefile \
      --replace "unifdef.c: version.h" "unifdef.c:"
  '';

  preBuild = ''
    unset HOME
    export DESTDIR=$out
  '';

  meta = with stdenv.lib; {
    homepage = "http://dotat.at/prog/unifdef/";
    description = "Selectively remove C preprocessor conditionals";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.vrthra ];
  };
}
