{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, sqlite
, stdenv
, darwin
, nixosTests
, rocksdb
, rust-jemalloc-sys
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-conduit";
  version = "0.7.0";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "conduit";
    rev = "v${version}";
    hash = "sha256-6osKiwEm3H7NR8vuOaD5Jlns5alfgprg+c3D98msxcE=";
  };

  # We have to use importCargoLock here because `cargo vendor` currently doesn't support workspace
  # inheritance within Git dependencies, but importCargoLock does.
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ruma-0.9.4" = "sha256-ICz2Mi94XA2os3dTBLWTL4B60Dopw2u0Fq/mM3HoG2A=";
    };
  };

  # Conduit enables rusqlite's bundled feature by default, but we'd rather use our copy of SQLite.
  preBuild = ''
    substituteInPlace Cargo.toml --replace "features = [\"bundled\"]" "features = []"
    cargo update --offline -p rusqlite
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    sqlite
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  };

  # tests failed on x86_64-darwin with SIGILL: illegal instruction
  doCheck = !(stdenv.isx86_64 && stdenv.isDarwin);

  passthru.tests = {
    inherit (nixosTests) matrix-conduit;
  };

  meta = with lib; {
    description = "Matrix homeserver written in Rust";
    homepage = "https://conduit.rs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pstn pimeys ];
    mainProgram = "conduit";
  };
}
