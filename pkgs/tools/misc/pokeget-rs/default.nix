{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-Epet0CG4p7ruKHYVx0rX7KeOAe9kCer6Y8bguOY9SUs=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-gakrHutB6KBYcSZce/MDDnHK6VRPHU2B2xwtmUi4ZWY=";

  meta = with lib; {
    description = "Better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
