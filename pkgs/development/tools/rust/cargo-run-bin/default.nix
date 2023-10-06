{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-NWXyy2VgVjEftD2Zl6TbpJnXVTi4UUNSomHCv9Gnkrk=";
  };

  cargoHash = "sha256-eiRKWV+xMyyv61FIBJWt0B12e6mn+G1kW0LpyCMuWWc=";

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

