{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-++MD7XYWJ4Oim/VSYSisu/DwazOEfQ4CJNLfR5sjP3M=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-lWImtmtoo3ujbHvaeijuVjt0NQhdp+mxuu8oxNutr2E=";

  meta = with lib; {
    description = "A better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
