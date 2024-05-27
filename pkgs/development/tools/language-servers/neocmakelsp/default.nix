{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.6.26";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-9pCi7bevgE2tO0n1LvhLIcFV8sVpAagkVB8l5WWdIbM=";
  };

  cargoHash = "sha256-xm+8IDLvPDOFJ6FyeQdpbWgQ9XE6bW5i29W0S9JSQzc=";

  meta = with lib; {
    description = "A cmake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "neocmakelsp";
  };
}
