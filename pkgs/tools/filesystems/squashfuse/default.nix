{ stdenv, fetchFromGitHub, autoreconfHook, libtool, fuse,
  pkgconfig, lz4, xz, zlib, lzo, zstd }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "squashfuse";
  version = "0.1.103";

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = "https://github.com/vasi/squashfuse";
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
    license = "BSD-2-Clause";
  };

  # platforms.darwin should be supported : see PLATFORMS file in src.
  # we could use a nix fuseProvider, and let the derivation choose the OS
  # specific implementation.

  src = fetchFromGitHub {
    owner = "vasi";
    repo  = pname;
    rev = "540204955134eee44201d50132a5f66a246bcfaf";
    sha256 = "062s77y32p80vc24a79z31g90b9wxzvws1xvicgx5fn1pd0xa0q6";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig ];
  buildInputs = [ lz4 xz zlib lzo zstd fuse ];
}
