{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-0HWv0o0wmcRomLQul99RjGAF+/qKBK6SGeNOFRTHiCc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-nsF6rInbM1Eshi2B4AYxkHj+DBrPc2doCtZSeBfs5b0=";

  meta = with lib; {
    description = "A better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
