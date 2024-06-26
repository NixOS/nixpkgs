{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "zopfli";
  version = "1.0.3";
  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "zopfli";
    rev = "${pname}-${version}";
    name = "${pname}-${version}-src";
    sha256 = "0dr8n4j5nj2h9n208jns56wglw59gg4qm3s7c6y3hs75d0nnkhm4";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/zopfli ../README*
    cp $src/src/zopfli/*.h $dev/include/
  '';

  meta = with lib; {
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
    maintainers = with maintainers; [
      bobvanderlinden
      edef
    ];
  };
}
