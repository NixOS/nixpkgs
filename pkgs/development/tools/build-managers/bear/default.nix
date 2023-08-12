{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, grpc
, protobuf
, openssl
, nlohmann_json
, gtest
, spdlog
, c-ares
, zlib
, sqlite
, re2
}:

stdenv.mkDerivation rec {
  pname = "bear";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = pname;
    rev = version;
    sha256 = "sha256-x46BS+By5Zj5xeYRD45eXRDCAOqwpkkivVyJPnhkAMc=";
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
    zlib
    sqlite
    re2
  ];

  patches = [
    # Default libexec would be set to /nix/store/*-bear//nix/store/*-bear/libexec/...
    ./no-double-relative.patch

    # Fix compatiblity with fmt 10.0. Remove with the next release
    (fetchpatch {
      url = "https://github.com/rizsotto/Bear/commit/46a032fa0fc8131779ece13f26735ec84be891e8.patch";
      hash = "sha256-zYKwQ5PLSTJ1hROGnTfP8xPoM0cBw6abAZLx6GxmdfI=";
    })
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
