{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PB44m39TDH1z8N3DrxAlZ/FKOdZmpe+U84tbmBBP9VQ=";
  };

  cargoHash = "sha256-FMlirUr3c8QhnTmTHvfNPff7PYlWSl83vCGLOLbyaR4=";

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

