{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.6.19";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-nYZ9H66sA5umOTn/w/P62kJy3WHLwYPWWs1B74bTAEM=";
  };

  cargoHash = "sha256-1jpKo/fSWLf0pFgzTvnkaghz/Fdy+MJhZsKQPaJHlfs=";

  meta = with lib; {
    description = "A cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
