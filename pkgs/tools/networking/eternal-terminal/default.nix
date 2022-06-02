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
  version = "6.1.11";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    rev = "et-v${version}";
    hash = "sha256-cCZbG0CD5V/FTj1BuVr083EJ+BCgIcKHomNtpJb3lOo=";
  };

  preBuild = ''
    cp ${catch2}/include/catch2/catch.hpp ../external_imported/Catch2/single_include/catch2/catch.hpp
  '';

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

  cmakeFlags = [
    "-DDISABLE_VCPKG=TRUE"
    "-DDISABLE_SENTRY=TRUE"
    "-DDISABLE_CRASH_LOG=TRUE"
  ];

  CXXFLAGS = lib.optional stdenv.cc.isClang [
    "-std=c++17"
  ];

  doCheck = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Remote shell that automatically reconnects without interrupting the session";
    homepage = "https://eternalterminal.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
