{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-V8bbJg7h/TCv0y8Kwz3h6XMKtxKjJKduCj9e1vcd6AQ=";
  };

  cargoHash = "sha256-kR4QJ1QFewI5jKPX9/P1z5J9hnWBIhWExF6JgmDzoJw=";

  meta = with lib; {
    description = "Cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
