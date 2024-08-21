{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-pP6iIgpY3wI2Yhtu9NXAyB5tQgKqC9yzbC0IwalzhiI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-DBbcfq2ON05BXGRgtZ4Sze8rAz4Eu23pOk1AEYScVbg=";

  meta = with lib; {
    description = "Better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
