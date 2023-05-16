{ lib
, fetchFromGitHub
<<<<<<< HEAD
, llvmPackages_12
, boost
, cmake
=======
, llvmPackages
, boost
, cmake
, gtest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, spdlog
, libxml2
, libffi
, Foundation
<<<<<<< HEAD
, testers
}:

let
  llvmPackages = llvmPackages_12;
  stdenv = llvmPackages.stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmedge";
  version = "0.13.3";
=======
}:

let
  stdenv = llvmPackages.stdenv;
in
stdenv.mkDerivation rec {
  pname = "wasmedge";
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
<<<<<<< HEAD
    rev = finalAttrs.version;
    sha256 = "sha256-IZMYeuneKtcuvbEVgkF2C3gbxJe7GlXRNEYwpFxtiKA=";
=======
    rev = version;
    sha256 = "sha256-4xoS9d5bV9CqYhYTK1wzlA2PKMbsOote6eAeT56ch08=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  postPatch = ''
    echo -n $version > VERSION
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://wasmedge.org/";
    license = with licenses; [ asl20 ];
    description = "A lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    maintainers = with maintainers; [ dit7ya ];
<<<<<<< HEAD
    platforms = platforms.all;
  };
})
=======
    # error: no member named 'utimensat' in the global namespace
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
