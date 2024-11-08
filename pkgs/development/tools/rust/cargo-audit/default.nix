{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, zlib
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.20.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1HLs7j8opRma3WaHbqeTqG0iJOgD0688/7p/+jrNPAg=";
  };

  cargoHash = "sha256-Cd8K/Y+vWWuneeE52yaYgvg9NdBqW+QjUC5XLVVIgc0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}
