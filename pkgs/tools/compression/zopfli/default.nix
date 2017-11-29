{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  name = "zopfli-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zopfli";
    rev = name;
    name = "${name}-src";
    sha256 = "1dclll3b5azy79jfb8vhb21drivi7vaay5iw0lzs4lrh6dgyvg6y";
  };

  patches = [
    (fetchpatch {
      sha256 = "07z6df1ahx40hnsrcs5mx3fc58rqv8fm0pvyc7gb7kc5mwwghvvp";
      name = "Fix-invalid-read-outside-allocated-memory.patch";
      url = "https://github.com/google/zopfli/commit/9429e20de3885c0e0d9beac23f703fce58461021.patch";
    })
    (fetchpatch {
      sha256 = "07m8q5kipr84cg8i1l4zd22ai9bmdrblpdrsc96llg7cm51vqdqy";
      name = "zopfli-bug-and-typo-fixes.patch";
      url = "https://github.com/google/zopfli/commit/7190e08ecac2446c7c9157cfbdb7157b18912a92.patch";
    })
    (fetchpatch {
      name = "zopfli-cmake.patch";
      url = "https://github.com/google/zopfli/commit/7554e4d34e7000b0595aa606e7d72357cf46ba86.patch";
      sha256 = "1pvfhir2083v1l042a4dy5byqdmad7sxnd4jrprl2hzzb2avxbbn";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" ];

  installPhase = ''
    install -D -t $out/bin zopfli*
    install -d $out/lib
    cp -d libzopfli* $out/lib
    install -Dm444 -t $out/share/doc/zopfli ../README*
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Very good, but slow, deflate or zlib compression";
    longDescription = ''
      Zopfli Compression Algorithm is a compression library programmed
      in C to perform very good, but slow, deflate or zlib compression.

      This library can only compress, not decompress. Existing zlib or
      deflate libraries can decompress the data.
    '';
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ bobvanderlinden nckx ];
  };
}
