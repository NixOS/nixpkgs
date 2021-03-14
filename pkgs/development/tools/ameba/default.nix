{ lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "v${version}";
    sha256 = "sha256-9oLVv0fCJzYyBApR4yzQKc25Uz9X5Rrvj638yD0JDMU=";
  };

  meta = with lib; {
    description = "A static code analysis tool for Crystal";
    homepage = "https://crystal-ameba.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}
