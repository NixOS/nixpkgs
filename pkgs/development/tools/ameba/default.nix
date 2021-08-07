{ lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "v${version}";
    sha256 = "sha256-oZdaHV+vnYUiCXNMrSuHvZzDYDgFZsoD715DE3tJ2bE=";
  };

  meta = with lib; {
    description = "A static code analysis tool for Crystal";
    homepage = "https://crystal-ameba.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}
