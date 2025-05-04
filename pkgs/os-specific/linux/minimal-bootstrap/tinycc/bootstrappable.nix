# Bootstrappable TCC is a fork from mainline TCC development
# that can be compiled by MesCC

# Build steps adapted from https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/tcc-0.9.26/tcc-0.9.26.kaem
#
# SPDX-FileCopyrightText: 2021-22 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  lib,
  callPackage,
  fetchurl,
  kaem,
  mes,
  mes-libc,
}:
let
  inherit (callPackage ./common.nix { }) buildTinyccMes recompileLibc;

  version = "unstable-2023-04-20";
  rev = "80114c4da6b17fbaabb399cc29f427e368309bc8";

  tarball = fetchurl {
    url = "https://gitlab.com/janneke/tinycc/-/archive/${rev}/tinycc-${rev}.tar.gz";
    sha256 = "1a0cw9a62qc76qqn5sjmp3xrbbvsz2dxrw21lrnx9q0s74mwaxbq";
  };
  src =
    (kaem.runCommand "tinycc-bootstrappable-${version}-source" { } ''
      ungz --file ${tarball} --output tinycc.tar
      mkdir -p ''${out}
      cd ''${out}
      untar --file ''${NIX_BUILD_TOP}/tinycc.tar

      # Patch
      cd tinycc-${rev}
      # Static link by default
      replace --file libtcc.c --output libtcc.c --match-on "s->ms_extensions = 1;" --replace-with "s->ms_extensions = 1; s->static_link = 1;"
    '')
    + "/tinycc-${rev}";

  meta = with lib; {
    description = "Tiny C Compiler's bootstrappable fork";
    homepage = "https://gitlab.com/janneke/tinycc";
    license = licenses.lgpl21Only;
    teams = [ teams.minimal-bootstrap ];
    platforms = [ "i686-linux" ];
  };

  pname = "tinycc-boot-mes";

  tinycc-boot-mes = rec {
    compiler =
      kaem.runCommand "${pname}-${version}"
        {
          passthru.tests.get-version =
            result:
            kaem.runCommand "${pname}-get-version-${version}" { } ''
              ${result}/bin/tcc -version
              mkdir ''${out}
            '';
        }
        ''
          catm config.h
          ${mes.compiler}/bin/mes --no-auto-compile -e main ${mes.srcPost.bin}/bin/mescc.scm -- \
            -S \
            -o tcc.s \
            -I . \
            -D BOOTSTRAP=1 \
            -I ${src} \
            -D TCC_TARGET_I386=1 \
            -D inline= \
            -D CONFIG_TCCDIR=\"\" \
            -D CONFIG_SYSROOT=\"\" \
            -D CONFIG_TCC_CRTPREFIX=\"{B}\" \
            -D CONFIG_TCC_ELFINTERP=\"/mes/loader\" \
            -D CONFIG_TCC_LIBPATHS=\"{B}\" \
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
          ${mes.compiler}/bin/mes --no-auto-compile -e main ${mes.srcPost.bin}/bin/mescc.scm -- \
            -L ${mes.libs}/lib \
            -l c+tcc \
            -o ''${out}/bin/tcc \
            tcc.s
        '';

    libs = recompileLibc {
      inherit pname version;
      tcc = compiler;
      src = mes-libc;
      libtccOptions = mes-libc.CFLAGS;
    };
  };

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
