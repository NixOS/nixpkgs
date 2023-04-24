{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "dot-language-server";
  version = "1.1.27";

  src = fetchFromGitHub {
    owner = "nikeee";
    repo = "dot-language-server";
    rev = "v${version}";
    hash = "sha256-Dha6S+qc9rwPvxUkBXYUomyKckEcqp/ESU/24GkrmpA=";
  };

  npmDepsHash = "sha256-nI8xPCTZNqeGW4I99cDTxtVLicF1MEIMTPRp7O0bFE4=";

  npmBuildScript = "compile";

  meta = with lib; {
    description = "A language server for the DOT language";
    homepage = "https://github.com/nikeee/dot-language-server";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
