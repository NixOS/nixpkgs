{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OfXwrESYwJ1rAcL8q2OlYhMom4iiYJ5N//a3TIp4FwY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "char-name-0.1.0" = "sha256-hElcqzsfU6c6HzOqnUpbz+jbNGk6qBS+uk4fo1PC86Y=";
      "sml-libs-0.1.0" = "sha256-0gRiXJAGddrrbgI3AhlWqVKipNZI0OxMTrkWdcSbG7A=";
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
