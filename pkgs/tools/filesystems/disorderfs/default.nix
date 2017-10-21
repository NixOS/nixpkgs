{ stdenv, fetchurl, pkgconfig, fuse, attr, asciidoc }:

stdenv.mkDerivation rec {
  name = "disorderfs-${version}";
  version = "0.5.1";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/d/disorderfs/disorderfs_${version}.orig.tar.gz";
    sha256 = "0nnxk0qqww16ra52mi5giw50zpssvan62nkig5dcxvgcvv51akik";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ pkgconfig asciidoc ];

  buildInputs = [ fuse attr ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "An overlay FUSE filesystem that introduces non-determinism into filesystem metadata";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
