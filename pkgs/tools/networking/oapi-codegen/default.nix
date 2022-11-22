{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VjHZjClOiwz6XwbLJFSl6wEkhA5hOo3RNfNte37ZfBc=";
  };

  vendorSha256 = "sha256-XFXe02WTtkzIzpcVN1Vwi+7rTKWlrMWCOV/rrDBRliY=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage    = "https://github.com/deepmap/oapi-codegen";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
