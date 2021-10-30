{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.10";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K/Nptw0AEP7awS/xXCg6T2Ff3WQc7fKTUB/uEg1WOA4=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-Z42t9dGlNbSwNy2N/ZoEejkbIEeUUk87mcYhkTnxhpc=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
