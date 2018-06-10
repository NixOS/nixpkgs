{ stdenv, fetchurl, pkgconfig, fuse, attr, asciidoc }:

stdenv.mkDerivation rec {
  name = "disorderfs-${version}";
  version = "0.5.3";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/d/disorderfs/disorderfs_${version}.orig.tar.gz";
    sha256 = "1zx6248cwfcci5555sk9iwl9lz6x8kzc9qgiq4jv04zjiapivdnq";
  };

  nativeBuildInputs = [ pkgconfig asciidoc ];

  buildInputs = [ fuse attr ];

  sourceRoot = ".";

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "An overlay FUSE filesystem that introduces non-determinism into filesystem metadata";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
