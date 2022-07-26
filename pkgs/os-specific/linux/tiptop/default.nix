{ lib, stdenv, fetchurl, fetchpatch, libxml2, ncurses, bison, flex }:

stdenv.mkDerivation rec {
  pname = "tiptop";
  version = "2.3.1";

  src = fetchurl {
    url = "${meta.homepage}/releases/${pname}-${version}.tar.gz";
    sha256 = "10j1138y3cj3hsmfz4w0bmk90523b0prqwi9nhb4z8xvjnf49i2i";
  };

  patches = [
    (fetchpatch {
      name = "reproducibility.patch";
      url = "https://salsa.debian.org/debian/tiptop/raw/debian/2.3.1-1/debian/patches/0001-fix-reproducibility-of-build-process.patch";
      sha256 = "116l7n3nl9lj691i7j8x0d0za1i6zpqgghw5d70qfpb17c04cblp";
    })

    # Pull upstream patch for ncurses-6.3
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://gitlab.inria.fr/rohou/tiptop/-/commit/a78234c27fdd62fed09430d998950e49e11a1832.patch";
      sha256 = "1k55agdri7iw3gwm4snj3ps62qzmxlqr6s0868l8qamjw38z9g00";
    })
  ];

  postPatch = ''
    substituteInPlace ./configure --replace -lcurses -lncurses
  '';

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ libxml2 ncurses ];

  NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  meta = with lib; {
    description = "Performance monitoring tool for Linux";
    homepage = "http://tiptop.gforge.inria.fr";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}

