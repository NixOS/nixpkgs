{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, curl
, pkg-config
, protobuf
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage {
  pname = "cargo-component";
  version = "unstable-2023-06-20";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "277728b729577540fdd5977a59a4e51c061c6fcb";
    hash = "sha256-Uu+S4TRbtei78ZNkYNkwHiIot0L7fUODJgd5xDjw8rg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "warg-api-0.1.0" = "sha256-GYmHrGCmEMYCi8S+hd0CuBxkwF4BM1B9pJ1TOGCqHuk=";
    };
  };

  patches = [
    # update dependencies to make it work when dependencies are vendored
    # https://github.com/bytecodealliance/registry/pull/138
    ./update-registry.patch

    # fix build when it is not in a git repository
    # https://github.com/bytecodealliance/cargo-component/pull/92
    (fetchpatch {
      name = "export-wasi-adapter-version-even-if-git-fails.patch";
      url = "https://github.com/bytecodealliance/cargo-component/commit/9b2517fe2c4dbb1077a8785fd79c677ad1b7fc6b.patch";
      hash = "sha256-nY8ltBb8H7zkE2JLhXJiBOMwTM8CVvkXTSHTUyMqamo=";
    })
  ];

  nativeBuildInputs = [
    curl
    pkg-config
    protobuf
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  # requires the wasm32-wasi target
  doCheck = false;

  meta = with lib; {
    description = "A Cargo subcommand for creating WebAssembly components based on the component model proposal";
    homepage = "https://github.com/bytecodealliance/cargo-component";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
