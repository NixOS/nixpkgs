{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  stdenv,
  curl,
  CoreFoundation,
  CoreServices,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.15.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+GPP8Mdoc3LsR2puNu3/pzKg4Umvjd7CxivkHC8YxgM=";
  };

  cargoHash = "sha256-8sW4d9qb7psoHuftQweChTPt4upKPEXdnjHSZAPpBHE=";

  # Note: bump `time` dependency to be able to build with rust 1.80, should be removed on the next
  # release (see: https://github.com/NixOS/nixpkgs/issues/332957)
  # Upstream PR: https://github.com/kbknapp/cargo-outdated/pull/398
  cargoPatches = [ ./time.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      curl
      CoreFoundation
      CoreServices
      Security
      SystemConfiguration
    ];

  meta = with lib; {
    description = "Cargo subcommand for displaying when Rust dependencies are out of date";
    mainProgram = "cargo-outdated";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      ivan
      matthiasbeyer
    ];
  };
}
