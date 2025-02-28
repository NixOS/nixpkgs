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
  version = "0.21.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-h8fB+aA/MPeOm9w9Clf4IAR/h1yRGwUU8EoWCJ3JaMc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LMExTkuk7v2YkqzmsjAn1jHgteAHRzGoLG8sGvYwd3c=";

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
