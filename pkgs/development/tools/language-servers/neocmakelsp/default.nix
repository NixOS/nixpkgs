{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-l6jhdTPtt+OPZOzsRJ4F9VVFaLYhaoUUjqtiP40ADPE=";
  };

  cargoHash = "sha256-LgkcVlUCILRmYd+INLe4FiexR+Exmc/tPIYQ+hUypMc=";

  meta = with lib; {
    description = "A cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
