{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-C7pEe9nScJ/ORJJrUDo6pADKceKoagHGP/X/asR1PcM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-gPPtVFSaaSL0QBXxHpslVdon3XVCVx1E5cfEP1Ffa9g=";

  meta = with lib; {
    description = "A better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
