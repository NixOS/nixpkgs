{ lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "refs/tags/v${version}";
    hash = "sha256-coZU3cufQgSCid10zEvmHG7ddLbZhnrvl9ffw4Y6h74=";
  };

  format = "make";

  meta = with lib; {
    description = "A static code analysis tool for Crystal";
    homepage = "https://crystal-ameba.github.io";
    changelog = "https://github.com/crystal-ameba/ameba/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}
