{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-vxdXW74XRZONmLURGEHnyg4Z71uvD6/JzxVqkNqyxdo=";
  };

  cargoHash = "sha256-otEpfykVTJ0DH9n3kO4G/BO2VD6RGp9N6/UX6UAs2jU=";

  meta = with lib; {
    description = "Cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
