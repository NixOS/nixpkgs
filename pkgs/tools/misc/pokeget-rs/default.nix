{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.4.2-2";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-RPdtwHJsXdjIAeJP/LPdJ7GjwdIngM3eZO/A8InTpXQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-JeRSBG1HswttHOGyiNseFf2KiWkumrzEIw76A80nQHM=";

  meta = with lib; {
    description = "A better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
