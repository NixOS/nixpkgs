{ stdenv, fetchurl, leptonica, zlib, libwebp, giflib, libjpeg, libpng, libtiff }:

stdenv.mkDerivation {
  name = "jbig2enc-0.28";

  src = fetchurl {
    url = https://github.com/agl/jbig2enc/archive/0.28-dist.tar.gz;
    sha256 = "1wc0lmqz4jag3rhhk1xczlqpfv2qqp3fz7wzic2lba3vsbi1rrw3";
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
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
  };
}
