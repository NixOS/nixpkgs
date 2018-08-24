{ stdenv, fetchFromGitHub, autoreconfHook, libtool, fuse,
  pkgconfig, lz4, xz, zlib, lzo, zstd }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.1.103";
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
    rev = "540204955134eee44201d50132a5f66a246bcfaf";
    sha256 = "07jv4qjjz9ky3mw3p5prgs19g1bna9dcd7jjdz8083s1wyipdgcq";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig ];
  buildInputs = [ lz4 xz zlib lzo zstd fuse ];
}
