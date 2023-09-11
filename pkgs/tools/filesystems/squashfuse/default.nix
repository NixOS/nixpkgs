{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool, fuse,
  pkg-config, lz4, xz, zlib, lzo, zstd }:

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "vasi";
    repo = pname;
    rev = version;
    sha256 = "sha256-gK1k1Ooue3HLtBmPFMZdW4h2Ee1Uy4T26EOBeQICQpM=";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkg-config ];
  buildInputs = [ lz4 xz zlib lzo zstd fuse ];

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = "https://github.com/vasi/squashfuse";
    maintainers = [  ];
    platforms = lib.platforms.unix;
    license = "BSD-2-Clause";
  };
}
