{ lib, fetchFromGitHub, rustPlatform, nixUnstable }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-lsp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "v${version}";
    sha256 = "sha256-54dtLkGAbQ4Sln/bs/sI0GaCbXyK8+vDD8QBgxaiCXg=";
  };

  cargoSha256 = "sha256-Tw05eOIMJj+zX0fqtn6wJwolKNkYqfVuo/WO/WvYu2k=";

  checkInputs = [ nixUnstable ];

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
