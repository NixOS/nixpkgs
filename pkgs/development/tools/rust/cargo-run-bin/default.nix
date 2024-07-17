{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.7.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-VMlia5EEnNiNkOzwdTZwoaKtAxHz5xAxxnGlGoSbD80=";
  };

  cargoHash = "sha256-DFsDUoYq+TE8ifwQIl5YfoeUl8udIf1z35rFmLe/4To=";

  # multiple impurities in tests
  doCheck = false;

  meta = with lib; {
    description = "Build, cache, and run binaries scoped in Cargo.toml rather than installing globally. This acts similarly to npm run and gomodrun, and allows your teams to always be running the same tooling versions";
    mainProgram = "cargo-bin";
    homepage = "https://github.com/dustinblackman/cargo-run-bin";
    changelog = "https://github.com/dustinblackman/cargo-run-bin/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      mightyiam
      matthiasbeyer
    ];
  };
}
