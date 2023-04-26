# Build steps adapted from https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/tcc-0.9.27/tcc-0.9.27.kaem
#
# SPDX-FileCopyrightText: 2021-22 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib
, runCommand
, fetchtarball
, callPackage
, mes
}:
let
  version = "unstable-2023-04-20";
  src = (fetchtarball {
    url = "https://repo.or.cz/tinycc.git/snapshot/86f3d8e33105435946383aee52487b5ddf918140.tar.gz";
    sha256 = "11idrvbwfgj1d03crv994mpbbbyg63j1k64lw1gjy7mkiifw2xap";
  }) + "/tinycc-86f3d8e";

  meta = with lib; {
    description = "Small, fast, and embeddable C compiler and interpreter";
    homepage = "https://repo.or.cz/w/tinycc.git";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };

  mes-libc = runCommand "mes-libc-${version}.c" { MES_PREFIX = "${mes}${mes.mesPrefix}"; } ''
    kaem --verbose --strict --file ${./mes-libc.kaem}
  '';

  buildTinyccN = {
    pname,
    version,
    src,
    prev,
    buildOptions,
    libtccBuildOptions,
    meta
  }:
    let
      options = lib.strings.concatStringsSep " " buildOptions;
      libtccOptions = lib.strings.concatStringsSep " " libtccBuildOptions;
    in
    runCommand "${pname}-${version}" {
      inherit pname version meta;
    } ''
      catm config.h
      mkdir -p ''${out}/bin ''${out}/lib
      ${prev}/bin/tcc \
        -g \
        -v \
        -static \
        -o ''${out}/bin/tcc \
        -D BOOTSTRAP=1 \
        ${options} \
        -I . \
        -I ${src} \
        -D TCC_TARGET_I386=1 \
        -D CONFIG_TCCDIR=\"''${out}/lib\" \
        -D CONFIG_TCC_CRTPREFIX=\"''${out}/lib\" \
        -D CONFIG_TCC_ELFINTERP=\"\" \
        -D CONFIG_TCC_LIBPATHS=\"''${out}/lib\" \
        -D CONFIG_TCC_SYSINCLUDEPATHS=\"${mes}${mes.mesPrefix}/include:${src}/include\" \
        -D TCC_LIBGCC=\"libc.a\" \
        -D TCC_LIBTCC1=\"libtcc1.a\" \
        -D CONFIG_TCCBOOT=1 \
        -D CONFIG_TCC_STATIC=1 \
        -D CONFIG_USE_LIBGCC=1 \
        -D TCC_MES_LIBC=1 \
        -D TCC_VERSION=\"${version}\" \
        -D ONE_SOURCE=1 \
        -L ${prev}/lib \
        ${src}/tcc.c

      ''${out}/bin/tcc -v

      cd ${mes}${mes.mesPrefix}
      # Recompile libc: crt{1,n,i}, libtcc.a, libc.a, libgetopt.a
      ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${out}/lib/crt1.o lib/linux/x86-mes-gcc/crt1.c
      ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${out}/lib/crtn.o lib/linux/x86-mes-gcc/crtn.c
      ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${out}/lib/crti.o lib/linux/x86-mes-gcc/crti.c
      ''${out}/bin/tcc -c -D TCC_TARGET_I386=1 ${libtccOptions} -o ''${TMPDIR}/libtcc1.o ${src}/lib/libtcc1.c
      ''${out}/bin/tcc -ar cr ''${out}/lib/libtcc1.a ''${TMPDIR}/libtcc1.o
      ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${TMPDIR}/mes-libc.o ${mes-libc}
      ''${out}/bin/tcc -ar cr ''${out}/lib/libc.a ''${TMPDIR}/mes-libc.o
      ''${out}/bin/tcc -c -D HAVE_CONFIG_H=1 -I include -I include/linux/x86 -o ''${TMPDIR}/getopt.o lib/posix/getopt.c
      ''${out}/bin/tcc -ar cr ''${out}/lib/libgetopt.a ''${TMPDIR}/getopt.o
    '';

  boot4-tcc = callPackage ./bootstrappable.nix { inherit buildTinyccN mes-libc; };

  tccdefs = runCommand "tccdefs-${version}" {} ''
    mkdir ''${out}
    ${boot4-tcc}/bin/tcc -static -DC2STR -o c2str ${src}/conftest.c
    ./c2str ${src}/include/tccdefs.h ''${out}/tccdefs_.h
  '';

  boot5-tcc = buildTinyccN {
    pname = "boot5-tcc";
    inherit src version meta;
    prev = boot4-tcc;
    buildOptions = [
      "-D HAVE_BITFIELD=1"
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
      "-D HAVE_SETJMP=1"
      "-D CONFIG_TCC_PREDEFS=1"
      "-I ${tccdefs}"
      "-D CONFIG_TCC_SEMLOCK=0"
    ];
    libtccBuildOptions = [
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
      "-D CONFIG_TCC_PREDEFS=1"
      "-I ${tccdefs}"
      "-D CONFIG_TCC_SEMLOCK=0"
    ];
  };

  tinycc-with-mes-libc = buildTinyccN {
    pname = "tinycc-with-mes-libc";
    inherit src version meta;
    prev = boot5-tcc;
    buildOptions = [
      "-std=c99"
      "-D HAVE_BITFIELD=1"
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
      "-D HAVE_SETJMP=1"
      "-D CONFIG_TCC_PREDEFS=1"
      "-I ${tccdefs}"
      "-D CONFIG_TCC_SEMLOCK=0"
    ];
    libtccBuildOptions = [
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
      "-D CONFIG_TCC_PREDEFS=1"
      "-I ${tccdefs}"
      "-D CONFIG_TCC_SEMLOCK=0"
    ];
  };
in
tinycc-with-mes-libc
