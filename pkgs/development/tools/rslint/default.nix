{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rslint";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "rslint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AkSQpGbhRVmDuDAbMzx00BELpI2szJ+rjKo8Qjcug1E=";
  };

  cargoSha256 = "sha256-U8Uf7LG6+dOi+XxRpJrpy0kAqyr8fAlVchE9ZJ+ex/s=";

  cargoBuildFlags = [
    "-p" "rslint_cli"
    "-p" "rslint_lsp"
  ];

  meta = with lib; {
    description = "A fast, customizable, and easy to use JavaScript and TypeScript linter";
    homepage = "https://rslint.org";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
