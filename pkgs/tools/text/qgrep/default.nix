{ stdenv, fetchFromGitHub, CoreServices, CoreFoundation, fetchpatch }:

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

  patches = stdenv.lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://github.com/zeux/qgrep/commit/21c4d1a5ab0f0bdaa0b5ca993c1315c041418cc6.patch";
      sha256 = "0wpxzrd9pmhgbgby17vb8279xwvkxfdd99gvv7r74indgdxqg7v8";
    })
  ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices CoreFoundation ];

  postPatch = stdenv.lib.optionalString stdenv.isAarch64 ''
    substituteInPlace Makefile \
      --replace "-msse2" "" --replace "-DUSE_SSE2" ""
  '';

  installPhase = '' 
    install -Dm755 qgrep $out/bin/qgrep
  '';

  meta = with stdenv.lib; {
    description = "Fast regular expression grep for source code with incremental index updates";
    homepage = https://github.com/zeux/qgrep;
    license = licenses.mit;
    maintainers = [ maintainers.yrashk ];
    platforms = platforms.all;
  };
}
