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
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = pname;
    rev = version;
    hash = "sha256-1nZPzgLWcmaRkOUXdm16IW2Nw/p1w8GBGEfZX/v+En0=";
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
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
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
