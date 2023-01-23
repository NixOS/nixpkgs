{ lib, stdenv, fetchFromGitHub, leptonica, zlib, libwebp, giflib, libjpeg, libpng, libtiff }:

stdenv.mkDerivation rec {
  pname = "jbig2enc";
  version = "0.28";

  src = fetchFromGitHub {
    owner = "agl";
    repo = "jbig2enc";
    rev = "${version}-dist";
    hash = "sha256-Y3IVTjvO5tqn/O076y/llnTyenKpbx1WyT/JFZ/s0VY=";
  };

  propagatedBuildInputs = [ leptonica zlib libwebp giflib libjpeg libpng libtiff ];

  patches = [
    # https://github.com/agl/jbig2enc/commit/53ce5fe7e73d7ed95c9e12b52dd4984723f865fa
    ./53ce5fe7e73d7ed95c9e12b52dd4984723f865fa.patch
  ];

  # This is necessary, because the resulting library has
  # /tmp/nix-build-jbig2enc/src/.libs before /nix/store/jbig2enc/lib
  # in its rpath, which means that patchelf --shrink-rpath removes
  # the /nix/store one.  By cleaning up before fixup, we ensure that
  # the /tmp/nix-build-jbig2enc/src/.libs directory is gone.
  preFixup = ''
    make clean
  '';

  meta = {
    description = "Encoder for the JBIG2 image compression format";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
