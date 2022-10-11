{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.45";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ziCDuGpvBPKC3p+kuPi5+Hjfkld/Kh0ZqnLKwdMrXNM=";
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
