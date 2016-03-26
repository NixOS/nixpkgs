{ stdenv, fetchurl, ncurses, readline }:

stdenv.mkDerivation rec {
  name = "udftools-${version}";
  version = "1.0.0b3";
  src = fetchurl {
    url = "mirror://sourceforge/linux-udf/udftools/${version}/${name}.tar.gz";
    sha256 = "180414z7jblby64556i8p24rcaas937zwnyp1zg073jdin3rw1y5";
  };

  buildInputs = [ ncurses readline ];

  NIX_CFLAGS_COMPILE = "-std=gnu90";

  preConfigure = ''
    sed -e '1i#include <limits.h>' -i cdrwtool/cdrwtool.c -i pktsetup/pktsetup.c
    sed -e 's@[(]char[*][)]spm [+]=@spm = ((char*) spm) + @' -i wrudf/wrudf.c
    sed -e '27i#include <string.h>' -i include/udf_endian.h
    sed -e '38i#include <string.h>' -i wrudf/wrudf-cdrw.c
    sed -e '12i#include <string.h>' -i wrudf/wrudf-cdr.c
    sed -e '37i#include <stdlib.h>' -i wrudf/ide-pc.c
  '';

  meta = with stdenv.lib; {
    description = "UDF tools";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
