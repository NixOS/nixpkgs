{ lib
, runCommand
, ln-boot
, mes
, libc_SOURCES
, libc_gnu_SOURCES
, mes-libc
}:
let
  pname = "mes-libc";
  inherit (mes) version;

  # Concatenate all source files into a convenient bundle
  # "gcc" variants (eg. "lib/linux/x86-mes-gcc") can also be used with tinycc
  sources = libc_SOURCES "gcc" ++ libc_gnu_SOURCES "gcc";
  # Passing this many arguments is too much for kaem so we need to split
  # the operation in two
  firstLibc = lib.take 100 sources;
  lastLibc = lib.drop 100 sources;
in runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [ ln-boot ];

  passthru.CFLAGS = "-DHAVE_CONFIG_H=1 -I${mes-libc}/include -I${mes-libc}/include/linux/x86";

  meta = with lib; {
    description = "The Mes C Library";
    homepage = "https://www.gnu.org/software/mes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };
} ''
  mkdir -p ''${out}/lib
  PREFIX=${mes}/share/mes-${version}
  cd ''${PREFIX}

  # mescc compiled libc.a
  mkdir ''${out}/lib/x86-mes
  cp lib/x86-mes/libc.a ''${out}/lib/x86-mes

  # libc.c
  catm ''${TMPDIR}/first.c ${lib.concatStringsSep " " firstLibc}
  catm ''${out}/lib/libc.c ''${TMPDIR}/first.c ${lib.concatStringsSep " " lastLibc}

  # crt{1,n,i}.c
  cp lib/linux/x86-mes-gcc/crt1.c ''${out}/lib
  cp lib/linux/x86-mes-gcc/crtn.c ''${out}/lib
  cp lib/linux/x86-mes-gcc/crti.c ''${out}/lib

  # libtcc1.c
  cp lib/libtcc1.c ''${out}/lib

  # getopt.c
  cp lib/posix/getopt.c ''${out}/lib

  # Install headers
  ln -s ''${PREFIX}/include ''${out}/include
''
