{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.40";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "83f33653b687c84823fe6af00806107e1dd4f4b8";
    hash = "sha256-eau5h75oZpxufTrf0fLHfr+3TIOFXB/kSgHX+o2GtiE=";
  };

  cargoHash = "sha256-OqM8SERSWHtbvW6SZfM7lOrQZu66uzsv5wiD3Iqaf3s=";

  checkFlags = [
  # Depends on `rustfmt` and does not matter for packaging.
  "--skip=utils::test_format_rust_expression"
  # Requires networking
  "--skip=test_force_update_snapshots"
  ];

  meta = with lib; {
    description = "Cargo subcommand for snapshot testing";
    mainProgram = "cargo-insta";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda oxalica matthiasbeyer ];
  };
}
