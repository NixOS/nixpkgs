# Bootstrappable TCC is a fork from mainline TCC development
# that can be compiled by MesCC

# Build steps adapted from https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/tcc-0.9.26/tcc-0.9.26.kaem
#
# SPDX-FileCopyrightText: 2021-22 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib
, callPackage
, fetchurl
, kaem
, mes
, mes-libc
}:
let
  inherit (callPackage ./common.nix { }) buildTinyccMes;

  version = "unstable-2023-04-20";
  rev = "80114c4da6b17fbaabb399cc29f427e368309bc8";

  tarball = fetchurl {
    url = "https://gitlab.com/janneke/tinycc/-/archive/${rev}/tinycc-${rev}.tar.gz";
    sha256 = "1a0cw9a62qc76qqn5sjmp3xrbbvsz2dxrw21lrnx9q0s74mwaxbq";
  };
  src = (kaem.runCommand "tinycc-bootstrappable-${version}-source" {} ''
    ungz --file ${tarball} --output tinycc.tar
    mkdir -p ''${out}
    cd ''${out}
    untar --file ''${NIX_BUILD_TOP}/tinycc.tar
  '') + "/tinycc-${rev}";

  meta = with lib; {
    description = "Tiny C Compiler's bootstrappable fork";
    homepage = "https://gitlab.com/janneke/tinycc";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };

  tinycc-boot-mes = kaem.runCommand "tinycc-boot-mes-${version}" {} ''
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
      -D CONFIG_TCC_SYSINCLUDEPATHS=\"${mes-libc}/include\" \
      -D TCC_LIBGCC=\"${mes-libc}/lib/x86-mes/libc.a\" \
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

    ''${out}/bin/tcc -version

    # Recompile libc: crt{1,n,i}, libtcc.a, libc.a, libgetopt.a
    mkdir -p ''${out}/lib
    ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crt1.o ${mes-libc}/lib/crt1.c
    ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crtn.o ${mes-libc}/lib/crtn.c
    ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crti.o ${mes-libc}/lib/crti.c
    ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o libc.o ${mes-libc}/lib/libc.c
    ''${out}/bin/tcc -ar cr ''${out}/lib/libc.a libc.o
    ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o libtcc1.o ${mes-libc}/lib/libtcc1.c
    ''${out}/bin/tcc -ar cr ''${out}/lib/libtcc1.a libtcc1.o
    ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o libgetopt.o ${mes-libc}/lib/libgetopt.c
    ''${out}/bin/tcc -ar cr ''${out}/lib/libgetopt.a libgetopt.o
  '';

  # Bootstrap stage build flags obtained from
  # https://gitlab.com/janneke/tinycc/-/blob/80114c4da6b17fbaabb399cc29f427e368309bc8/boot.sh

  tinycc-boot0 = buildTinyccMes {
    pname = "tinycc-boot0";
    inherit src version meta;
    prev = tinycc-boot-mes;
    buildOptions = [
      "-D HAVE_LONG_LONG_STUB=1"
      "-D HAVE_SETJMP=1"
    ];
    libtccBuildOptions = [
      "-D HAVE_LONG_LONG_STUB=1"
    ];
  };

  tinycc-boot1 = buildTinyccMes {
    pname = "tinycc-boot1";
    inherit src version meta;
    prev = tinycc-boot0;
    buildOptions = [
      "-D HAVE_BITFIELD=1"
      "-D HAVE_LONG_LONG=1"
      "-D HAVE_SETJMP=1"
    ];
    libtccBuildOptions = [
      "-D HAVE_LONG_LONG=1"
    ];
  };

  tinycc-boot2 = buildTinyccMes {
    pname = "tinycc-boot2";
    inherit src version meta;
    prev = tinycc-boot1;
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

  tinycc-boot3 = buildTinyccMes {
    pname = "tinycc-boot3";
    inherit src version meta;
    prev = tinycc-boot2;
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
buildTinyccMes {
  pname = "tinycc-bootstrappable";
  inherit src version meta;
  prev = tinycc-boot3;
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
}
