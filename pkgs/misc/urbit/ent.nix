{ urbit-src, lib, stdenv, enableParallelBuilding ? true }:

stdenv.mkDerivation {
  name = "ent";
  src = lib.cleanSource "${urbit-src}/pkg/ent";

  postPatch = ''
    patchShebangs ./configure
  '';

  installFlags = [ "PREFIX=$(out)" ];

  inherit enableParallelBuilding;
}
