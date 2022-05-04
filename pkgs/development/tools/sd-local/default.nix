{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.40";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/b9ZmwTw9DbdO0KI7rfT0YW0Xo2cxfwhk1TEfTe3ySU=";
  };

  vendorSha256 = "sha256-43hcIIGqBscMjQzaIGdMqV5lq3od4Ls4TJdTeFGtu5Y=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
