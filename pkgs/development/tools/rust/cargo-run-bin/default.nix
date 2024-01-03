{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-run-bin";
  version = "1.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1+Xt+q2PgqMrSXhOkZ6+m1tqmgKICuIZe7vEmdSDdqI=";
  };

  cargoHash = "sha256-+avbhdKLUMqPFI8A/0w+Bne9/8KOKAJxJIMa4pSgRXs=";

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

