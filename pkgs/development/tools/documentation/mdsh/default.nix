{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    hash = "sha256-Y8ss/aw01zpgM6Z6fCGshP21kcdSOTVG/VqL8H3tlls=";
  };

  cargoSha256 = "sha256-8o4gN6mqUU+o80IqlAYAD5qpZBSQ/FY5HoNbpwzTm0A=";

  meta = with lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    mainProgram = "mdsh";
  };
}
