{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mask";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "jacobdeichert";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mPnykI3scTBzGjDa8nawWYRvZBkq74/t5WMbMbs3zVE=";
  };

  cargoSha256 = "sha256-h58MA3F4UA4gp64UPnK6Tvlvr4PFvrVKmjp48lZjH68=";

  # tests require mask to be installed
  doCheck = false;

  meta = with lib; {
    description = "A CLI task runner defined by a simple markdown file";
    homepage = "https://github.com/jacobdeichert/mask";
    changelog = "https://github.com/jacobdeichert/mask/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
