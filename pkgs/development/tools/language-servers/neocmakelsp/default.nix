{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-SDSqYfnHI6nFJrLUDApYR1nfGdcPdPihrb54gNIRkLU=";
  };

  cargoHash = "sha256-Rlu2m+pbaU+EunQ7pthYPSRZo1yVF/+L114WxCv3l9c=";

  meta = with lib; {
    description = "CMake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rewine multivac61 ];
    mainProgram = "neocmakelsp";
  };
}
