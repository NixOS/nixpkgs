{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libgit2_1_5
, openssl
, zlib
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.18.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-XK2SsyT4CyDjCF56v/g7tX5SZKC3krBQNs/ddeFu35A=";
  };

  cargoHash = "sha256-1Uifk1W7NCmHAbUl83GpMUBD6WWUl1J/HjtGv4dEuiA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_5
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}
