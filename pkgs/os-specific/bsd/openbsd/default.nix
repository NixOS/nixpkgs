{ fetchcvs, netBSDDerivation, compat, libcurses, libressl }:

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
    buildInputs = [ compat libcurses ];
    patchPhase = ''
      NIX_CFLAGS_COMPILE+=" -I$BSDSRCDIR/sys"
    '';
    extraPaths = [
      (fetchOpenBSD "sys/sys/tree.h" "6.3" "0rimh41wn9wz5m510zk9i27z3s450qqgq2k5xn8kp3885hygbcj9")
      (fetchOpenBSD "sys/sys/_null.h" "6.3" "0l2rgg9ai4ivfl07zmbqli19vnm3lj7qkxpikqplmzrfp36qpzgr")
    ];
  };

  nc = openBSDDerivation {
    path = "usr.bin/nc";
    version = "6.3";
    sha256 = "0fmnh6ccxab0qvhmgspyd3wra1ps2516i0j6hwkvna2lcny20xvr";
    patches = [ ./nc.patch ];
    buildInputs = [ compat libressl ];
  };

}
