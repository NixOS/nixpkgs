{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  name = "zopfli-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zopfli";
    rev = name;
    name = "${name}-src";
    sha256 = "1l551hx2p4qi0w9lk96qklbv6ll68gxbah07fhqx1ly28rv5wy9y";
  };

  patches = [
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
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}
