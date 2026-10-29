{
  lib,
  mkDerivation,
  libxo,
  libutil,
  libmemstat,
  libjail,
  libnetgraph,
}:
mkDerivation {
  path = "usr.bin/netstat";

  buildInputs = [
    libxo
    libutil
    libmemstat
    libjail
    libnetgraph
  ];

  meta.platforms = lib.platforms.freebsd;
  meta.mainProgram = "netstat";
}
