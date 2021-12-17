{ lib, stdenv
, fetchFromGitHub
, cmake
, gflags
, libsodium
, openssl
, protobuf
, zlib
}:

stdenv.mkDerivation rec {
  pname = "eternal-terminal";
  version = "6.1.9";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    rev = "et-v${version}";
    sha256 = "0kpabxpy779ppkaqaigq0x34ymz1jcwpsa78rm6nr55mdap2xxv6";
  };

  cmakeFlags= [
    "-DDISABLE_VCPKG=TRUE"
    "-DDISABLE_SENTRY=TRUE"
    "-DDISABLE_CRASH_LOG=TRUE"
  ];

  CXXFLAGS = lib.optional stdenv.cc.isClang "-std=c++17";
  LDFLAGS = lib.optional stdenv.cc.isClang "-lc++fs";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gflags openssl zlib libsodium protobuf ];

  meta = with lib; {
    description = "Remote shell that automatically reconnects without interrupting the session";
    license = licenses.asl20;
    homepage = "https://eternalterminal.dev/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg pingiun ];
  };
}
