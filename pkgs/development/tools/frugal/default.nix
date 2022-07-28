{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.16.1";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u8+4wBadgyzw1XfZChmI/K2nkSoRZ0Yp+Q8V7NrDQ3E=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-QtF2MdZCO6CsoRD25yaQ6h8n/j/9fHogJaVZNQ2RbDs=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
