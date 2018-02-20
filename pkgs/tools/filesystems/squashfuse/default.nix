{ stdenv, fetchFromGitHub, fetchpatch, automake, autoreconfHook, libtool, fuse,
  pkgconfig, pcre, lz4, xz, zlib, lzo, zstd }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "unstable-2018-02-20";
  name = "${pname}-${version}";

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
    rev = "3f4a93f373796e88f7eee3a0c005ef60cb395d30";
    sha256 = "07jv4qjjz9ky3mw3p5prgs19g1bna9dcd7jjdz8083s1wyipdgcq";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig ];
  buildInputs = [ lz4 xz zlib lzo zstd fuse ];
}
