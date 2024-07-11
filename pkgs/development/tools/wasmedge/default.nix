{ lib
, stdenv
, fetchFromGitHub
, llvmPackages
, boost
, cmake
, spdlog
, libxml2
, libffi
, Foundation
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wasmedge";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    rev = finalAttrs.version;
    sha256 = "sha256-JPuJIM5OU1qCvFZEQ3gDNBZsIiJijtWLAVGp54z7lt0=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.lld
  ];

  buildInputs = [
    boost
    spdlog
    llvmPackages.llvm
    libxml2
    libffi
  ] ++ lib.optionals stdenv.isDarwin [
    Foundation
  ];

  cmakeFlags = [
    "-DWASMEDGE_BUILD_TESTS=OFF" # Tests are downloaded using git
  ] ++ lib.optionals stdenv.isDarwin [
    "-DWASMEDGE_FORCE_DISABLE_LTO=ON"
  ];

  postPatch = ''
    echo -n $version > VERSION
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    homepage = "https://wasmedge.org/";
    license = with licenses; [ asl20 ];
    description = "Lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.all;
  };
})
