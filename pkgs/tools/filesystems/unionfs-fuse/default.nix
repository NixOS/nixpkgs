{ stdenv, fetchurl, cmake, fuse }:

stdenv.mkDerivation rec {
  name = "unionfs-fuse-0.26";

  src = fetchurl {
    url = "http://podgorny.cz/unionfs-fuse/releases/${name}.tar.xz";

    sha256 = "0qpnr4czgc62vsfnmv933w62nq3xwcbnvqch72qakfgca75rsp4d";
  };

  buildInputs = [ cmake fuse ];
}
