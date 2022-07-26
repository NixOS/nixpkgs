{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, grpc
, protobuf
, openssl
, nlohmann_json
, gtest
, spdlog
, c-ares
, abseil-cpp
, zlib
, sqlite
, re2
}:

stdenv.mkDerivation rec {
  pname = "bear";
  version = "3.0.20";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = pname;
    rev = version;
    sha256 = "sha256-8hA0Y/AGczFwggxkTG7PQKOVnr2Oizx4OH38nS5jCU0=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    grpc
    protobuf
    openssl
    nlohmann_json
    gtest
    spdlog
    c-ares
    abseil-cpp
    zlib
    sqlite
    re2
  ];

  patches = [
    # Default libexec would be set to /nix/store/*-bear//nix/store/*-bear/libexec/...
    ./no-double-relative.patch
  ];

  meta = with lib; {
    description = "Tool that generates a compilation database for clang tooling";
    longDescription = ''
      Note: the bear command is very useful to generate compilation commands
      e.g. for YouCompleteMe.  You just enter your development nix-shell
      and run `bear make`.  It's not perfect, but it gets a long way.
    '';
    homepage = "https://github.com/rizsotto/Bear";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ babariviere qyliss ];
  };
}
