{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-edIm1O+LQdmKhH8/5WuSsxVtOcf3VlkObGjIY+30mms=";
  };

  vendorSha256 = "sha256-lhWnPZavtBEa4A76rvr0xw3L5W6HYK1Uw+PW8z8gWuU=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage    = "https://github.com/deepmap/oapi-codegen";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
