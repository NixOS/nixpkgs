{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lock";
  version = "8.0.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Xh39gaiTC3g1FHVWqUr8PR/MzeoRaGlCmGZZZnHB4Kc=";
  };

  cargoSha256 = "sha256-gf9KDzGKjZt4p5ldZShH4lOwrieJeI2WJQ8hU4hhGJE=";

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Self-contained Cargo.lock parser with graph analysis";
    homepage = "https://github.com/rustsec/rustsec/tree/main/cargo-lock";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-lock/v${version}/cargo-lock/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
