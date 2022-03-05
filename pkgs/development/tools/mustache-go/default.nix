{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mustache-go";
  version = "1.3.0";

  goPackagePath = "github.com/cbroglie/mustache";

  src = fetchFromGitHub {
    owner = "cbroglie";
    repo = "mustache";
    rev = "v${version}";
    sha256 = "sha256-Z33hHOcx2K34v3j/qFD1VqeuUaqH0jqoMsVZQnLFx4U=";
  };

  meta = with lib; {
    homepage = "https://github.com/cbroglie/mustache";
    description = "The mustache template language in Go";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ Zimmi48 ];
    mainProgram = "mustache";
  };
}
