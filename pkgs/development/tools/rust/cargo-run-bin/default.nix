{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-roeim5enxqklJOW7Qqr+Gci5lUIOW9kn3tlCm8qrEJk=";
  };

  cargoHash = "sha256-A/HlFse2wWOH85oZQvlRaePdF/4YfSL3qroDYGwwi9U=";

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

