{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.6.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-B4tkP2QuL3MFQn3iAPg4TMJfFbn1D8w/C1OX+TbpgSE=";
  };

  cargoHash = "sha256-tn+NqugSK5R/lIQVF1URWoDbdsSCvi5tjdjOlT293tg=";

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

