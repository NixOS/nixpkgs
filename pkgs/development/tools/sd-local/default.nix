{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.42";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xPskMKInmaWi5dwx5E5z1ssTQ6Smj1L40Voy++g7Rhs=";
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
