{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.7.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-VhDCOTabj/HHc6bYdAUOErvxXOzyY3+e7GccZcb1cSQ=";
  };

  cargoHash = "sha256-riWWxv3FsBrgzVUWGtKvV4WjhgsXImLpiS9EJ40kCn8=";

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

