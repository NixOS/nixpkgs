{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VAtfJ1PXTSPMoQ4NqX0GcZMyi15edxWj6Xsj6h1b7hc=";
  };

  vendorSha256 = "sha256-s6+Rs+G4z5fcmUiwGjeDoQYKWJz0a/PCejfKyn8WWxs=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage    = "https://github.com/deepmap/oapi-codegen";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
