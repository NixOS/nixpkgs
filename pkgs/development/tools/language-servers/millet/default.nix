{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-swT16F/gOHiAeZGrD9O4THIHMXDQOpsaUsSjhpkw3fU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "char-name-0.1.0" = "sha256-hO7SO1q5hPY5wJJ8A+OxxCI7GeHtdMz34OWu9ViVny0=";
      "sml-libs-0.1.0" = "sha256-+sxaPBG5qBIC195BFQYH8Yo6juuelGZzztCUiS45WRg=";
    };
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [ "--package" "millet-ls" ];

  cargoTestFlags = [ "--package" "millet-ls" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/CHANGELOG.md";
    license = [ licenses.mit /* or */ licenses.asl20 ];
    maintainers = with maintainers; [ marsam ];
    mainProgram = "millet-ls";
  };
}
