{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pGkTCOQ2OR/9c5+L9UgESJjSMmz9FjfJw9NB8Nr6gRQ=";
  };

  vendorSha256 = "sha256-hvY64cmfvEeHniscD1WDyaeFpWeBJwsDNwr76e9F6ow=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage    = "https://github.com/deepmap/oapi-codegen";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
