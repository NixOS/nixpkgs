{ lib
, rustPlatform
, fetchFromGitHub
, testers
, hex
}:

rustPlatform.buildRustPackage rec {
  pname = "hex";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sitkevij";
    repo = "hex";
    rev = "v${version}";
    hash = "sha256-0LUT86mtqkscTfWNj2WHdMUizq0UQMCqXqTE0HRUItc=";
  };

  cargoHash = "sha256-BDDAKr6F9KtZGKX6FjasnO8oneZp0cy0M9r0tyqxL+o=";

  passthru.tests.version = testers.testVersion {
    package = hex;
    version = "hx ${version}";
  };

  meta = with lib; {
    description = "Futuristic take on hexdump, made in Rust";
    homepage = "https://github.com/sitkevij/hex";
    changelog = "https://github.com/sitkevij/hex/releases/tag/v${version}";
    mainProgram = "hx";
    license = licenses.mit;
    maintainers = with maintainers; [ ivar ];
  };
}
