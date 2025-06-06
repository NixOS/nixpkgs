{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rslint";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "rslint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3DEwi+bhqwP8aMpZYl07GZbe7IecraB3m54lZ5LViVc=";
  };

  cargoSha256 = "sha256-bqF5v52uxbvmVmphXAmcWlCI6nbQzZemCxlTcqhRDTY=";

  cargoBuildFlags = [
    "-p" "rslint_cli"
    "-p" "rslint_lsp"
  ];

  meta = with lib; {
    description = "Fast, customizable, and easy to use JavaScript and TypeScript linter";
    homepage = "https://rslint.org";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
