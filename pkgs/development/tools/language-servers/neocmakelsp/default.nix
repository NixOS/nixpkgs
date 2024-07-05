{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-IfseZsHCSuF1zGq8u3mPju0gxVtR0a7ibHV+tEK6wh0=";
  };

  cargoHash = "sha256-QaoyaeFfoxVoTh4Sg/6EXYPsUD1nNG7MPSH2EeYMLn0=";

  meta = with lib; {
    description = "Cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
