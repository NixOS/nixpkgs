{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.54";

  src = fetchFromGitHub {
    owner = "est31";
    repo = "cargo-udeps";
    tag = "v${version}";
    hash = "sha256-R4t1mzXX95rVbEuHvoAnxxEYt7XYg+Bmr8Mh4LIhnMs=";
  };

  cargoHash = "sha256-DigRCz9BicNI+bkEwdJEKy9i0pT9HAhLsN56hAbEzUI=";

  nativeBuildInputs = [ pkg-config ];

  # TODO figure out how to use provided curl instead of compiling curl from curl-sys
  buildInputs = [ openssl ];

  # Requires network access
  doCheck = false;

  meta = {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    changelog = "https://github.com/est31/cargo-udeps/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      b4dm4n
      matthiasbeyer
    ];
    mainProgram = "cargo-udeps";
  };
}
