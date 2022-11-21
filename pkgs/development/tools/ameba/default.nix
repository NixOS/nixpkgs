{ lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "v${version}";
    hash = "sha256-SZ2sBQeZgtPOYioH9eK5MveFtWVGPvgKMrqsCfjoRGM=";
  };

  format = "make";

  meta = with lib; {
    description = "A static code analysis tool for Crystal";
    homepage = "https://crystal-ameba.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}
