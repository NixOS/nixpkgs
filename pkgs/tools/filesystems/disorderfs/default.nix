{ stdenv, fetchurl, pkgconfig, fuse, attr, asciidoc }:

stdenv.mkDerivation rec {
  name = "disorderfs-${version}";
  version = "0.5.6";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/d/disorderfs/disorderfs_${version}.orig.tar.bz2";
    sha256 = "0xlsl6cw1p0d92crknrcf4iabgig0185dzp80qxh9iyjy42d27gk";
  };

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
