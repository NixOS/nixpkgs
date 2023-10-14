{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-imp7TzSVWo6l23tQu2oMMdVj/3sT9mU+lIBc0cVwO+s=";
  };

  cargoHash = "sha256-TQOFXFdfD4iVy4K9IjcX0L7zLeNw9RAHb2WE5rERP/0=";

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

