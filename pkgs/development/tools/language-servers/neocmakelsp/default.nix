{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-ZLZGPigZSrW2C909Kc8t0U3+5sWRGkhT820fl+k37x4=";
  };

  cargoHash = "sha256-dONoaLX2nlnJIjnRPSgQ5oHWqWw632nSpoWUOiU0w58=";

  meta = with lib; {
    description = "A cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
