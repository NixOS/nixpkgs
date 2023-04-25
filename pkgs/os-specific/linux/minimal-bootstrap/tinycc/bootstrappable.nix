# Bootstrappable TCC is a fork from mainline TCC development
# that can be compiled by MesCC

{ lib
, runCommand
, fetchtarball
, mes
, buildTinyccN
, unified-libc
}:
let
  version = "unstable-2023-04-20";
  rev = "80114c4da6b17fbaabb399cc29f427e368309bc8";
  src = (fetchtarball {
    url = "https://gitlab.com/janneke/tinycc/-/archive/${rev}/tinycc-${rev}.tar.gz";
    sha256 = "1a0cw9a62qc76qqn5sjmp3xrbbvsz2dxrw21lrnx9q0s74mwaxbq";
  }) + "/tinycc-${rev}";

  mes-tcc = runCommand "mes-tcc-${version}" {} ''
    # Create config.h
    catm config.h

    ${mes}/bin/mes --no-auto-compile -e main ${mes}/bin/mescc.scm -- \
      -S \
      -o tcc.s \
      -I . \
      -D BOOTSTRAP=1 \
      -I ${src} \
      -D TCC_TARGET_I386=1 \
      -D inline= \
      -D CONFIG_TCCDIR=\"''${out}/lib\" \
      -D CONFIG_SYSROOT=\"\" \
      -D CONFIG_TCC_CRTPREFIX=\"''${out}/lib\" \
      -D CONFIG_TCC_ELFINTERP=\"/mes/loader\" \
      -D CONFIG_TCC_SYSINCLUDEPATHS=\"${mes}${mes.mesPrefix}/include\" \
      -D TCC_LIBGCC=\"${mes}${mes.mesPrefix}/lib/x86-mes/libc.a\" \
      -D CONFIG_TCC_LIBTCC1_MES=0 \
      -D CONFIG_TCCBOOT=1 \
      -D CONFIG_TCC_STATIC=1 \
      -D CONFIG_USE_LIBGCC=1 \
      -D TCC_MES_LIBC=1 \
      -D TCC_VERSION=\"${version}\" \
      -D ONE_SOURCE=1 \
      ${src}/tcc.c

    mkdir -p ''${out}/bin
    ${mes}/bin/mes --no-auto-compile -e main ${mes}/bin/mescc.scm -- \
      -l c+tcc \
      -o ''${out}/bin/tcc \
      tcc.s

    # Quick test
    ''${out}/bin/tcc -version

    # Recompile the mes C library
    mkdir -p ''${out}/lib
    cd ${mes}${mes.mesPrefix}

    # crt1.o
    ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${out}/lib/crt1.o lib/linux/x86-mes-gcc/crt1.c

    # crtn.o
    ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${out}/lib/crtn.o lib/linux/x86-mes-gcc/crtn.c

    # crti.o
    ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${out}/lib/crti.o lib/linux/x86-mes-gcc/crti.c

    # libc+gcc.a
    ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${TMPDIR}/unified-libc.o ${unified-libc}
    ''${out}/bin/tcc -ar cr ''${out}/lib/libc.a ''${TMPDIR}/unified-libc.o

    # libtcc1.a
    ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${TMPDIR}/libtcc1.o lib/libtcc1.c
    ''${out}/bin/tcc -ar cr ''${out}/lib/libtcc1.a ''${TMPDIR}/libtcc1.o

    # libgetopt.a
    ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${TMPDIR}/getopt.o lib/posix/getopt.c
    ''${out}/bin/tcc -ar cr ''${out}/lib/libgetopt.a ''${TMPDIR}/getopt.o
  '';

  boot0-tcc = buildTinyccN {
    pname = "boot0-tcc";
    inherit src version;
    prev = mes-tcc;
    buildOptions = [
      "-D HAVE_LONG_LONG_STUB=1"
      "-D HAVE_SETJMP=1"
    ];
    libtccBuildOptions = [
      "-D HAVE_LONG_LONG_STUB=1"
    ];
  };

  boot1-tcc = buildTinyccN {
    pname = "boot1-tcc";
    inherit src version;
    prev = boot0-tcc;
    buildOptions = [
      "-D HAVE_BITFIELD=1"
      "-D HAVE_LONG_LONG=1"
      "-D HAVE_SETJMP=1"
    ];
    libtccBuildOptions = [
      "-D HAVE_LONG_LONG=1"
    ];
  };

  boot2-tcc = buildTinyccN {
    pname = "boot2-tcc";
    inherit src version;
    prev = boot1-tcc;
    buildOptions = [
      "-D HAVE_BITFIELD=1"
      "-D HAVE_FLOAT_STUB=1"
      "-D HAVE_LONG_LONG=1"
      "-D HAVE_SETJMP=1"
    ];
    libtccBuildOptions = [
      "-D HAVE_FLOAT_STUB=1"
      "-D HAVE_LONG_LONG=1"
    ];
  };

  boot3-tcc = buildTinyccN {
    pname = "boot3-tcc";
    inherit src version;
    prev = boot2-tcc;
    buildOptions = [
      "-D HAVE_BITFIELD=1"
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
      "-D HAVE_SETJMP=1"
    ];
    libtccBuildOptions = [
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
    ];
  };

  boot4-tcc = buildTinyccN {
    pname = "boot4-tcc";
    inherit src version;
    prev = boot3-tcc;
    buildOptions = [
      "-D HAVE_BITFIELD=1"
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
      "-D HAVE_SETJMP=1"
    ];
    libtccBuildOptions = [
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
    ];
  };
in
boot4-tcc
