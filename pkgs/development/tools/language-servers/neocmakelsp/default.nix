{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.6.20";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-ZeaQgGD8XsbSfg5vxT165JLPybPsmmqqsbJiG0CaL7Y=";
  };

  cargoHash = "sha256-ljbJ+ZeCtDr8OlGgZ5kgO31chs7/ZD3UfHkq3vWx+h8=";

  meta = with lib; {
    description = "A cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
