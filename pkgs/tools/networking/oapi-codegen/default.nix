{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8hyRuGKspWqv+uBeSz4i12Grl83EQVPWB1weEVf9yhA=";
  };

  vendorSha256 = "sha256-YCZzIsu1mMAAjLGHISrDkfY4Lx0az2SZV8bnZOMalx8=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage    = "https://github.com/deepmap/oapi-codegen";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
