{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-UjuJTA+MP5EItLD2z/THeh+6dJ2byIrOBqQfUiAWSvk=";
  };

  cargoHash = "sha256-2J+7uwDzoviytbPQ+B36/oJwysBtbiJXKU7zW5vCCEU=";

  meta = with lib; {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
