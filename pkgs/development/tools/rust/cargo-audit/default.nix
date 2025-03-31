{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  zlib,
  stdenv,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.21.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bRBQpZ0YoKDh959a1a7+qEs2vh+dbP8vYcwbkNZQ5cQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MIwKgQM3LoNV9vcs8FfxTzqXhIhLkYd91dMEgPH++zk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    mainProgram = "cargo-audit";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      basvandijk
      figsoda
      jk
    ];
  };
}
