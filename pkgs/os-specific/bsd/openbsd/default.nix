{ fetchcvs, netBSDDerivation, compat, libcurses, libterminfo }:

let
  fetchOpenBSD = path: version: sha256: fetchcvs {
    cvsRoot = "anoncvs@anoncvs.ca.openbsd.org:/cvs";
    module = "src/${path}";
    inherit sha256;
    tag = "OPENBSD_${builtins.replaceStrings ["."] ["_"] version}";
  };

  # OpenBSD is a fork of NetBSD
  # We can build it with minimal changes
  openBSDDerivation = attrs: netBSDDerivation (attrs // {
    name = "${attrs.pname or (baseNameOf attrs.path)}-openbsd-${attrs.version}";
    src = fetchOpenBSD attrs.path attrs.version attrs.sha256;
  });

in {

  mg = openBSDDerivation {
    path = "usr.bin/mg";
    version = "6.3";
    sha256 = "0n3hwa81c2mcjwbmidrbvi1l25jh8hy939kqrigbv78jixpynffc";
    buildInputs = [ compat libcurses libterminfo ];
    patchPhase = ''
      NIX_CFLAGS_COMPILE+=" -I$BSDSRCDIR/sys"
      substituteInPlace fileio.c \
        --replace "bp->b_fi.fi_mtime.tv_sec != sb.st_mtimespec.tv_sec" "bp->b_fi.fi_mtime.tv_sec != sb.st_mtim.tv_sec" \
        --replace "bp->b_fi.fi_mtime.tv_nsec != sb.st_mtimespec.tv_nsec" "bp->b_fi.fi_mtime.tv_nsec != sb.st_mtim.tv_nsec" \
        --replace "bp->b_fi.fi_mtime = sb.st_mtimespec" "bp->b_fi.fi_mtime = sb.st_mtim"
      substituteInPlace Makefile \
        --replace "-o root -g wheel" "" \
        --replace '-o ''${DOCOWN} -g ''${DOCGRP}' ""
    '';
    NIX_CFLAGS_COMPILE = [ "-DTCSASOFT=0x10" "-Dpledge(a,b)=0" ];
    preBuild = ''
      cc -c $BSDSRCDIR/lib/libc/stdlib/strtonum.c -o strtonum.o
      NIX_LDFLAGS+=" strtonum.o"
    '';
    extraPaths = [
      (fetchOpenBSD "sys/sys/tree.h" "6.3" "0rimh41wn9wz5m510zk9i27z3s450qqgq2k5xn8kp3885hygbcj9")
      (fetchOpenBSD "sys/sys/_null.h" "6.3" "0l2rgg9ai4ivfl07zmbqli19vnm3lj7qkxpikqplmzrfp36qpzgr")
      (fetchOpenBSD "sys/sys/_null.h" "6.3" "0l2rgg9ai4ivfl07zmbqli19vnm3lj7qkxpikqplmzrfp36qpzgr")
      (fetchOpenBSD "lib/libc/stdlib/strtonum.c" "6.3" "0xn3qxvb3g76hz698sjkf85p07zrcdv2g31inp8caqw2mpk6jadv")
     ];
  };

}
