{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pgCsDbFYRN7QMAIzgdNn0vo/KLAZzMgjzil0AjxjKEc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "char-name-0.1.0" = "sha256-pLzkXx0twW4X3iHeiUT6KwEzXxYk0IhwISRqeaJVjvo=";
      "sml-libs-0.1.0" = "sha256-zQrhH24XlA9SeQ+sVzaVwJwrm80TRIjFq99Vay7QEN8=";
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
    changelog = "https://github.com/azdavis/millet/blob/v${version}/docs/CHANGELOG.md";
    license = [ licenses.mit /* or */ licenses.asl20 ];
    maintainers = with maintainers; [ marsam ];
    mainProgram = "millet-ls";
  };
}
