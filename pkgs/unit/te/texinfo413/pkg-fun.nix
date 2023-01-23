{ stdenv, fetchurl, texinfo, ncurses, xz }:

stdenv.mkDerivation rec {
  pname = "texinfo";
  version = "4.13a";

  src = fetchurl {
    url = "mirror://gnu/texinfo/${pname}-${version}.tar.lzma";
    sha256 = "1rf9ckpqwixj65bw469i634897xwlgkm5i9g2hv3avl6mv7b0a3d";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ xz ];

  # Disabled because we don't have zdiff in the stdenv bootstrap.
  #doCheck = true;

  meta = texinfo.meta // { branch = version; };
}
