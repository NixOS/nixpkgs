{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool, fuse,
  pkg-config, lz4, xz, zlib, lzo, zstd }:

with lib;

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.1.103";

  src = fetchFromGitHub {
    owner = "vasi";
    repo  = pname;
    rev = "540204955134eee44201d50132a5f66a246bcfaf";
    sha256 = "062s77y32p80vc24a79z31g90b9wxzvws1xvicgx5fn1pd0xa0q6";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkg-config ];
  buildInputs = [ lz4 xz zlib lzo zstd fuse ];

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = "https://github.com/vasi/squashfuse";
    maintainers = [  ];
    platforms = platforms.unix;
    license = "BSD-2-Clause";
  };
}
