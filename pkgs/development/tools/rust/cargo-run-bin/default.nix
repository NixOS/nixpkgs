{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.1.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YCWjdY8feiqU4/bOn19qbY8YiKa3SvFImvH0wDKXOhI=";
  };

  cargoSha256 = "sha256-mNJZjEkuUwo/aqyotqjNj+P50dFFGaJnLQ2CyCYg/1Y=";

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

