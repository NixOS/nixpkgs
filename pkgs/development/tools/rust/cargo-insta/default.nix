{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "refs/tags/${version}";
    hash = "sha256-GqM3b2evjACNkTOyfA6N6TInuGo9f/1retkXVTgbJ3A=";
  };

  sourceRoot = "source/cargo-insta";

  cargoHash = "sha256-ZIS3O19N7w+sL+2IdoCw4/Hx9Jtjx7MYE7JcEu+PFRA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
