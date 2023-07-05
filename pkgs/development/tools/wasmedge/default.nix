{ lib
, fetchFromGitHub
, llvmPackages_12
, boost
, cmake
, spdlog
, libxml2
, libffi
, Foundation
, testers
}:

let
  llvmPackages = llvmPackages_12;
  stdenv = llvmPackages.stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmedge";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    rev = finalAttrs.version;
    sha256 = "sha256-pBaa90jvR4tLgVOBZEJOEUY2+VnBmdSN5kkJMB8wdUA=";
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
    "-DCMAKE_BUILD_TYPE=Release"
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
    description = "A lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.all;
  };
})
