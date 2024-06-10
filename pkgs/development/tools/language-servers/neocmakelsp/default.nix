{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-rMonXAggCsMWvyNmGu+crtw0a4zfhKJOR5GnIULWe1g=";
  };

  cargoHash = "sha256-09mpr7ncqK9c5AMhRSAe/K9pE3vXC3bxEXX3hIx3E7c=";

  meta = with lib; {
    description = "Cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
