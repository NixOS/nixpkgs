{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fundoc";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "csssr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nd03c2lz07ghaab67kgl5pw8z8mv6kwx3xzr4pqr7v5b983py6v";
  };

  cargoSha256 = "sha256-6riBlCyqNN2nzgwfVfbRy1avT9b0PdetOrbmbaltsjE=";

  meta = with lib; {
    description = "Language agnostic documentation generator";
    homepage = "https://github.com/csssr/fundoc";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
