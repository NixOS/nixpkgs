{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Sgj4+akOs/3fnpP0YDoRY9WwSk4uwtIPyPilutDXOlE=";
  };

  vendorHash = "sha256-8EfOtCiYCGmhGtZdPiFyNzBj+QsPx67vwFDMZ6ATidc=";

  meta = with lib; {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nk";
  };
}
