{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FPkZk5qKHrRR3V8s04yLgOVOKj+Rln3Cu/VW2bnr2fE=";
  };

  cargoHash = "sha256-aFHuIEDpGCel1FC7D0hTUmzHbEj7wVarsE0wNZ/3Khw=";

  # multiple impurities in tests
  doCheck = false;

  meta = with lib; {
    description = "Build, cache, and run binaries scoped in Cargo.toml rather than installing globally. This acts similarly to npm run and gomodrun, and allows your teams to always be running the same tooling versions";
    homepage = "https://github.com/dustinblackman/cargo-run-bin";
    changelog = "https://github.com/dustinblackman/cargo-run-bin/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mightyiam matthiasbeyer ];
  };
}

