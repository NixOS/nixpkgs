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
  version = "0.21.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oMXpJE49If4QKE80ZKhRpMRPh3Bl517a2Ez/1VcaQJQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RY1cAsVi76N1jaWL+t0lfayChGPrL9T05xoFfFPTni4=";

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
