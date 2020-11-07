{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, grpc
, protobuf
, openssl
, nlohmann_json
, gtest
, fmt
, spdlog
, c-ares
, abseil-cpp
, zlib
}:

stdenv.mkDerivation rec {
  pname = "bear";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = pname;
    rev = version;
    sha256 = "02vzlm48ywf6s3fly19j94k11dqx94x8pgmkq1ylx3z3d1y3b5zb";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    grpc
    protobuf
    openssl
    nlohmann_json
    gtest
    fmt
    spdlog
    c-ares
    abseil-cpp
    zlib
  ];

  patches = [
    # Default libexec would be set to /nix/store/*-bear//nix/store/*-bear/libexec/...
    ./no-double-relative.patch
  ];

  meta = with stdenv.lib; {
    description = "Tool that generates a compilation database for clang tooling";
    longDescription = ''
      Note: the bear command is very useful to generate compilation commands
      e.g. for YouCompleteMe.  You just enter your development nix-shell
      and run `bear make`.  It's not perfect, but it gets a long way.
    '';
    homepage = "https://github.com/rizsotto/Bear";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.babariviere ];
  };
}
