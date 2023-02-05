{ lib, stdenv, fetchFromGitHub, CoreServices, CoreFoundation, fetchpatch }:

stdenv.mkDerivation rec {
  version = "1.1";
  pname = "qgrep";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "qgrep";
    rev = "v${version}";
    sha256 = "046ccw34vz2k5jn6gyxign5gs2qi7i50jy9b74wqv7sjf5zayrh0";
    fetchSubmodules = true;
  };

  patches = lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://github.com/zeux/qgrep/commit/21c4d1a5ab0f0bdaa0b5ca993c1315c041418cc6.patch";
      sha256 = "0wpxzrd9pmhgbgby17vb8279xwvkxfdd99gvv7r74indgdxqg7v8";
    })
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices CoreFoundation ];

  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
    # Needed with GCC 12 but breaks on darwin (with clang) or older gcc
    "-Wno-error=mismatched-new-delete"
  ];

  postPatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace Makefile \
      --replace "-msse2" "" --replace "-DUSE_SSE2" ""
  '';

  installPhase = ''
    install -Dm755 qgrep $out/bin/qgrep
  '';

  meta = with lib; {
    description = "Fast regular expression grep for source code with incremental index updates";
    homepage = "https://github.com/zeux/qgrep";
    license = licenses.mit;
    maintainers = [ maintainers.yrashk ];
    platforms = platforms.all;
  };
}
