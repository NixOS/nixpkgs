{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  # use stable release once 1.40 lands
  version = "1.39-unstable-2024-08-22";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "abb6ba50163fb9093fa79c2fb784a57e08b2fcc0";
    hash = "sha256-465xY68M00lBM+3pz8FIXkBXnRrMi4wbBRieYHz0w+s=";
  };

  cargoHash = "sha256-2mf9GJ1BtZE1k9jIdFmjiK1KfQ9qPkeSABT8X7G+p9I=";

  # Depends on `rustfmt` and does not matter for packaging.
  checkFlags = [ "--skip=utils::test_format_rust_expression" ];

  meta = with lib; {
    description = "Cargo subcommand for snapshot testing";
    mainProgram = "cargo-insta";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda oxalica matthiasbeyer ];
  };
}
