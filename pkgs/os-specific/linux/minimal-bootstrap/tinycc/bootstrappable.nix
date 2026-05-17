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

  version = "unstable-2024-07-07";
  rev = "ea3900f6d5e71776c5cfabcabee317652e3a19ee";

  arch =
    {
      i686-linux = "x86";
      x86_64-linux = "x86_64";
    }
    .${buildPlatform.system};

  tccTarget =
    {
      i686-linux = "I386";
      x86_64-linux = "X86_64";
    }
    .${buildPlatform.system};

  tarball = fetchurl {
    url = "https://gitlab.com/janneke/tinycc/-/archive/${rev}/tinycc-${rev}.tar.gz";
    sha256 = "sha256-16JBGJATAWP+lPylOi3+lojpdv0SR5pqyxOV2PiVx0A=";
  };
  src =
    (kaem.runCommand "tinycc-bootstrappable-${version}-source" { } ''
      ungz --file ${tarball} --output tinycc.tar
      mkdir -p ''${out}
      cd ''${out}
      untar --file ''${NIX_BUILD_TOP}/tinycc.tar

      # Patch
      cd tinycc-${rev}

      cp ${mes-libc}/lib/libtcc1.c lib/libtcc1.c

      # Static link by default
      replace --file libtcc.c --output libtcc.c --match-on "s->ms_extensions = 1;" --replace-with "s->ms_extensions = 1; s->static_link = 1;"

      # TODO: may not need following patches for mes 0.28.
      # Or maybe we don't need tinycc-bootstrappable for mes 0.28?

      # mes-libc depends on max_align_t in stddef.h, which is not provided by tinycc-boot
      replace --file include/stddef.h --output include/stddef.h --match-on "void *alloca" --replace-with "
        typedef union { long double ld; long long ll; } max_align_t;
        void *alloca
      "
      # VLA is broken in mescc 0.27.1. alloca is not available either. Let's just use malloc and leak on x86_64.
      replace --file x86_64-gen.c --output x86_64-gen.c --match-on "char _onstack[nb_args], *onstack = _onstack;" --replace-with "char *onstack = tcc_malloc(nb_args);"

      # Abort is not provided by mescc
      replace --file x86_64-gen.c --output x86_64-gen.c --match-on "abort();" --replace-with "/* abort(); */"

      # Work around bug in mescc.
      replace --file x86_64-gen.c --output x86_64-gen.c --match-on "g(vtop->c.i & (ll ? 63 : 31));" --replace-with "if (ll) g(vtop->c.i & 63); else g(vtop->c.i & 31);"

      # Normally tinycc only performs relocations on the PLT when creating a dynamically-linked executable.
      # This is fine for most targets because a PLT is not generated. But on x86_64 we do generate a PLT and hence
      # we must assure plt->got references are appropriately relocated.
      # This patch is applied even if we aren't targeting x86_64. Because there's no PLT outside x86_64, it's basically a no-op.
      replace --file tccelf.c --output tccelf.c --match-on "fill_got(s1);" --replace-with "
      {
        fill_got(s1);
        relocate_plt(s1);
      }
      "
    '')
    + "/tinycc-${rev}";

  meta = {
    description = "Tiny C Compiler's bootstrappable fork";
    homepage = "https://gitlab.com/janneke/tinycc";
    license = lib.licenses.lgpl21Only;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = [
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

    libs = recompileLibc {
      inherit pname version src;
      tcc = compiler;
      libtccOptions = mes-libc.CFLAGS + " -DTCC_TARGET_${tccTarget}=1";
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
