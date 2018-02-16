{ stdenv, fetchFromGitHub, fetchpatch, automake, autoreconfHook, libtool, fuse,
  pkgconfig, pcre, lz4, xz, zlib, lzo, zstd }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.1.101";
  rev = "371e4bee9caa254d842913df9bdbcc795c5b342c";
  short_rev = "${builtins.substring 0 7 rev}";
  name = "${pname}-${version}-${short_rev}";

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = https://github.com/vasi/squashfuse;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
    license = "BSD-2-Clause";
  };

  # platforms.darwin should be supported : see PLATFORMS file in src.
  # we could use a nix fuseProvider, and let the derivation choose the OS
  # specific implementation.

  src = fetchFromGitHub {
    owner = "vasi";
    repo  = "${pname}";
    rev = "${rev}";
    sha256 = "0i9p8r1c128hzy0cwmga1x7q8zk7kw68mh8li5ipfz8zba60d7vz";
  };

  patches = [
	(fetchpatch {
	  url = "https://github.com/vasi/squashfuse/commit/0c44cb2abe402d6e352dd47ac8b7e7495c7c2a6f.patch";
	  sha256 = "0z53p7pi3ap05n0bxhmka4sz12cw2cjjvc7xn9jppbyynfzx32m0";
	})
  ];

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig ];
  buildInputs = [ lz4 xz zlib lzo zstd fuse ];
}
