{ lib, stdenv, fetchFromGitHub, fuse3, bzip2, zlib, attr, cmake }:

stdenv.mkDerivation {
  pname = "apfs-fuse-unstable";
  version = "2023-01-04";

  src = fetchFromGitHub {
    owner  = "sgan81";
    repo   = "apfs-fuse";
    rev    = "1f041d7af5df5423832e54e9f358fd9234773fcc";
    hash = "sha256-EmhCvIwyVJvib/ZHzCsULh8bOjhzKRu47LojX+L40qQ=";
    fetchSubmodules = true;
  };

  buildInputs = [ fuse3 bzip2 zlib attr ];
  nativeBuildInputs = [ cmake ];

  postFixup = ''
    ln -s $out/bin/apfs-fuse $out/bin/mount.fuse.apfs-fuse
  '';

  meta = with lib; {
    homepage    = "https://github.com/sgan81/apfs-fuse";
    description = "FUSE driver for APFS (Apple File System)";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ ealasu ];
    platforms   = platforms.linux;
  };

}
