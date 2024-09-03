{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-t9cFECz4olFQ3VOuZzqHRMuvC8df1qaF7etb9ThJiok=";
  };

  cargoHash = "sha256-m+eO2y6TNRYc9Nau5ma9qcZcj7xUdxjo34eBmuXANkU=";

  meta = with lib; {
    description = "CMake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rewine multivac61 ];
    mainProgram = "neocmakelsp";
  };
}
