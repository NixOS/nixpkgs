{ lib, stdenv, fetchurl, perl, fuse }:

stdenv.mkDerivation rec {
  version = "0.7";
  pname = "chunkfs";

  src = fetchurl {
    url = "https://chunkfs.florz.de/chunkfs_${version}.tar.gz";
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
    homepage = "http://chunkfs.florz.de/";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
  };
}
