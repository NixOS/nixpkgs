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
  version = "0.18.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mBY4M0phjwWS2qWTlVSjLpD0lzMDutMRMbAerbMSXmI=";
  };

  cargoHash = "sha256-bBcyJxlb18Bf76GOR6anTNQYqRpYs3dkGVy9rC5au5k=";

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
