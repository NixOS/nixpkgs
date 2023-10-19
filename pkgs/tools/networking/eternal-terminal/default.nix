{ lib
, stdenv
, fetchFromGitHub
, cmake
, gflags
, libsodium
, openssl
, protobuf
, zlib
, catch2
}:

stdenv.mkDerivation rec {
  pname = "eternal-terminal";
  version = "6.2.4";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    rev = "refs/tags/et-v${version}";
    hash = "sha256-9W9Pz0VrFU+HNpf98I3CLrn8+kpjjNLOUK8gGcDJcI8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gflags
    libsodium
    openssl
    protobuf
    zlib
  ];

  preBuild = ''
    cp ${catch2}/include/catch2/catch.hpp ../external_imported/Catch2/single_include/catch2/catch.hpp
  '';

  cmakeFlags = [
    "-DDISABLE_VCPKG=TRUE"
    "-DDISABLE_SENTRY=TRUE"
    "-DDISABLE_CRASH_LOG=TRUE"
  ];

  CXXFLAGS = lib.optionals stdenv.cc.isClang [
    "-std=c++17"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Remote shell that automatically reconnects without interrupting the session";
    homepage = "https://eternalterminal.dev/";
    changelog = "https://github.com/MisterTea/EternalTerminal/releases/tag/et-v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
