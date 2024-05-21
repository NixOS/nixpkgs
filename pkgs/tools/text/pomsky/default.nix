{ lib, rustPlatform, fetchFromGitHub, pkg-config, oniguruma }:

rustPlatform.buildRustPackage rec {
  pname = "pomsky";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "pomsky-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BoA59P0jzV08hlFO7NPB9E+fdpYB9G50dNggFkexc/c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "onig_sys-69.8.1" = "sha256-NJv/Dooh93yQ9KYyuNBhO1c4U7Gd7X007ECXyRsztrY=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  # thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: invalid option '--test-threads''
  doCheck = false;

  meta = with lib; {
    description = "A portable, modern regular expression language";
    mainProgram = "pomsky";
    homepage = "https://pomsky-lang.org";
    changelog = "https://github.com/pomsky-lang/pomsky/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
