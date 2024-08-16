{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-CMH+6/YGepl6SJLytfDEu7NLvPA/HHY/sDm2LTi0R8w=";
  };

  cargoHash = "sha256-w3oDpJMsfV9mIWI44YgOsNZH2vahSRCSJnYpFWBx/eU=";

  meta = with lib; {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
