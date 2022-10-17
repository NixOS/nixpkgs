{ lib, stdenv, fetchFromGitHub, fuse3, bzip2, zlib, attr, cmake }:

stdenv.mkDerivation {
  pname = "apfs-fuse-unstable";
  version = "2020-09-28";

  src = fetchFromGitHub {
    owner  = "sgan81";
    repo   = "apfs-fuse";
    rev    = "ee71aa5c87c0831c1ae17048951fe9cd7579c3db";
    sha256 = "0wvsx708km1lnhghny5y69k694x0zy8vlbndswkb7sq81j1r6kwx";
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
