{ lib, fetchFromGitHub, fetchpatch, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "refs/tags/v${version}";
    hash = "sha256-TdyEnTloaciSpkPmnm+OM75sz9jaCaQ3VoDEepfescU=";
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
