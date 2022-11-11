{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZgYUCfqvKvXsgRziW0A7i4Cvntd4U2q9kKXHwBtAA9k=";
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
