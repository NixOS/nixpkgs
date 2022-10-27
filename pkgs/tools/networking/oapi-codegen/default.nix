{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KeMtop91aTylBX95ZJQmveHaYDCYqcKMbPO9YDAfYoI=";
  };

  vendorSha256 = "sha256-Zt4a4riAzmXNn/mawkMqt9f5lmow1zqnWLiLLQsTG9M=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage    = "https://github.com/deepmap/oapi-codegen";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
