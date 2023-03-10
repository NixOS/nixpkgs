{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool, fuse,
  pkg-config, lz4, xz, zlib, lzo, zstd }:

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.1.105";

  src = fetchFromGitHub {
    owner = "vasi";
    repo = pname;
    rev = version;
    sha256 = "sha256-RIhDXzpmrYUOwj5OYzjWKJw0cwE+L3t/9pIkg/hFXA0=";
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
