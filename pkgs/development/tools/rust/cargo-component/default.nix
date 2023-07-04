{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, curl
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage {
  pname = "cargo-component";
  version = "unstable-2023-06-22";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "bd98521c6e13640593ad676d8b6f1e64054755d4";
    hash = "sha256-5r3g158Ujdbpb0NZI1DIu3TGpc3G9XDmXg+mq+/Dayc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "warg-api-0.1.0" = "sha256-M1hbgWqibbq7upfvNarcqAM0fbWL8Z7y+pWpBfVqxiI=";
    };
  };

  patches = [
    # update warg dependencies to make cargo-component work when dependencies
    # are vendored, since the fix has already been merged in warg
    # https://github.com/bytecodealliance/cargo-component/pull/93
    (fetchpatch {
      name = "update-warg-dependencies.patch";
      url = "https://github.com/bytecodealliance/cargo-component/commit/dac67f9eb465efaf11f445bc949bd87f7039a472.patch";
      hash = "sha256-tFJtQJtHAmw4xZ9ADLyQn9+QRxHU1iZZbfXGYaPajg8=";
    })
  ];

  nativeBuildInputs = [
    curl
    pkg-config
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
