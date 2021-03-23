{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gllvm";
  version = "1.3.0";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "v${version}";
    sha256 = "sha256-nu6PRFk+GoN1gT1RTbX6mTPZByAGf0bSsj2C5YriGp8=";
  };

  meta = with lib; {
    homepage = "https://github.com/SRI-CSL/gllvm";
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
