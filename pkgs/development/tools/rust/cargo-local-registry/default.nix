{ lib
, rustPlatform
, fetchFromGitHub
, curl
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-local-registry";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "dhovart";
    repo = "cargo-local-registry";
    rev = version;
    hash = "sha256-2tSO82XRCUekEBrd9wDzxeg2r2C+F9wgz3ffYFG7+q8=";
  };

  cargoHash = "sha256-vxdQLfr4G73MpPrrcbcQRZGbTHJztUP3FwShj6zFhEY=";

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

  # tests require internet access
  doCheck = false;

  # Cargo.lock is outdated
  preConfigure = ''
    cargo metadata --offline
  '';

  meta = with lib; {
    description = "A cargo subcommand to manage local registries";
    mainProgram = "cargo-local-registry";
    homepage = "https://github.com/dhovart/cargo-local-registry";
    changelog = "https://github.com/dhovart/cargo-local-registry/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
