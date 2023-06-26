{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.5.18";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-3Bv1tRskxQ4Fk+gEGCYRq8WtkBHYP2VjirtTZ3SWJlQ=";
  };

  cargoHash = "sha256-O8E5PmXYrNOB8fXFs5ar30c1X5flIQZ/lrRSl/3XH+o=";

  meta = with lib; {
    description = "A cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
