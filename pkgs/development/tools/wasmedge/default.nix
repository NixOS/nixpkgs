{ lib
, fetchFromGitHub
, llvmPackages
, boost
, cmake
, gtest
, spdlog
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "wasmedge";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    rev = version;
    sha256 = "sha256-P2Y2WK6G8aEK1Q4hjrS9X+2WbOfy4brclB/+SWP5LTM=";
  };

  buildInputs = [
    boost
    spdlog
    llvmPackages.llvm
  ];

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
