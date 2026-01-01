# Build steps adapted from https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/tcc-0.9.27/tcc-0.9.27.kaem
#
# SPDX-FileCopyrightText: 2021-22 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  lib,
  fetchurl,
  callPackage,
  kaem,
  tinycc-bootstrappable,
}:
let
  inherit (callPackage ./common.nix { }) buildTinyccMes;

<<<<<<< HEAD
  version = "unstable-2025-12-03";
  rev = "cb41cbfe717e4c00d7bb70035cda5ee5f0ff9341";

  tarball = fetchurl {
    url = "https://repo.or.cz/tinycc.git/snapshot/${rev}.tar.gz";
    hash = "sha256-MRuqq3TKcfIahtUWdhAcYhqDiGPkAjS8UTMsDE+/jGU=";
=======
  version = "unstable-2023-04-20";
  rev = "86f3d8e33105435946383aee52487b5ddf918140";

  tarball = fetchurl {
    url = "https://repo.or.cz/tinycc.git/snapshot/${rev}.tar.gz";
    sha256 = "11idrvbwfgj1d03crv994mpbbbyg63j1k64lw1gjy7mkiifw2xap";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  src =
    (kaem.runCommand "tinycc-${version}-source" { } ''
      ungz --file ${tarball} --output tinycc.tar
      mkdir -p ''${out}
      cd ''${out}
      untar --file ''${NIX_BUILD_TOP}/tinycc.tar

      # Patch
      cd tinycc-${builtins.substring 0 7 rev}
      # Static link by default
      replace --file libtcc.c --output libtcc.c --match-on "s->ms_extensions = 1;" --replace-with "s->ms_extensions = 1; s->static_link = 1;"
<<<<<<< HEAD
      replace --file i386-asm.c --output i386-asm.c --match-on "switch(size)" --replace-with "if (reg >= 8) { cstr_printf(add_str, \"%%r%d%c\", reg, (size == 1) ? 'b' : ((size == 2) ? 'w' : ((size == 4) ? 'd' : ' '))); return; } switch(size)"

      # If performing ptr + (-1) for example, the offset should be ptrdiff_t and not size_t
      replace --file tccgen.c --output tccgen.c --match-on "vpush_type_size(pointed_type(&vtop[-1].type), &align);" --replace-with "vpush_type_size(pointed_type(&vtop[-1].type), &align); if (!(vtop[-1].type.t & VT_UNSIGNED)) gen_cast_s(VT_PTRDIFF_T);"
    '')
    + "/tinycc-${builtins.substring 0 7 rev}";

  meta = {
    description = "Small, fast, and embeddable C compiler and interpreter";
    homepage = "https://repo.or.cz/w/tinycc.git";
    license = lib.licenses.lgpl21Only;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };

  config_h = builtins.toFile "config_tccdefs.h" ''
    "#include <mes/config.h>\n"
  '';
=======
    '')
    + "/tinycc-${builtins.substring 0 7 rev}";

  meta = with lib; {
    description = "Small, fast, and embeddable C compiler and interpreter";
    homepage = "https://repo.or.cz/w/tinycc.git";
    license = licenses.lgpl21Only;
    teams = [ teams.minimal-bootstrap ];
    platforms = [ "i686-linux" ];
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  tccdefs = kaem.runCommand "tccdefs-${version}" { } ''
    mkdir ''${out}
    ${tinycc-bootstrappable.compiler}/bin/tcc \
      -B ${tinycc-bootstrappable.libs}/lib \
      -DC2STR \
      -o c2str \
      ${src}/conftest.c
<<<<<<< HEAD
    ./c2str ${src}/include/tccdefs.h tccdefs_.h
    catm ''${out}/tccdefs_.h tccdefs_.h ${config_h}
=======
    ./c2str ${src}/include/tccdefs.h ''${out}/tccdefs_.h
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  tinycc-mes-boot = buildTinyccMes {
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
<<<<<<< HEAD
    libtccSources = [
      "${src}/lib/libtcc1.c"
      "${src}/lib/alloca.S"
    ];
    libtccObjects = [
      "libtcc1.o"
      "alloca.o"
    ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    libtccBuildOptions = [
      "-D HAVE_FLOAT=1"
      "-D HAVE_LONG_LONG=1"
      "-D CONFIG_TCC_PREDEFS=1"
      "-I ${tccdefs}"
      "-D CONFIG_TCC_SEMLOCK=0"
    ];
  };
in
buildTinyccMes {
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
<<<<<<< HEAD
  libtccSources = [
    "${src}/lib/libtcc1.c"
    "${src}/lib/alloca.S"
  ];
  libtccObjects = [
    "libtcc1.o"
    "alloca.o"
  ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libtccBuildOptions = [
    "-D HAVE_FLOAT=1"
    "-D HAVE_LONG_LONG=1"
    "-D CONFIG_TCC_PREDEFS=1"
    "-I ${tccdefs}"
    "-D CONFIG_TCC_SEMLOCK=0"
  ];
}
