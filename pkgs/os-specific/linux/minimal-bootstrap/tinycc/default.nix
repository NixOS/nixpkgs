# Build steps adapted from https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/tcc-0.9.27/tcc-0.9.27.kaem
#
# SPDX-FileCopyrightText: 2021-22 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib
, runCommand
, fetchurl
, callPackage
, mes
, mes-libc
, ln-boot
}:
let
  version = "unstable-2023-04-20";
  rev = "86f3d8e33105435946383aee52487b5ddf918140";

  tarball = fetchurl {
    url = "https://repo.or.cz/tinycc.git/snapshot/${rev}.tar.gz";
    sha256 = "11idrvbwfgj1d03crv994mpbbbyg63j1k64lw1gjy7mkiifw2xap";
  };
  src = (runCommand "tinycc-${version}-source" {} ''
    ungz --file ${tarball} --output tinycc.tar
    mkdir -p ''${out}
    cd ''${out}
    untar --file ''${NIX_BUILD_TOP}/tinycc.tar
  '') + "/tinycc-${builtins.substring 0 7 rev}";

  meta = with lib; {
    description = "Small, fast, and embeddable C compiler and interpreter";
    homepage = "https://repo.or.cz/w/tinycc.git";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };

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
      nativeBuildInputs = [ ln-boot ];
    } ''
      catm config.h
      mkdir -p ''${out}/bin
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
        -D CONFIG_TCC_SYSINCLUDEPATHS=\"${mes-libc}/include:${src}/include\" \
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

      # Recompile libc: crt{1,n,i}, libtcc.a, libc.a, libgetopt.a
      mkdir -p ''${out}/lib
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crt1.o ${mes-libc}/lib/crt1.c
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crtn.o ${mes-libc}/lib/crtn.c
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crti.o ${mes-libc}/lib/crti.c
      ''${out}/bin/tcc -c -D TCC_TARGET_I386=1 ${libtccOptions} -o libtcc1.o ${src}/lib/libtcc1.c
      ''${out}/bin/tcc -ar cr ''${out}/lib/libtcc1.a libtcc1.o
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o libc.o ${mes-libc}/lib/libc.c
      ''${out}/bin/tcc -ar cr ''${out}/lib/libc.a libc.o
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o getopt.o ${mes-libc}/lib/getopt.c
      ''${out}/bin/tcc -ar cr ''${out}/lib/libgetopt.a getopt.o

      # Install headers
      ln -s ${mes-libc}/include ''${out}/include
    '';

  tinycc-bootstrappable = callPackage ./bootstrappable.nix { inherit buildTinyccN; };

  tccdefs = runCommand "tccdefs-${version}" {} ''
    mkdir ''${out}
    ${tinycc-bootstrappable}/bin/tcc -static -DC2STR -o c2str ${src}/conftest.c
    ./c2str ${src}/include/tccdefs.h ''${out}/tccdefs_.h
  '';

  tinycc-mes-boot = buildTinyccN {
    pname = "tinycc-mes-boot";
    inherit src version meta;
    prev = tinycc-bootstrappable;
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

  tinycc-mes = buildTinyccN {
    pname = "tinycc-mes";
    inherit src version meta;
    prev = tinycc-mes-boot;
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
tinycc-mes
