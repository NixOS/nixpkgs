{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-UAkSMdHukwxDzOU/sIOuTazBbD68ORIGAWuwRxoC+EY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-A5bDZU/L3G2RWbc3Y6KEQAmLS4RuNSG+ROypxINlwLk=";

  meta = with lib; {
    description = "A better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
