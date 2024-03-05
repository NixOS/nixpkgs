{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mask";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "jacobdeichert";
    repo = pname;
    rev = "mask/${version}";
    hash = "sha256-pi8dD4Fko39yn1maXNOqm+aDWYJhxE/b4kH7H18InbY=";
  };

  cargoHash = "sha256-zbvYSTR0m7S4m0WFQrCqCrMXqMcDW2oIMznD5PDdeHE=";

  # tests require mask to be installed
  doCheck = false;

  meta = with lib; {
    description = "A CLI task runner defined by a simple markdown file";
    homepage = "https://github.com/jacobdeichert/mask";
    changelog = "https://github.com/jacobdeichert/mask/blob/mask/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
