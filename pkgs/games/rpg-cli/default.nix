{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "rpg-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "facundoolano";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ih+1qO/VHkRp766WDe09xXL/pkby+sURopy7m5wRn4Y=";
  };

  cargoSha256 = "sha256-Au7Nlpl4XOSG8rW0DaHFDqBr1kUY5Emyw6ff0htPc+I=";

  # tests assume the authors macbook, and thus fail
  doCheck = false;

  meta = with lib; {
    description = "Your filesystem as a dungeon";
    homepage = "https://github.com/facundoolano/rpg-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
