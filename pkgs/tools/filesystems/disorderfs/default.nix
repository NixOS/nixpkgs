{ stdenv, fetchurl, pkgconfig, fuse, attr, asciidoc }:

stdenv.mkDerivation rec {
  name = "disorderfs-${version}";
  version = "0.5.2";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/d/disorderfs/disorderfs_${version}.orig.tar.bz2";
    sha256 = "0jdadb1ppd5qrnngpjv14az32gwslag2wwv1k8rs29iqlfy38cjf";
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
