{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fre";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "camdencheek";
    repo = "fre";
    rev = "v${version}";
    hash = "sha256-cYqEPohqUmewvBUoGJQfa4ATxw2uny5+nUKtNzrxK38=";
  };

  cargoHash = "sha256-BEIrjHsIrNkFEEjCrTKwsJL9hptmVOI8x3ZWoo9ZUvQ=";

  meta = with lib; {
    description = "A CLI tool for tracking your most-used directories and files";
    homepage = "https://github.com/camdencheek/fre";
    changelog = "https://github.com/camdencheek/fre/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gaykitty ];
    mainProgram = "fre";
  };
}
