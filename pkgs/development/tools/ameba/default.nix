{ lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "refs/tags/v${version}";
    hash = "sha256-NwmsNz9YfHDk0hVwVb5zczuzvErrwPhd3rs75t/Fj+I=";
  };

  format = "make";

  meta = with lib; {
    description = "A static code analysis tool for Crystal";
    mainProgram = "ameba";
    homepage = "https://crystal-ameba.github.io";
    changelog = "https://github.com/crystal-ameba/ameba/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}
