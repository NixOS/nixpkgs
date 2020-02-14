{ stdenv, fetchFromGitHub, ncurses, readline, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "udftools";
  version = "2.0";
  src = fetchFromGitHub {
    owner = "pali";
    repo = "udftools";
    rev = version;
    sha256 = "0mz04h3rki6ljwfs15z83gf4vv816w7xgz923waiqgmfj9xpvx87";
  };

  buildInputs = [ ncurses readline ];
  nativeBuildInputs = [ autoreconfHook ];

  hardeningDisable = [ "fortify" ];

  NIX_CFLAGS_COMPILE = "-std=gnu90";

  preConfigure = ''
    sed -e '1i#include <limits.h>' -i cdrwtool/cdrwtool.c -i pktsetup/pktsetup.c
    sed -e 's@[(]char[*][)]spm [+]=@spm = ((char*) spm) + @' -i wrudf/wrudf.c
    sed -e '27i#include <string.h>' -i include/udf_endian.h
    sed -e '38i#include <string.h>' -i wrudf/wrudf-cdrw.c
    sed -e '12i#include <string.h>' -i wrudf/wrudf-cdr.c
    sed -e '37i#include <stdlib.h>' -i wrudf/ide-pc.c
    sed -e '46i#include <sys/sysmacros.h>' -i mkudffs/main.c

    sed -e "s@\$(DESTDIR)/lib/udev/rules.d@$out/lib/udev/rules.d@" -i pktsetup/Makefile.am
  '';

  postFixup = ''
    sed -i -e "s@/usr/sbin/pktsetup@$out/sbin/pktsetup@" $out/lib/udev/rules.d/80-pktsetup.rules
  '';

  meta = with stdenv.lib; {
    description = "UDF tools";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
