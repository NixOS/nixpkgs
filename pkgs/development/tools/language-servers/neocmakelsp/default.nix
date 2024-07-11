{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-oYvjMpZcXIpOA/osVCOy2NxkFnEQePGf4le22M1bFPA=";
  };

  cargoHash = "sha256-kcqq4xnCxGIGCFlmm4EDc9ZfQHBi6k/xrhIyZ+eKs34=";

  meta = with lib; {
    description = "Cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
