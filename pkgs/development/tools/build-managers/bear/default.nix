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
  version = "3.0.14";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = pname;
    rev = version;
    sha256 = "0qy96dyd29bjvfhi46y30hli5cvshw8am0spvcv9v43660wbczd7";
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

  # 'path' is unavailable: introduced in macOS 10.15
  CXXFLAGS = lib.optional (stdenv.hostPlatform.system == "x86_64-darwin") "-D_LIBCPP_DISABLE_AVAILABILITY";

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
