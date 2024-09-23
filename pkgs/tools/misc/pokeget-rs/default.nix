{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-0dss+ZJ1hhQGpWySWhyF+T1T+G3BlnKfSosgCJa8MPE=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-VYF2uhgxUFH/VAy/ttQOULRFFiPRf0D+0WfGlQyYDGc=";

  meta = with lib; {
    description = "Better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
