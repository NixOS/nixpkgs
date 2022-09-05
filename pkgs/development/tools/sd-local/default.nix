{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.43";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qFEug8fGOi5IwnA1P3FHKte7eiviNk/x8SdDss9J5vo=";
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
