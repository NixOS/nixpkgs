{ lib
, fetchFromGitHub
, llvmPackages
, boost
, cmake
, gtest
, spdlog
, CoreServices
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "wasmedge";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    rev = version;
    sha256 = "sha256-SJi8CV0sa+g+Ngvdw8+SxV3kHqoiKBhYUwDLZM4+jX0=";
  };

  buildInputs =
    [
      boost
      spdlog
      llvmPackages.llvm
    ]
    ++ lib.optionals llvmPackages.stdenv.isDarwin [ CoreServices ];

  nativeBuildInputs = [ cmake llvmPackages.lld ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DWASMEDGE_BUILD_TESTS=OFF" # Tests are downloaded using git
  ];

  meta = with lib; {
    homepage = "https://wasmedge.org/";
    license = with licenses; [ asl20 ];
    description = "A lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    maintainers = with maintainers; [ dit7ya ];
  };
}
