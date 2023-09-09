{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, withSimd ? stdenv.isx86_64
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-ip5phYOoUm7I0SsnfXVGzgt+OFXjXKt4hiFjH3nkacA=";
  };

  cargoHash = "sha256-T2aR3PCQ5BcJZ+Aw/yLJ6vbLxkrKrNnsZkXwo0G9BZE=";

  buildNoDefaultFeatures = !withSimd;

  cargoBuildFlags = [ "-p=rsonpath" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Blazing fast Rust JSONPath query engine";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rq";
  };
}
