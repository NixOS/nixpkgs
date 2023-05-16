{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool, fuse,
  pkg-config, lz4, xz, zlib, lzo, zstd }:

stdenv.mkDerivation rec {

  pname = "squashfuse";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.1.105";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vasi";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-gK1k1Ooue3HLtBmPFMZdW4h2Ee1Uy4T26EOBeQICQpM=";
=======
    sha256 = "sha256-RIhDXzpmrYUOwj5OYzjWKJw0cwE+L3t/9pIkg/hFXA0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
