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

  version = "unstable-2023-04-20";
  rev = "86f3d8e33105435946383aee52487b5ddf918140";

  tarball = fetchurl {
    url = "https://repo.or.cz/tinycc.git/snapshot/${rev}.tar.gz";
    sha256 = "11idrvbwfgj1d03crv994mpbbbyg63j1k64lw1gjy7mkiifw2xap";
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
    '')
    + "/tinycc-${builtins.substring 0 7 rev}";

  meta = with lib; {
    description = "Small, fast, and embeddable C compiler and interpreter";
    homepage = "https://repo.or.cz/w/tinycc.git";
    license = licenses.lgpl21Only;
    maintainers = teams.minimal-bootstrap.members;
    platforms = [ "i686-linux" ];
  };

  tccdefs = kaem.runCommand "tccdefs-${version}" { } ''
    mkdir ''${out}
    ${tinycc-bootstrappable.compiler}/bin/tcc \
      -B ${tinycc-bootstrappable.libs}/lib \
      -DC2STR \
      -o c2str \
      ${src}/conftest.c
    ./c2str ${src}/include/tccdefs.h ''${out}/tccdefs_.h
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
  libtccBuildOptions = [
    "-D HAVE_FLOAT=1"
    "-D HAVE_LONG_LONG=1"
    "-D CONFIG_TCC_PREDEFS=1"
    "-I ${tccdefs}"
    "-D CONFIG_TCC_SEMLOCK=0"
  ];
}
