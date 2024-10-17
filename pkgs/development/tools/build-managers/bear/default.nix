{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  grpc,
  protobuf,
  openssl,
  nlohmann_json,
  gtest,
  spdlog,
  c-ares,
  zlib,
  sqlite,
  re2,
  lit,
  python3,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "bear";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = pname;
    rev = version;
    hash = "sha256-pwdjytP+kmTwozRl1Gd0jUqRs3wfvcYPqiQvVwa6s9c=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config

    # Used for functional tests, which run during buildPhase.
    lit
    python3
  ];

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

  cmakeFlags = [
    # Build system and generated files concatenate install prefix and
    # CMAKE_INSTALL_{BIN,LIB}DIR, which breaks if these are absolute paths.
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    (lib.cmakeBool "ENABLE_UNIT_TESTS" false)
    (lib.cmakeBool "ENABLE_FUNC_TESTS" false)
  ];

  postPatch = ''
    patchShebangs test/bin

    # /usr/bin/env is used in test commands and embedded scripts.
    find test -name '*.sh' \
      -exec sed -ie 's|/usr/bin/env|${coreutils}/bin/env|g' {} +
  '';

  # Functional tests use loopback networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Tool that generates a compilation database for clang tooling";
    mainProgram = "bear";
    longDescription = ''
      Note: the bear command is very useful to generate compilation commands
      e.g. for YouCompleteMe.  You just enter your development nix-shell
      and run `bear make`.  It's not perfect, but it gets a long way.
    '';
    homepage = "https://github.com/rizsotto/Bear";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ DieracDelta ];
  };
}
