{ stdenv, fetchurl, perl, fuse }:

stdenv.mkDerivation rec {
  version = "0.7";
  name = "chunkfs-${version}";

  src = fetchurl {
    url = "http://chunkfs.florz.de/chunkfs_${version}.tar.gz";
    sha256 = "4c168fc2b265a6ba34afc565707ea738f34375325763c0596f2cfa1c9b8d40f1";
  };

  buildInputs = [perl fuse];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = {
    description = "FUSE filesystems for viewing chunksync-style directory trees as a block device and vice versa";
    homepage = http://chunkfs.florz.de/;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux;
  };
}
