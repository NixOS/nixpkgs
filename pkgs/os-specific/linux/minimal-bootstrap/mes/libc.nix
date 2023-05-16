{ lib
, kaem
, ln-boot
, mes
, mes-libc
}:
let
  pname = "mes-libc";
<<<<<<< HEAD
  inherit (mes.compiler) version;
=======
  inherit (mes) version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  sources = (import ./sources.nix).x86.linux.gcc;
  inherit (sources) libtcc1_SOURCES libc_gnu_SOURCES;

<<<<<<< HEAD
=======
  prefix = "${mes}/share/mes-${version}";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Concatenate all source files into a convenient bundle
  # "gcc" variants of source files (eg. "lib/linux/x86-mes-gcc") can also be
  # compiled by tinycc
  #
  # Passing this many arguments is too much for kaem so we need to split
  # the operation in two
  firstLibc = lib.take 100 libc_gnu_SOURCES;
  lastLibc = lib.drop 100 libc_gnu_SOURCES;
in
kaem.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [ ln-boot ];

  passthru.CFLAGS = "-DHAVE_CONFIG_H=1 -I${mes-libc}/include -I${mes-libc}/include/linux/x86";

  meta = with lib; {
    description = "The Mes C Library";
    homepage = "https://www.gnu.org/software/mes";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = teams.minimal-bootstrap.members;
    platforms = [ "i686-linux" ];
  };
} ''
  cd ${mes.srcPrefix}

  # mescc compiled libc.a
  mkdir -p ''${out}/lib/x86-mes
=======
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };
} ''
  cd ${prefix}

  # mescc compiled libc.a
  mkdir -p ''${out}/lib/x86-mes
  cp lib/x86-mes/libc.a ''${out}/lib/x86-mes
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # libc.c
  catm ''${TMPDIR}/first.c ${lib.concatStringsSep " " firstLibc}
  catm ''${out}/lib/libc.c ''${TMPDIR}/first.c ${lib.concatStringsSep " " lastLibc}

  # crt{1,n,i}.c
  cp lib/linux/x86-mes-gcc/crt1.c ''${out}/lib
  cp lib/linux/x86-mes-gcc/crtn.c ''${out}/lib
  cp lib/linux/x86-mes-gcc/crti.c ''${out}/lib

  # libtcc1.c
  catm ''${out}/lib/libtcc1.c ${lib.concatStringsSep " " libtcc1_SOURCES}

  # getopt.c
  cp lib/posix/getopt.c ''${out}/lib/libgetopt.c

  # Install headers
<<<<<<< HEAD
  ln -s ${mes.srcPrefix}/include ''${out}/include
=======
  ln -s ${prefix}/include ''${out}/include
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
''
