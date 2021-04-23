{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-doJ1ceuJ/gL9vlGgV/hKIJeAErAseH0dtHKJX2z7pV0=";
  };

  vendorSha256 = "sha256-Y4WM+o+5jiwj8/99UyNHLpBNbtJkKteIGW2P1Jd9L6M=";

  # Tests use network
  doCheck = false;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage    = "https://github.com/deepmap/oapi-codegen";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
