# Bootstrappable TCC is a fork from mainline TCC development
# that can be compiled by MesCC

# Build steps adapted from https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/tcc-0.9.26/tcc-0.9.26.kaem
#
# SPDX-FileCopyrightText: 2021-22 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  lib,
  buildPlatform,
  callPackage,
  fetchurl,
  kaem,
  mes,
  mes-libc,
}:
let
  inherit (callPackage ./common.nix { }) buildTinyccMes recompileLibc;

  version = "unstable-2026-02-04";
  rev = "014116c4350085132005871e43363c29bbb1777a";

  arch =
    {
      aarch64-linux = "aarch64";
      i686-linux = "x86";
      x86_64-linux = "x86_64";
    }
    .${buildPlatform.system};

  tccTarget =
    {
      aarch64-linux = "ARM64";
      i686-linux = "I386";
      x86_64-linux = "X86_64";
    }
    .${buildPlatform.system};

  tarball = fetchurl {
    url = "https://codeberg.org/aleksi/tinycc-bootstrappable/archive/${rev}.tar.gz";
    hash = "sha256-Z0S9KtEN0L5+bINscb6llmPVaD12fgPLBKK/W6WUQbg=";
  };
  src =
    (kaem.runCommand "tinycc-bootstrappable-${version}-source" { } ''
      ungz --file ${tarball} --output tinycc.tar
      mkdir -p ''${out}
      cd ''${out}
      untar --file ''${NIX_BUILD_TOP}/tinycc.tar

      # Patch
      cd tinycc-bootstrappable

      cp ${mes-libc}/lib/libtcc1.c lib/libtcc1.c

      # Static link by default
      replace --file libtcc.c --output libtcc.c --match-on "s->ms_extensions = 1;" --replace-with "s->ms_extensions = 1; s->static_link = 1;"
    '')
    + "/tinycc-bootstrappable";

  meta = {
    description = "Tiny C Compiler's bootstrappable fork";
    homepage = "https://gitlab.com/janneke/tinycc";
    license = lib.licenses.lgpl21Only;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];
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
            -D HAVE_LONG_LONG=${if buildPlatform.is64bit then "1" else "0"} \
            -I ${src} \
            -D TCC_TARGET_${tccTarget}=1 \
            -D inline= \
            -D CONFIG_TCCDIR=\"\" \
            -D CONFIG_SYSROOT=\"\" \
            -D CONFIG_TCC_CRTPREFIX=\"{B}\" \
            -D CONFIG_TCC_ELFINTERP=\"/mes/loader\" \
            -D CONFIG_TCC_LIBPATHS=\"{B}\" \
            -D CONFIG_TCC_SYSINCLUDEPATHS=\"${src}/include:${mes-libc}/include\" \
            -D TCC_LIBGCC=\"libc.a\" \
            -D TCC_LIBTCC1=\"libtcc1.a\" \
            -D CONFIG_TCC_LIBTCC1_MES=0 \
            -D CONFIG_TCCBOOT=1 \
            -D CONFIG_TCC_STATIC=1 \
            -D CONFIG_USE_LIBGCC=1 \
            -D TCC_MES_LIBC=1 \
            -D TCC_VERSION=\"0.9.28-${version}\" \
            -D ONE_SOURCE=1 \
            ${src}/tcc.c
          mkdir -p ''${out}/bin
          ${mes.compiler}/bin/mes --no-auto-compile -e main ${mes.srcPost.bin}/bin/mescc.scm -- \
            -L ${mes.libs}/lib \
            -l c+tcc \
            -o ''${out}/bin/tcc \
            tcc.s
        '';

    extraSources = lib.optional buildPlatform.isAarch64 "${src}/lib/lib-arm64.c";
    extraObjects = lib.optional buildPlatform.isAarch64 "lib-arm64.o";

    libs = recompileLibc {
      inherit pname version src;
      tcc = compiler;
      libtccOptions = mes-libc.CFLAGS + " -DTCC_TARGET_${tccTarget}=1";
      libtccSources = [
        "${src}/lib/libtcc1.c"
        "${src}/lib/va_list.c"
      ]
      ++ extraSources;
      libtccObjects = [
        "libtcc1.o"
        "va_list.o"
      ]
      ++ extraObjects;
    };
  };

  # Bootstrap stage build flags obtained from
  # https://gitlab.com/janneke/tinycc/-/blob/80114c4da6b17fbaabb399cc29f427e368309bc8/boot.sh

  tinycc-boot0 = buildTinyccMes {
    pname = "tinycc-boot0";
    inherit src version meta;
    prev = tinycc-boot-mes;
    buildOptions = [
      "-D HAVE_LONG_LONG=1"
      "-D HAVE_SETJMP=1"
    ];
    libtccBuildOptions = [
      "-D HAVE_LONG_LONG=1"
      "-DTCC_TARGET_${tccTarget}=1"
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
      "-DTCC_TARGET_${tccTarget}=1"
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
      "-DTCC_TARGET_${tccTarget}=1"
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
      "-DTCC_TARGET_${tccTarget}=1"
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
    "-DTCC_TARGET_${tccTarget}=1"
  ];
}
