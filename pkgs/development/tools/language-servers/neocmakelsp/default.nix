{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-DPKCAWIDw3ykYp2Cuwt9CcWHgdL7aoW5z2CjVFxizhg=";
  };

  cargoHash = "sha256-wYh5JNT7HJnY6PLFCPm21LNFHsffFq53FTCRkUuHxWY=";

  meta = with lib; {
    description = "CMake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rewine multivac61 ];
    mainProgram = "neocmakelsp";
  };
}
