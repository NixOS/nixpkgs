{ pkgs }:
[
  pkgs.coreutils
  pkgs.findutils
  pkgs.diffutils
  pkgs.gnused
  pkgs.gnugrep
  pkgs.gawk
  pkgs.gnutar
  pkgs.gzip
  pkgs.bzip2.bin
  pkgs.gnumake
  pkgs.bash
  pkgs.patch
  pkgs.xz.bin

  # The `file` command is added here because an enormous number of
  # packages have a vendored dependency upon `file` in their
  # `./configure` script, due to libtool<=2.4.6, or due to
  # libtool>=2.4.7 in which the package author decided to set FILECMD
  # when running libtoolize.  In fact, file-5.4.6 *depends on itself*
  # and tries to invoke `file` from its own ./configure script.
  pkgs.file
]
