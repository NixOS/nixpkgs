{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rslint";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rslint";
    repo = pname;
    rev = "v${version}";
    sha256 = "12329x39zqmgl8zf228msdcdjfv3h11dmfha1kiwq71jvfga2v10";
  };

  cargoSha256 = "sha256-/pZ6jQ/IdLLFdFTvmbXZKCw9HhnTkSSh6q79Rpbtfz8=";

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
