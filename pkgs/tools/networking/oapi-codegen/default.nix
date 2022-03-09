{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Po0HCAK9h1GWSfKzV+1j3ddikCNIULbywx501GvRT/Q=";
  };

  vendorSha256 = "sha256-GSNNOWhWpXRJEIzLoBci25sp9pu0W1mS18G8eFOsfhw=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage    = "https://github.com/deepmap/oapi-codegen";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
