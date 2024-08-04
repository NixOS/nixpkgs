{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  # use stable release once 1.40 lands
  version = "1.39-unstable-2024-08-04";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "16d243d562221f4b3ea358980418014325e60637";
    hash = "sha256-wZ7JvPwMy76O8nkF3RkcIIRe8g1OVUsHpZxAuDSN248=";
  };

  cargoHash = "sha256-UknrIWu83t2O/hdt7IaYLBxBz2y5dxOfKYrI9wa7AIM=";

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
